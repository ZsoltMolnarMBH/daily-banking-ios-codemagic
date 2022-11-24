//
//  AccountSetupCoordinator.swift
//  app-daily-banking-ios
//
//  Created by Alexa Mark on 2021. 11. 15..
//

import Combine
import SwiftUI
import Resolver
import DesignKit
import PDFKit
import UIKit

class AccountOpeningCoordinator: Coordinator {
    @Injected var applicationAction: ApplicationAction
    @Injected var accountOpeningDraftStore: any AccountOpeningDraftStore
    @Injected var userAction: UserAction
    @Injected var individual: ReadOnly<Individual?>
    @Injected var userStore: any UserStore
    @Injected var config: AccountOpeningConfig

    private var onFinished: (() -> Void)?

    private let navigationController: UINavigationController = {
        let navigationController = BrandedNavigationController()
        navigationController.viewControllers = []
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()

    func start(on viewController: UIViewController, onFinished: @escaping () -> Void) {
        self.onFinished = onFinished
        applicationAction.refreshApplication()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    guard let email = self.individual.value?.email,
                            (email.isVerified || self.config.skipEmailValidation == true) else {
                        self.startWithEmailValidation(on: viewController)
                        return
                    }
                    switch self.accountOpeningDraftStore.state.value.nextStep {
                    case .accountPackageSelection:
                        self.startFromAccountOpeningStartPage(on: viewController)
                    case .personalData:
                        self.showKycStep(on: viewController)
                    case .consents:
                        self.showConsentsStartPage(on: viewController)
                    case .generateContract, .signContract, .accountOpening, .finalize:
                        self.startFromContractStep(on: viewController)
                    default:
                        onFinished()
                    }
                case .failure:
                    let name = "oao_initial_loading_error"
                    let result = ResultModel.genericError(
                        screenName: name,
                        action: { [weak self] in
                            Modals.fullScreen.dismiss(name)
                            self?.start(on: viewController, onFinished: onFinished)
                        })
                    Modals.fullScreen.show(view: ResultScreen(model: result), name: name)
                }
            }
            .store(in: &disposeBag)
    }

    func helpRequested() {
        ActionSheetView(.contactsAndHelp).show()
    }

    private func startFromAccountOpeningStartPage(on viewController: UIViewController) {
        let startPage = container.resolve(AccountOpeningStartPageScreen<AccountOpeningStartPageScreenViewModel>.self)
        startPage.viewModel.screenListener = self
        navigationController.viewControllers = [UIHostingController(rootView: startPage.navigationBarHidden(true))]
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }

    private func showConsentsStartPage(on viewController: UIViewController? = nil) {
        let title = Strings.Localizable.consentsStartPageTitle
        let consentsScreen = container.resolve(ConsentsStartPageScreen<ConsentsStartPageScreenViewModel>.self)
        consentsScreen.viewModel.screenListener = self
        let screen = consentsScreen
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)

        let hosting = UIHostingController(rootView: screen)
        if let viewController = viewController {
            navigationController.viewControllers = [hosting]
            navigationController.modalPresentationStyle = .fullScreen
            viewController.present(navigationController, animated: true)
        } else {
            navigationController.setViewControllersWithCrossfade([hosting])
        }
    }

    private func startWithEmailValidation(on viewController: UIViewController) {
        let title = Strings.Localizable.emailVerificationTitle
        let emailVerificationScreen = container.resolve(EmailVerificationScreen<EmailVerificationScreenViewModel>.self)
        emailVerificationScreen.viewModel.screenListener = self
        let screen = emailVerificationScreen
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView("registration_confirm_e-mail")

        navigationController.viewControllers = [UIHostingController(rootView: screen)]
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }

    private func showKycStep(on viewController: UIViewController? = nil) {
//        let coordinator = Coordinator.make(
//            using: container.makeChild(),
//            assembly: KycAssembly()) { container in
//                KycCoordinator(container: container)
//            }
//        add(child: coordinator)
//        let mode: KycCoordinator.Mode
//        if config.isKycEnabled {
//            mode = .facekom
//        } else {
//            let draft = accountOpeningDraftStore.state.value
//            mode = .manual(email: draft.individual!.email.address, phone: draft.individual!.phoneNumber)
//        }
//        coordinator.start(on: navigationController, mode: mode) { [weak self, weak coordinator] result in
//            guard let self = self, let coordinator = coordinator else { return }
//            switch result {
//            case .finished(let kycDraft):
//                let firstName = kycDraft.fields.firstName.value
//                let lastName = kycDraft.fields.lastName.value
//                self.accountOpeningDraftStore.modify {
//                    $0.individual?.legalName = .init(firstName: firstName, lastName: lastName)
//                }
//                self.showConsentsStartPage()
//            case .cancelled:
//                break
//            }
//            self.remove(child: coordinator)
//        }
//        if let viewController = viewController {
//            navigationController.modalPresentationStyle = .fullScreen
//            viewController.present(navigationController, animated: true)
//        }
    }

    private func startFromContractStep(on viewController: UIViewController) {
        let title = Strings.Localizable.contractSigningTitle
        let contractScreen = container.resolve(DocumentViewerScreen<ContractScreenViewModel>.self)
        contractScreen.viewModel.screenListener = self
        let screen = contractScreen
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView("oao_present_contract")
        navigationController.viewControllers = [UIHostingController(rootView: screen)]
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
    }
}

