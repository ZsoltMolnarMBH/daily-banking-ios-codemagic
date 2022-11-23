//
//  AccountClosingDocumentsScreen.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 23..
//

import SwiftUI
import DesignKit

protocol AccountClosingDocumentsScreenViewModelProtocol: ObservableObject {
    func handle(event: AccountClosingDocumentsScreenInput)
}

enum AccountClosingDocumentsScreenInput {
    case contracts
    case monthlyStatements
    case goNext
    case goBack
}

struct AccountClosingDocumentsScreen<ViewModel: AccountClosingDocumentsScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack {
                Card(padding: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(Strings.Localizable.accountClosingDocumentsTitle)
                            .textStyle(.headings5)
                            .padding(.m)
                        CardButton(
                            cornerRadius: 0,
                            title: Strings.Localizable.contractsScreenTitle,
                            image: Image(.fileDocument)) {
                                viewModel.handle(event: .contracts)
                            }
                        CardButton(
                            cornerRadius: 0,
                            title: Strings.Localizable.monthlyStatementScreenTitle,
                            image: Image(.fileDocument)) {
                                viewModel.handle(event: .monthlyStatements)
                            }
                    }
                }
                Spacer()
            }
            .padding(.m)
        } floater: {
            HStack(spacing: .m) {
                DesignButton(style: .secondary, title: Strings.Localizable.commonPrevious) {
                    viewModel.handle(event: .goBack)
                }
                DesignButton(style: .primary, title: Strings.Localizable.commonFollowing) {
                    viewModel.handle(event: .goNext)
                }
            }
        }
    }
}

struct AccountClosingDocumentsScreen_Previews: PreviewProvider {
    class ViewModel: AccountClosingDocumentsScreenViewModelProtocol {
        func handle(event: AccountClosingDocumentsScreenInput) { }
    }

    static var previews: some View {
        AccountClosingDocumentsScreen(viewModel: ViewModel())
    }
}
