//
//  PersonalInfoScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 16..
//

import Combine
import Resolver

enum PersonalInfoScreenResult {
    case personalDataEditingHelpRequested
}

class PersonalInfoScreenViewModel: ScreenViewModel<PersonalInfoScreenResult>,
                                   PersonalInfoScreenViewModelProtocol {

    @Injected private var individual: ReadOnly<Individual?>
    @Injected private var action: UserAction

    @Published var name: String = ""
    @Published var birthDate: String = ""
    @Published var address: String = ""
    @Published var phoneNumber: String = ""
    @Published var emailAddress: String = ""
    @Published var isLoading: Bool = false
    @Published var personalInfoFetchErrorModel: ResultModel?

    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        isLoading = individual.value == nil
        individual.publisher
            .compactMap { $0 }
            .sink { [weak self] individual in
                self?.show(individual)
            }
            .store(in: &disposeBag)
    }

    private func show(_ individual: Individual) {
        name = individual.legalName?.localizedName ?? ""

        if let dateString = DateFormatter.simple.string(optional: individual.birthData?.date) {
            birthDate = dateString.formatted(dateReformatter: .userFacing)
        } else {
            birthDate = ""
        }
        address = individual.legalAddress?.streetName ?? ""
        phoneNumber = individual.phoneNumber.formatted(pattern: .phoneNumberWithCountryCode)
        emailAddress = individual.email.address
    }

    private func loadIndividual() {
        action.loadIndividual()
            .sink { [weak self] completion in
                self?.isLoading = false

                switch completion {
                case .failure:
                    self?.personalInfoFetchErrorModel = .personalInfoFetchError {

                        self?.personalInfoFetchErrorModel = nil
                        self?.loadIndividual()
                    }
                case .finished: break
                }

            }
            .store(in: &disposeBag)
    }

    func handle(_ event: PersonalInfoScreenInput) {
        switch event {
        case .onAppear:
            loadIndividual()
        case .editingInfo:
            events.send(.personalDataEditingHelpRequested)
        }
    }
}
