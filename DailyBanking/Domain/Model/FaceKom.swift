//
//  FaceKom.swift
//  DailyBanking
//
//  Created by ALi on 2022. 03. 31..
//

import Foundation
import FaceKomSDK

protocol FaceKomStepProgressData: AutoMockable {
    var stepType: String { get }
    var value: Float { get }
    var message: String? { get }
}

protocol FaceKomStepDataItem: AutoMockable {
    var key: String { get }
    var value: String? { get }
    var isEditable: Bool { get }
    var type: String { get }
    var isRequired: Bool { get }
    var placeholder: String? { get }
    var pattern: String? { get }
    var options: [String] { get }
    var minLegth: Int? { get }
    var maxLength: Int? { get }
    var isValid: Bool? { get }
}

protocol FaceKomStepMessageDataTask: AutoMockable {
    var instruction: String { get }
    var message: String? { get }
}

protocol FaceKomStepMessageDataGuide: AutoMockable {
    var type: String { get }
    var instruction: String { get }
}

protocol FaceKomPhotoUploadResponseActions: AutoMockable {
    var isRetryEnabled: Bool { get }
    var isSubmitEnabled: Bool { get }
    var isRecongnitionValid: Bool { get }
}

protocol FaceKomPhotoUploadResponse: AutoMockable {
    var attachmentID: Int? { get }
    var action: FaceKomPhotoUploadResponseActions { get }
    var response: [String: Any]? { get }
}

struct FaceKom {
    typealias SelfServiceEventHandler = (_ event: Event) -> Void
    typealias NFCMessageProvider = (NFCDisplayMessage) -> String

    struct Environment {
        let baseUrl: String
        let token: String
    }

    enum Event {
        case statusChange(status: SocketStatus)
        case nextStep(step: Step)
        case progressInfo(data: FaceKomStepProgressData)
        case stepMessage(message: StepMessage)
    }

    enum SocketStatus {
        case undetermined
        case notConnected
        case disconnected
        case connecting
        case connected
    }

    enum Step {
        case undetermined
        case customerPortrait(isRetry: Bool)
        case livenessCheck(isRetry: Bool)
        case hologram(isRetry: Bool)
        case idFront(isRetry: Bool)
        case idBack(isRetry: Bool)
        case eMRTD(isRetry: Bool)
        case proofOfAddress(isRetry: Bool)
        case end(status: String, additionalData: Any?)
        case dataConfirmation(items: [FaceKomStepDataItem])
        case unknown(rawValue: String)
    }

    enum StepMessage {
        case task(step: String, data: FaceKomStepMessageDataTask)
        case guide(step: String, data: FaceKomStepMessageDataGuide)
    }

    enum Camera {
        case front
        case back
    }

    enum NFCDisplayMessage {
        case requestPresentPassport
        case authenticatingWithPassport(progress: Int)
        case readingDataGroupProgress(progress: Int)
        case error
        case successfulRead
    }

    struct DataField: Equatable {
        enum ValidationState {
            case valid, invalidFomat, invalidEmpty
        }

        enum Key: String {
            case firstName
            case lastName
            case motherName
            case placeOfBirth
            case dateOfBirth
            case idCardNumber
            case idDateOfExpiry
            case address
            case addressCardNumber
            case birthName
            case phoneNumber
            case email
        }

        let key: Key
        var value: String
        let isEditable: Bool
        let isRequired: Bool
        let regexp: RegExp?

        var validationState: ValidationState {
            guard !value.isEmpty else { return isRequired ? .invalidEmpty : .valid }
            guard let regexp = regexp else { return .valid }
            return value.matches(pattern: regexp) ? .valid : .invalidFomat
        }

        static func empty(key: Key) -> DataField {
            DataField(key: key, value: "", isEditable: true, isRequired: false, regexp: nil)
        }

        static func == (lhs: FaceKom.DataField, rhs: FaceKom.DataField) -> Bool {
            lhs.key == rhs.key && lhs.value == rhs.value
        }
    }

    struct DataConfirmationFields {
        var firstName: DataField
        var lastName: DataField
        var birthName: DataField
        var motherName: DataField
        var address: DataField
        var placeOfBirth: DataField
        var dateOfBirth: DataField
        var idCardNumber: DataField
        var idDateOfExpiry: DataField
        var addressCardNumber: DataField
        var phoneNumber: DataField
        var email: DataField