extension AccountOpeningCoordinator: ContractScreenListener {
    func onContractAccepted() {
        if let name = accountOpeningDraftStore.state.value.individual?.legalName,
           let phoneNumber = accountOpeningDraftStore.state.value.individual?.phoneNumber {
            userStore.modify {
                $0 = .init(name: name, phoneNumber: phoneNumber)
            }
        }
        onFinished?()
    }
}

extension AccountOpeningCoordinator: AccountOpeningStartPageScreenListener {
    func accountPackageDetailsScreenRequested() {
        let coordinator = PackageDetailsCoordinator.new(parent: self)
        add(child: coordinator)
        let params = PackageDetailsCoordinator.Params(
            ctaTitle: Strings.Localizable.commonNext,
            visibleDocuments: [
                .conditionList,
                .contractTemplate,
                .privacyStatement
            ],
            analyticsPrefix: "oao",
            onProceed: { [weak self] in
                self?.showAccountOpeningConditions()
            }
        )
        coordinator.start(on: navigationController, params: params) { [weak self, weak coordinator] in
            guard let self = self, let coordinator = coordinator else { return }
            self.remove(child: coordinator)
        }
    }

    private func showAccountOpeningConditions() {
        let title = Strings.Localizable.accountOpeningConditionsTitle
        let conditionsScrenn = container.resolve(
            AccountOpeningConditionsScreen<AccountOpeningConditionsScreenViewModel>.self
        )
        conditionsScrenn.viewModel.screenListener = self
        let screen = conditionsScrenn
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        let hosting = UIHostingController(rootView: screen)
        hosting.title = title
        navigationController.pushViewController(hosting, animated: true)
    }
}

