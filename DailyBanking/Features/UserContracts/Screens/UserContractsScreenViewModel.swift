//
//  UserContractsScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 13..
//

import Combine
import Resolver
import Apollo

enum UserContractsScreenResult {
    case contractSelected(_ contract: UserContract)
}

class UserContractsScreenViewModel: ScreenViewModel<UserContractsScreenResult>,
                                    UserContractsScreenViewModelProtocol {

    @Injected var domain: ReadOnly<[UserContract]>
    @Injected var action: UserAction

    @Published var contracts: [UserContractListVM] = []
    @Published var isLoading: Bool = true
    @Published var userContractsFetchErrorModel: ResultModel?

    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        isLoading = domain.value.count == 0
        domain.publisher
            .map { [weak self] in
                guard let self = self else { return [] }
                return $0.map(self.convert)
            }
            .assign(to: \.contracts, onWeak: self)
            .store(in: &disposeBag)

        self.loadData()
    }

    private func loadData() {
        action
            .loadContracts()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false

                switch completion {
                case .failure:
                    self?.userContractsFetchErrorModel = .userContractsFetchError {

                        self?.userContractsFetchErrorModel = nil
                        self?.loadData()
                    }
                case .finished: break
                }
            })
            .store(in: &disposeBag)
    }

    private func convert(_ domain: UserContract) -> UserContractListVM {
        let title = domain.title.isEmpty ? "" : domain.title
        return .init(
            id: domain.contractID,
            title: title,
            subtitle: subtitle(from: domain),
            selectedAction: { [weak self] in
                self?.events.send(.contractSelected(domain))
            }
        )
    }

    private func subtitle(from domain: UserContract) -> String? {
        if let signed = DateFormatter.simple.string(optional: domain.signedAt) {
            return Strings.Localizable.contractsScreenSignedAt(signed)
        } else if let accepted = DateFormatter.simple.string(optional: domain.acceptedAt) {
            return Strings.Localizable.contractsScreenAcceptedAt(accepted)
        } else if let uploaded = DateFormatter.simple.string(optional: domain.uploadedAt) {
            return Strings.Localizable.contractsScreenUploadedAt(uploaded)
        }
        return nil
    }
}
