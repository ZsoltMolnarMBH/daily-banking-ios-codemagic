//
//  EmailValidationScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 04. 21..
//

import Foundation
import Resolver
import Combine
import BankAPI
import DesignKit

protocol EmailVerificationScreenListener: AnyObject {
    func emailAlterDialogRequested()
    func emailVerified()
}

class EmailVerificationScreenViewModel: EmailVerificationScreenViewModelProtocol {

    enum PollingState {
        case running, paused, stopped
    }

    @Published var email: String = ""
    @Published var isAlterButtonDisabled: Bool = true
    @Published var errorDisplay: ResultModel?
    @Published var emailTimeRemaining: CountDownTimer.TimeRemaining = .zero

    var actionSheet: AnyPublisher<ActionSheetModel, Never> {
        actionSheetSubject.eraseToAnyPublisher()
    }

    @Injected var draft: ReadOnly<AccountOpeningDraft>
    @Injected var userAction: UserAction
    @Injected var applicationAction: ApplicationAction
    @Injected var emailClientManager: EmailClientManaging

    weak var screenListener: EmailVerificationScreenListener?

    private let actionSheetSubject: PassthroughSubject<ActionSheetModel, Never> = .init()
    private var disposeBag = Set<AnyCancellable>()
    private var countDownTimer = Set<AnyCancellable>()
    private var polling: AnyCancellable?
    private var pollingState: PollingState = .stopped

    init() {
        Future<[EmailClient], Never> { [weak self] promise in
            promise(.success(self?.emailClientManager.availableMailClients ?? []))
        }
        .map { $0.isEmpty }
        .assign(to: \.isAlterButtonDisabled, onWeak: self)
        .store(in: &disposeBag)

        draft.publisher
            .compactMap({ $0.emailOperationBlockedUntil })
            .sink { [weak self] date in
                guard let self = self else { return }
                self.countDownTimer.removeAll()
                CountDownTimer(duration: date.timeIntervalSinceNow)
                    .assign(to: \.emailTimeRemaining, onWeak: self)
                    .store(in: &self.countDownTimer)
            }.store(in: &disposeBag)

        startPollingEmailVerified()

        draft.publisher
            .map(\.individual?.email.address)
            .map { $0 ?? "" }
            .assign(to: &$email)

        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.didEnterBackgroundNotification
        ).sink { [weak self] _ in
            guard self?.pollingState == .running else { return }
            self?.polling?.cancel()
            self?.pollingState = .paused
        }
        .store(in: &disposeBag)

        NotificationCenter.Publisher(
            center: .default,
            name: UIApplication.willEnterForegroundNotification
        ).sink { [weak self] _ in
            guard self?.pollingState == .paused else { return }
            self?.startPollingEmailVerified()
        }
        .store(in: &disposeBag)
    }

    private func startPollingEmailVerified() {
        pollingState = .running
        polling = applicationAction.pollingEmailVerified(delay: 5).sink { [weak self] result in
            self?.pollingState = .stopped
            switch result {
            case .finished:
                self?.screenListener?.emailVerified()
            case .failure:
                self?.displayGeneralError {
                    self?.errorDisplay = nil
                    self?.startPollingEmailVerified()
                }
            }
        }
    }

    func handle(event: EmailVerificationScreenInput) {
        switch event {
        case .openEmailClient:
            guard emailClientManager.availableMailClients.count > 1 else {
                if let emailClient = emailClientManager.availableMailClients.first {
                    emailClientManager.launchEmailClient(emailClient)
                }

                return
            }

            actionSheetSubject.send(.emailClientSelecting(by: emailClientManager))
        case .showEmailActions:
            actionSheetSubject.send(getEmailOptionsActionSheetModel())
        }
    }

    private func getEmailOptionsActionSheetModel() -> ActionSheetModel {
        .init(
            title: Strings.Localizable.emailVerificationHaveNotGotEmail,
            items: [
                .init(
                    title: Strings.Localizable.emailVerificationAlterEmail,
                    iconName: DesignKit.ImageName.edit.rawValue, action: { [weak self] in
                        self?.screenListener?.emailAlterDialogRequested()
                    }),
                .init(
                    title: Strings.Localizable.emailVerificationResendEmail,
                    subtitle: draft.value.individual?.email.address,
                    iconName: DesignKit.ImageName.messageUnread.rawValue, action: { [weak self] in
                        self?.resendEmail()
                    })
            ])
    }

    private func resendEmail() {
        applicationAction.resendVerificationEmail().sink { [weak self] result in
            if case .failure = result {
                self?.displayGeneralError {
                    self?.errorDisplay = nil
                }
            }
        }.store(in: &disposeBag)
    }

    private func displayGeneralError(onRetry: @escaping () -> Void) {
        errorDisplay = .genericError(
            screenName: "registration_confirm_e-mail_error",
            action: { onRetry() }
        )
    }
}
