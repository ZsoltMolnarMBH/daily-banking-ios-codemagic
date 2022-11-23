//
//  ElectronicIDReaderScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 19..
//

import Combine
import Foundation
import Resolver

enum ElectronicIdReaderScreenEvents {
    case infoRequested
    case nfcPositionInfoRequested
    case nfcReadingFinished
}

class ElectronicIDReaderScreenViewModel: ScreenViewModel<ElectronicIdReaderScreenEvents>, ElectronicIDReaderScreenViewModelProtocol {

    @Injected var nextStep: ReadOnly<FaceKom.Step>
    @Injected var action: FaceKomAction
    @Published var errorResult: ResultModel?
    @Published var isActionsEnabled = true

    private var _alert = PassthroughSubject<AlertModel, Never>()
    var bottomAlert: AnyPublisher<AlertModel, Never> {
        _alert.eraseToAnyPublisher()
    }
    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        nextStep.publisher
            .dropFirst()
            .map { [weak self] nextStep -> Bool in
                if case .eMRTD = nextStep {
                    self?.isActionsEnabled = true
                    self?._alert.send(.init(
                        title: Strings.Localizable.commonGenericErrorTitle,
                        imageName: .alertSemantic,
                        actions: [
                            .init(title: Strings.Localizable.commonAllRight, handler: {})
                        ]))
                    return false
                } else {
                    return true
                }
            }
            .filter { $0 }
            .sink(receiveValue: { [weak self] _ in
                self?.disposeBag.removeAll()
                self?.events.send(.nfcReadingFinished)
            })
            .store(in: &disposeBag)
    }

    private func readNFC() {
        isActionsEnabled = false
        action
            .readNFC(messageProvider: { message in
                switch message {
                case .requestPresentPassport, .authenticatingWithPassport:
                    return "\(Strings.Localizable.kycEidPrimaryActionTitle)\n\(Strings.Localizable.kycEidNfcReadingRequestPresentIdIOS)"
                case .readingDataGroupProgress(let progress):
                    return "\(Strings.Localizable.kycEidNfcReadingDatagroup)\n\n\(progress)%"
                case .error:
                    return Strings.Localizable.kycEidNfcReadingError
                case .successfulRead:
                    return Strings.Localizable.kycEidNfcReadingSuccess
                }
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] event in
                switch event {
                case .finished:
                    break
                case .failure:
                    self?.isActionsEnabled = true
                }
            })
            .store(in: &disposeBag)
    }

    private func skipNFCStep() {
        isActionsEnabled = false
        action.skipCurrentStep()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] event in
                switch event {
                case .finished:
                    break
                case .failure:
                    self?.isActionsEnabled = true
                    self?.errorResult = .genericError(screenName: "", action: { self?.errorResult = nil })
                }
            })
            .store(in: &disposeBag)
    }

    func handle(_ event: ElectronicIDReaderScreenInputs) {
        switch event {
        case .eIDHelp:
            events.send(.infoRequested)
        case .nfcPositionHelp:
            events.send(.nfcPositionInfoRequested)
        case .startReading:
            readNFC()
        case .skip:
            _alert.send(.init(
                title: Strings.Localizable.kycEidSkipNfcTitle,
                imageName: .warningSemantic,
                subtitle: Strings.Localizable.kycEidSkipNfcDescription,
                actions: [
                    .init(title: Strings.Localizable.commonSkip, kind: .secondary, handler: { [weak self] in
                        self?.skipNFCStep()
                    }),
                    .init(title: Strings.Localizable.kycEidReadNfcAction, kind: .primary, handler: { [weak self] in
                        self?.readNFC()
                    })
                ]))
        }
    }
}