        init(from items: [FaceKomStepDataItem]) {
            func createField(key: FaceKom.DataField.Key, from items: [FaceKomStepDataItem]) -> FaceKom.DataField {
                guard let item = items.first(where: { $0.key == key.rawValue }) else { return .empty(key: key) }
                let regexp: RegExp?
                if let pattern = item.pattern {
                    regexp = RegExp(pattern: pattern)
                } else {
                    regexp = nil
                }
                return FaceKom.DataField(
                    key: key,
                    value: item.value ?? "",
                    isEditable: item.isEditable,
                    isRequired: item.isRequired,
                    regexp: regexp
                )
            }

            firstName = createField(key: .firstName, from: items)
            lastName = createField(key: .lastName, from: items)
            motherName = createField(key: .motherName, from: items)
            placeOfBirth = createField(key: .placeOfBirth, from: items)
            dateOfBirth = createField(key: .dateOfBirth, from: items)
            idCardNumber = createField(key: .idCardNumber, from: items)
            idDateOfExpiry = createField(key: .idDateOfExpiry, from: items)
            address = createField(key: .address, from: items)
            addressCardNumber = createField(key: .addressCardNumber, from: items)
            birthName = createField(key: .birthName, from: items)
            phoneNumber = createField(key: .phoneNumber, from: items)
            email = createField(key: .email, from: items)
        }

        var dictionary: [String: Any] {
            var dict = [String: Any]()
            dict[firstName.key.rawValue] = firstName.value
            dict[lastName.key.rawValue] = lastName.value
            dict[birthName.key.rawValue] = birthName.value
            dict[motherName.key.rawValue] = motherName.value
            dict[address.key.rawValue] = address.value
            dict[placeOfBirth.key.rawValue] = placeOfBirth.value
            dict[dateOfBirth.key.rawValue] = dateOfBirth.value
            dict[idCardNumber.key.rawValue] = idCardNumber.value
            dict[idDateOfExpiry.key.rawValue] = idDateOfExpiry.value
            dict[addressCardNumber.key.rawValue] = addressCardNumber.value
            dict[phoneNumber.key.rawValue] = phoneNumber.value
            dict[email.key.rawValue] = email.value

            return dict
        }
    }
}

extension FaceKom.Event {
    init?(from event: FaceKomSDK.FKSelfService.Event) {
        switch event {
        case .statusChange(let status):
            self = .statusChange(status: .init(from: status))
        case .nextStep(let step):
            self = .nextStep(step: .init(from: step))
        case .progressInfo(let progressData):
            self = .progressInfo(data: progressData)
        case .stepMessage(message: let message):
            self = .stepMessage(message: .init(from: message))
        default:
            return nil
        }
    }
}

extension FKSelfService.StepProgressData: FaceKomStepProgressData { }
extension FKSelfService.StepDataItem: FaceKomStepDataItem { }
extension FKSelfService.StepMessageDataTask: FaceKomStepMessageDataTask { }
extension FKSelfService.StepMessageDataGuide: FaceKomStepMessageDataGuide { }
extension FKSelfService.Step.SData {
    var isRetry: Bool { retry ?? false }
}
extension FKResponsePhotoUpload.Actions: FaceKomPhotoUploadResponseActions { }
extension FKResponsePhotoUpload: FaceKomPhotoUploadResponse {
    var action: FaceKomPhotoUploadResponseActions {
        self.actions
    }
}

extension FaceKom.StepMessage {
    init(from message: FKSelfService.StepMessage) {
        switch message {
        case .task(let step, let data):
            self = .task(step: step, data: data)
        case .guide(let step, let data):
            self = .guide(step: step, data: data)
        @unknown default:
            fatalError()
        }
    }
}

extension FaceKom.Step {
    init(from step: FKSelfService.Step) {
        switch step {
        case .customerPortrait(let data):
            self = .customerPortrait(isRetry: data.isRetry)
        case .livenessCheck(_, let data):
            self = .livenessCheck(isRetry: data.isRetry)
        case .hologram(let data):
            self = .hologram(isRetry: data.isRetry)
        case .idFront(_, let data):
            self = .idFront(isRetry: data.isRetry)
        case .idBack(_, let data):
            self = .idBack(isRetry: data.isRetry)
        case .eMRTD(let data):
            self = .eMRTD(isRetry: data.isRetry)
        case .proofOfAddress(let data):
            self = .proofOfAddress(isRetry: data.isRetry)
        case .end(let status, let additionalData):
            self = .end(status: status, additionalData: additionalData)
        case .dataConfirmation(let items, _):
            self = .dataConfirmation(items: items)
        default:
            self = .unknown(rawValue: step.rawValue)
        }
    }
}

extension FaceKom.SocketStatus {
    init(from status: FaceKomSocketStatus) {
        switch status {
        case .notConnected:
            self = .notConnected
        case .disconnected:
            self = .disconnected
        case .connecting:
            self = .connecting
        case .connected:
            self = .connected
        @unknown default:
            self = .undetermined
        }
    }
}
