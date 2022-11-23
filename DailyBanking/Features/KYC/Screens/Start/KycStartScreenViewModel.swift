//
//  KycStartScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 23..
//

import Combine
import DesignKit
import Foundation
import Resolver

enum KycStartScreenEvent {
    case proceed
    case helpRequested
}

class KycStartScreenViewModel: ScreenViewModel<KycStartScreenEvent>, KycStartScreenViewModelProtocol {
    @Published var isLoading: Bool = false
    @Published var idCardState: CardButton.ImageBadge?
    @Published var addressCardState: CardButton.ImageBadge?
    @Published var selfiState: CardButton.ImageBadge?
    @Published var isIdOptionEnabled: Bool = true
    @Published var isAddressCardOptionEnabled: Bool = true
    @Published var isSelfiOptionEnabled: Bool = true
    @Published var fullScreenResult: ResultModel?

    @Injected var nextStep: ReadOnly<FaceKom.Step>
    @Injected var faceKomAction: FaceKomAction
    @Injected var cameraPermissionHandler: CameraPermissionHandler

    private var disposeBag = Set<AnyCancellable>()

    func handle(_ event: KycStartScreenInput) {
        switch event {
        case .help:
            events.send(.helpRequested)
        case .onAppear:
            initializeFaceKom()
        case .next:
            checkPermission()
        }
    }

    private func initializeFaceKom() {
        isLoading = true
        disposeBag.removeAll()
        faceKomAction.start()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    self?.observeNextStep()
                case .failure:
                    self?.showGenericError()
                }
            }
            .store(in: &disposeBag)
    }

    private func observeNextStep() {
        nextStep.publisher
            .filter {
                if case FaceKom.Step.undetermined = $0 {
                    return false
                }
                return true
            }
            .sink { [weak self] _ in
                // we only enable the button when the first real step arrives
                self?.isLoading = false
            }
            .store(in: &disposeBag)
    }

    private func checkPermission() {
        cameraPermissionHandler
            .checkPermission()
            .sink { [weak self] granted in
                granted ? self?.events.send(.proceed) : self?.showPermissionAlert()
            }
            .store(in: &disposeBag)
    }

    private func showPermissionAlert() {
        fullScreenResult = .cameraPermissionDeniedKyc { [weak self] in
            self?.fullScreenResult = nil
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    private func showGenericError() {
        fullScreenResult = .genericError(screenName: "oao_ekyc_error_general") { [weak self] in
            self?.fullScreenResult = nil
            self?.initializeFaceKom()
        }
    }
}
