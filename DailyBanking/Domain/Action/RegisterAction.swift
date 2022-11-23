//
//  RegisterAction.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 15..
//

import BankAPI
import Combine
import CryptoKit
import CryptoSwift
import Foundation
import Resolver

/*
429 TOO_SOON_OTP_REQUEST
429 TOO_MANY_OTP_REQUEST
429 TOO_MANY_OTP_TRY
400 WRONG_OTP
408 OTP_EXPIRED
423 BLOCKED
 */

enum VerifyOtpError: Error {
    case tooManyTry
    case wrongOtp(remainingAttempts: Int)
    case expired
}

enum ResendOtpError: Error {
    case tooManyRequests
    case tooSoonRequest
}

enum RegisterError: Error {
    case notAllowed
    case temporaryBlocked(blockedTime: Int)
}

enum DeviceActivationError: Error {
    case unauthorized(remainingAttempts: Int)
    case temporaryBlocked(blockedTime: Int)
    case blocked
}

enum VerifyPhoneError: Error, Equatable {
    case phoneNumberAlreadyRegistered
}

protocol RegisterAction: AutoMockable {
    func activateDevice(
        phoneNumber: String,
        passwordHash: String
    ) -> AnyPublisher<Never, ActionError<DeviceActivationError>>

    func register(
        phoneNumber: String,
        email: String,
        passwordHash: String
    ) -> AnyPublisher<Never, ActionError<RegisterError>>

    func resendOtp(
        phoneNumber: String
    ) -> AnyPublisher<Never, ActionError<ResendOtpError>>

    func verifyOTP(
        otp: String
    ) -> AnyPublisher<Never, ActionError<VerifyOtpError>>

    func verify(
        phoneNumber: String
    ) -> AnyPublisher<Never, ActionError<VerifyPhoneError>>

    func setupDeviceAuthentication(
        pin: PinCode
    ) -> AnyPublisher<Never, AnyActionError>
}

class RegisterActionImpl: RegisterAction {
    @Injected private var tokenStore: any TokenStore
    @Injected private var draftStore: any RegistrationDraftStore
    @Injected private var api: APIProtocol
    @Injected private var verifyOTPMapper: Mapper<VerifyOtpMutation.Data, Token>
    @Injected private var otpGenerator: OtpGenerator
    @Injected private var authKeyStore: any AuthenticationKeyStore
    @Injected private var device: DeviceInformation

    private var deviceModel: String {
        device.model
    }

    private var deviceId: String {
        device.id.sha512()
    }