extension AccountOpeningCoordinator: ConsentsStartPageScreenListener {
    func consentsStatementsScreenRequested() {
        accountOpeningDraftStore.modify {
            if $0.statements == nil { $0.statements = .new }
            $0.selectedCountry = nil
        }

        let title = Strings.Localizable.accountOpeningTaxResidencyTitle
        let taxation = container.resolve(ConsentsTaxationScreen<ConsentsTaxationScreenViewModel>.self)
        taxation.viewModel.screenListener = self
        let pep = container.resolve(ConsentsPepScreen<ConsentsPepScreenViewModel>.self)
        pep.viewModel.screenListener = self
        let documents = container.resolve(ConsentsDocumentScreen<ConsentsDocumentScreenViewModel>.self)
        documents.viewModel.screenListener = self

        let dmStatement = container.resolve(ConsentsDMStatementScreen<ConsentsDMStatementScreenViewModel>.self)
        dmStatement.viewModel.screenListener = self

        let pager = PagerView(pages: [
            .init(id: "pep", content: AnyView(pep)),
            .init(id: "taxation", content: AnyView(taxation)),
            .init(id: "documents", content: AnyView(documents)),
            .init(id: "dmstatement", content: AnyView(dmStatement))
        ])

        pager.controller.pageDidAppear = { page in
            if page == 0 {
                pager.analytics.logScreenView("oao_kyc_consents_step_1")
            } else if page == 1 {
                pager.analytics.logScreenView("oao_kyc_consents_step_2")
            } else if page == 2 {
                pager.analytics.logScreenView("oao_kyc_consents_step_4")
            } else if page == 3 {
                pager.analytics.logScreenView("oao_kyc_consents_step_5")
            }
        }

        pep.viewModel.onProceedRequested = { [accountOpeningDraftStore] in
            accountOpeningDraftStore.modify {
                $0.statements?.isPep = false
            }
            pager.select(page: 1)
        }

        taxation.viewModel.onProceedRequested = { [accountOpeningDraftStore] taxation, taxResidency in
            accountOpeningDraftStore.modify {
                $0.statements?.taxation = taxation
                $0.statements?.taxResidency = taxResidency
            }
            pager.select(page: 2)
        }

        documents.viewModel.onProceedRequested = { [weak self] in
            self?.accountOpeningDraftStore.modify {
                $0.statements?.acceptConditions = true
                $0.statements?.acceptTerms = true
                $0.statements?.acceptPrivacyPolicy = true
            }
            pager.select(page: 3)
        }

        dmStatement.viewModel.onProceedRequested = { [weak self] result in
            self?.accountOpeningDraftStore.modify { [result] draft in
                draft.statements?.dmStatement = result
            }
            self?.navigationController.topViewController?.dismiss(animated: true)
        }

        let screen = pager
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .addClose { [weak self] in
                self?.navigationController.topViewController?.dismiss(animated: true)
            }
        let viewController = BrandedNavigationController(rootViewController: UIHostingController(rootView: screen))
        viewController.title = title
        viewController.modalPresentationStyle = .fullScreen
        navigationController.topViewController?.present(viewController, animated: true)
    }

    func kycSurveyScreenRequested() {
        accountOpeningDraftStore.modify {
            if $0.kycSurvey == nil { $0.kycSurvey = .new }
        }

        let title = Strings.Localizable.consentsKycSurveyTitle
        let incomingSourceView = container.resolve(KycSurveyIncomeScreen<KycSurveyIncomeScreenViewModel>.self)

        let depositView = container.resolve(KycSurveyDepositScreen<KycSurveyDepositScreenViewModel>.self)

        let transferView = container.resolve(KycSurveyTransferScreen<KycSurveyTransferScreenViewModel>.self)

        let pager = PagerView(pages: [
            .init(id: "incoming", content: AnyView(incomingSourceView)),
            .init(id: "deposit", content: AnyView(depositView)),
            .init(id: "transfer", content: AnyView(transferView))
        ])

        pager.controller.pageDidAppear = { page in
            if page == 0 {
                pager.analytics.logScreenView("oao_kyc_survey_step_1")
            } else if page == 1 {
                pager.analytics.logScreenView("oao_kyc_survey_step_2")
            } else if page == 2 {
                pager.analytics.logScreenView("oao_kyc_survey_step_3")
            }
        }

        incomingSourceView.viewModel.onProceedRequested = { [weak self] isSalarySource, otherSourceText in
            self?.accountOpeningDraftStore.modify {
                $0.kycSurvey?.incomingSources = .init(salary: isSalarySource, other: otherSourceText.isEmpty ? nil : otherSourceText)
            }
            pager.select(page: 1)
        }

        depositView.viewModel.onProceedRequested = { [weak self] amountFrom, amountTo in
            self?.accountOpeningDraftStore.modify {
                $0.kycSurvey?.depositPlan = .init(amountFrom: amountFrom, amountTo: amountTo)
            }
            pager.select(page: 2)
        }

        transferView.viewModel.onProceedRequested = { [weak self] amountFrom, amountTo in
            self?.accountOpeningDraftStore.modify {
                $0.kycSurvey?.transferPlan = .init(amountFrom: amountFrom, amountTo: amountTo)
            }

            self?.navigationController.topViewController?.dismiss(animated: true)
        }

        let screen = pager
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .addClose { [weak self] in
                self?.navigationController.topViewController?.dismiss(animated: true)
            }

        let viewController = BrandedNavigationController(rootViewController: UIHostingController(rootView: screen))
        viewController.title = title
        viewController.modalPresentationStyle = .fullScreen

        navigationController.topViewController?.present(viewController, animated: true)
    }

