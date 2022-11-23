//
//  UserContractsScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 12. 13..
//

import SwiftUI
import DesignKit

protocol UserContractsScreenViewModelProtocol: ObservableObject {
    var contracts: [UserContractListVM] { get }
    var isLoading: Bool { get }
    var userContractsFetchErrorModel: ResultModel? { get }
}

struct UserContractsScreen<ViewModel: UserContractsScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                placeholder
            } else {
                liveView
            }
        }
        .listStyle(.plain)
        .animation(.fast, value: viewModel.isLoading)
        .background(Color.background.secondary)
        .analyticsScreenView("documents_contracts")
        .fullscreenResult(model: viewModel.userContractsFetchErrorModel, shouldHideNavbar: false)
    }

    private var liveView: some View {
        List(viewModel.contracts) { contract in
            CardButton(
                title: contract.title,
                subtitle: contract.subtitle,
                image: Image(.document),
                style: .secondary,
                action: contract.selectedAction
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .animation(.fast, value: viewModel.contracts)
    }

    private var placeholder: some View {
        List(makePlaceholderdata(count: 3)) { _ in
            CardButton(
                title: "contract.title",
                subtitle: "contract.signedAt",
                image: Image(.document),
                style: .secondary,
                action: {}
            )
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .shimmeringPlaceholder(
            when: viewModel.isLoading,
            for: .background.secondary
        )
    }
}

private class MockViewModel: UserContractsScreenViewModelProtocol {
    let contracts: [UserContractListVM] = [
        .init(id: "1", title: "Szerzodes1", subtitle: "Elfogadva: 2021-01-12", selectedAction: {}),
        .init(id: "2", title: "Szerzodes1", subtitle: "Aláírva: 2021-02-12", selectedAction: {}),
        .init(id: "3", title: "Szerzodes1", subtitle: nil, selectedAction: {})
    ]
    var isLoading: Bool = false
    var userContractsFetchErrorModel: ResultModel?
}

struct UserContractsScreenPreviews: PreviewProvider {
    static var previews: some View {
        UserContractsScreen(viewModel: MockViewModel())
    }
}