    func verify(
        phoneNumber: String
    ) -> AnyPublisher<Never, ActionError<VerifyPhoneError>> {
        let query = VerifyPhoneQuery(phoneNumber: phoneNumber)
        return api.publisher(for: query, cachePolicy: .fetchIgnoringCacheCompletely)
            .tryMap({ response -> Void in
                if response.verifyPhone.status == .ok {
                    return ()
                } else {
                    throw VerifyPhoneError.phoneNumberAlreadyRegistered
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: VerifyPhoneError.self)
    }

    func register(
        phoneNumber: String,
        email: String,
        passwordHash: String
    ) -> AnyPublisher<Never, ActionError<RegisterError>> {
        let mutation = RegisterMutation(
            email: email,
            password: passwordHash,
            phoneNumber: phoneNumber,
            device: deviceModel,
            deviceId: deviceId
        )

        return api.publisher(for: mutation)
            .mapError { error -> Error in
                if let graphQLError = error.graphQLError(statusCode: 403), graphQLError.status == "NOT_WHITELISTED" {
                    return RegisterError.notAllowed
                }
                if let graphQLError = error.graphQLError(statusCode: 423), graphQLError.status == "TEMPORARY_BLOCKED",
                   let errorData: [String: Any] = graphQLError.data(),
                   let blockedTime: Int = errorData.value(forKey: "blockedTime") {
                    return RegisterError.temporaryBlocked(blockedTime: blockedTime)
                }
                return error
            }
            .map { data -> (RegistrationDraft.OtpInfo, String) in
                let otpInfo = RegistrationDraft.OtpInfo(
                    expireTime: Date().addingTimeInterval(data.register.otpInfo.fragments.otpInfoFragment.expireInterval),
                    nextRequestTime: Date().addingTimeInterval(data.register.otpInfo.fragments.otpInfoFragment.nextRequestInterval),
                    responseTime: Date()
                )
                return (otpInfo, data.register.temporaryToken)
            }
            .map({ [draftStore, tokenStore] otpInfo, token in
                draftStore.modify { state in
                    state.smsOtpInfo = otpInfo
                    state.phoneNumber = phoneNumber
                }
                tokenStore.modify {
                    $0 = .init(accessToken: token, refreshToken: "")
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: RegisterError.self)
    }

    func activateDevice(
        phoneNumber: String,
        passwordHash: String
    ) -> AnyPublisher<Never, ActionError<DeviceActivationError>> {
        let mutation = DeviceActivationMutation(
            password: passwordHash,
            phoneNumber: phoneNumber,
            device: deviceModel,
            deviceId: deviceId
        )

        return api.publisher(for: mutation)
            .mapError { error -> Error in
                if let errorData: [String: Any] = error.graphQLError(statusCode: 401)?.data(),
                   let remaining: Int = errorData.value(forKey: "remainingAttempts") {
                    return DeviceActivationError.unauthorized(remainingAttempts: remaining)
                }
                if let graphQLError = error.graphQLError(statusCode: 423), graphQLError.status == "TEMPORARY_BLOCKED",
                   let errorData: [String: Any] = graphQLError.data(),
                   let blockedTime: Int = errorData.value(forKey: "blockedTime") {
                    return DeviceActivationError.temporaryBlocked(blockedTime: blockedTime)
                }
                if let graphQLError = error.graphQLError(statusCode: 423), graphQLError.status == "BLOCKED" {
                    return DeviceActivationError.blocked
                }
                return error
            }
            .map { data -> (RegistrationDraft.OtpInfo, String) in
                let otpInfo = RegistrationDraft.OtpInfo(
                    expireTime: Date().addingTimeInterval(data.deviceActivation.otpInfo.fragments.otpInfoFragment.expireInterval),
                    nextRequestTime: Date().addingTimeInterval(data.deviceActivation.otpInfo.fragments.otpInfoFragment.nextRequestInterval),
                    responseTime: Date()
                )
                return (otpInfo, data.deviceActivation.temporaryToken)
            }
            .map({ [draftStore, tokenStore] otpInfo, token  in
                draftStore.modify { state in
                    state.smsOtpInfo = otpInfo
                }
                tokenStore.modify {
                    $0 = .init(accessToken: token, refreshToken: "")
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: DeviceActivationError.self)
    }

    func resendOtp(phoneNumber: String) -> AnyPublisher<Never, ActionError<ResendOtpError>> {
        let request = ResendOtpQuery(deviceId: deviceId, phoneNumber: phoneNumber)
        return api.publisher(for: request, cachePolicy: .fetchIgnoringCacheCompletely)
            .mapError { error -> Error in
                if let status = error.graphQLError(statusCode: 429)?.status {
                    if status == "TOO_SOON_OTP_REQUEST" {
                        return ResendOtpError.tooSoonRequest
                    } else if status == "TOO_MANY_OTP_REQUEST" {
                        return ResendOtpError.tooManyRequests
                    }
                }
                return error
            }
            .map { data in
                RegistrationDraft.OtpInfo(
                    expireTime: Date().addingTimeInterval(data.getOtp.otpInfo.fragments.otpInfoFragment.expireInterval),
                    nextRequestTime: Date().addingTimeInterval(data.getOtp.otpInfo.fragments.otpInfoFragment.nextRequestInterval),
                    responseTime: Date(),
                    remainingResendAttempts: Int(data.getOtp.remainingAttempts)
                )
            }
            .map({ [draftStore] otpInfo in
                draftStore.modify { state in
                    state.smsOtpInfo = otpInfo
                }
            })
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapActionError(to: ResendOtpError.self)
    }

    func verifyOTP(
        otp: String
    ) -> AnyPublisher<Never, ActionError<VerifyOtpError>> {
        let mutation = VerifyOtpMutation(smsOtp: otp)
        return api.publisher(for: mutation)
            .mapError { error -> Error in
                if error.graphQLError(statusCode: 429) != nil {
                    return VerifyOtpError.tooManyTry
                }
                if error.graphQLError(statusCode: 408) != nil {
                    return VerifyOtpError.expired
                }
                if let errorData: [String: Any] = error.graphQLError(statusCode: 400)?.data(),
                   let remaining: Int = errorData.value(forKey: "remainingAttempts") {
                    return VerifyOtpError.wrongOtp(remainingAttempts: remaining)
                }
                return error
            }
            .tryMap({ [verifyOTPMapper] data in
                try verifyOTPMapper.map(data)
            })
            .map({ [tokenStore] token in
                tokenStore.modify {
                    $0 = token
                }
            })
            .ignoreOutput()
            .mapActionError(to: VerifyOtpError.self)
            .eraseToAnyPublisher()
    }

    func setupDeviceAuthentication(pin: PinCode) -> AnyPublisher<Never, AnyActionError> {
        let key = P521.KeyAgreement.PrivateKey()
        return Just(())
            .receive(on: DispatchQueue(label: UUID().uuidString))
            // Prepare token
            .map { [deviceId, deviceModel] in
                PrepareTokenV2Mutation(timestamp: "\(Int(floor(Date().timeIntervalSince1970)))",
                                       dhParams: "secp521r1",
                                       dhClient: key.publicKey.pemRepresentation,
                                       device: deviceModel,
                                       deviceId: deviceId
                )
            }
            .flatMap { [api] mutation in
                api.publisher(for: mutation)
            }
            // Create KeyFile and OTP
            .tryMap { [otpGenerator, deviceId] response in
                let keyFile = try otpGenerator.createKeyFile(
                    token: response.prepareTokenV2.token,
                    privateKey: key,
                    publicKeyPem: response.prepareTokenV2.dhServer,
                    mpin: pin.stringValue, deviceId: deviceId
                )
                let otp = try otpGenerator.createOtp(
                    keyFile: keyFile,
                    mpin: pin.stringValue,
                    deviceId: deviceId
                )
                return (otp, keyFile)
            }
            // Check token
            .flatMap { [api] (otp, keyFile) in
                Publishers.Zip(
                    api.publisher(for: CheckTokenV2Query(otp: otp), cachePolicy: .fetchIgnoringCacheCompletely),
                    Just(keyFile).setFailureType(to: Error.self))
            }
            // Everything successful, saving authentication key
            .handleEvents(receiveOutput: { [draftStore] (_, keyFile) in
                draftStore.modify {
                    $0.keyFile = keyFile
                }
            })
            .sendCrashlyticsError()
            .receive(on: DispatchQueue.main)
            .ignoreOutput()
            .eraseToAnyPublisher()
            .mapAnyActionError()
    }
}