    func onConsentsDataValidated() {
        let title = Strings.Localizable.contractSigningTitle
        let contractScreen = container.resolve(DocumentViewerScreen<ContractScreenViewModel>.self)
        contractScreen.viewModel.screenListener = self
        let hosting = UIHostingController(
            rootView: contractScreen
                .navigationTitle(title)
                .analyticsScreenView("oao_present_contract")
        )
        hosting.title = title
        navigationController.pushViewController(hosting, animated: true)
    }
}

extension AccountOpeningCoordinator: ConsentsTaxationScreenListener {
    func selectTaxationCountry(disabledCountryCodes: [String]) {
        let title = Strings.Localizable.commonCountry
        let countryPickerScreen = CountryPickerScreen(
            viewModel: CountryPickerScreenViewModel(
                disabledCountryCodes: disabledCountryCodes,
                countryCreationDescriptor: nil,
                onCountrySelected: { [accountOpeningDraftStore] country in
                    accountOpeningDraftStore.modify {
                        $0.selectedCountry = country
                    }
                },
                dismissAction: { [weak navigationController] in
                    navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
                })
        )
        let screen = countryPickerScreen
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .addClose { [weak navigationController] in
                navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
            }
            .analyticsScreenView("oao_kyc_consents_step_2_countries")

        let hosting = BrandedNavigationController(rootViewController: UIHostingController(rootView: screen))
        hosting.modalPresentationStyle = .fullScreen
        navigationController.presentedViewController?.present(hosting, animated: true)
    }
}

extension AccountOpeningCoordinator: ConsentsDocumentScreenListener {
    func conditionsDocumentViewerScreenRequested(title: String, url: String) {
        let viewModel = SimpleDocumentViewerViewModel(source: .url(url))
        let screen = DocumentViewerScreen(viewModel: viewModel)
            .navigationTitle(title)
            .analyticsScreenView("oao_kyc_consents_step_4_\(title.asAnalyticsTitle)")
        let host = UIHostingController(rootView: screen)
        host.title = title
        if let pager = navigationController.topViewController?.presentedViewController as? UINavigationController {
            pager.pushViewController(host, animated: true)
        } else {
            assertionFailure("Invalid viewcontroller hierarchy...")
        }
    }
}

extension AccountOpeningCoordinator: ConsentsPepScreenListener {}

extension AccountOpeningCoordinator: AccountOpeningConditionsScreenListener {
    func onAccountOpeningConditionsAccepted() {
        showKycStep()
    }
}

extension AccountOpeningCoordinator: ConsentsDMStatementScreenListener {}

extension AccountOpeningCoordinator: EmailVerificationScreenListener {
    func emailAlterDialogRequested() {
        let title = Strings.Localizable.emailVerificationAlterEmail
        let alterEmailScreen = container.resolve(
            EmailAlterationScreen<EmailAlterationScreenViewModel>.self
        )
        alterEmailScreen.viewModel.screenListener = self
        let screen = alterEmailScreen
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .analyticsScreenView("registration_modify_e-mail")
            .addClose { [weak self] in
                self?.navigationController.dismiss(animated: true)
            }

        let hosting = UIHostingController(rootView: screen)
        hosting.title = title
        let modalFlowPresenter = BrandedNavigationController(rootViewController: hosting)
        modalFlowPresenter.modalPresentationStyle = .fullScreen
        navigationController.present(modalFlowPresenter, animated: true)
    }

    func emailVerified() {
        Modals.bottomSheet.dismissAll()
        navigationController.presentedViewController?.dismiss(animated: true)

        let startScreen = container.resolve(AccountOpeningStartPageScreen<AccountOpeningStartPageScreenViewModel>.self)
        startScreen.viewModel.screenListener = self
        let screen = startScreen
            .navigationBarBackButtonHidden(true)
        let host = UIHostingController(rootView: screen)
        navigationController.pushViewController(host, animated: true)
    }
}

extension AccountOpeningCoordinator: EmailAlterationScreenListener {
    func closeRequested() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }

    func alterEmailSucceeded() {
        closeRequested()
    }
}
