//
//  AccountClosingWithdrawalScreen.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 24..
//

import SwiftUI
import DesignKit

protocol AccountClosingTransferScreenViewModelProtocol: ObservableObject {
    var accountNumber: String { get set }
    var accountNumberState: ValidationState { get }

    func handle(event: AccountClosingTransferScreenInput)
}

enum AccountClosingTransferScreenInput {
    case goNext
    case goBack
}

struct AccountClosingTransferScreen<ViewModel: AccountClosingTransferScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack {
                SectionCard {
                    Text(Strings.Localizable.accountClosingTransferTitle)
                        .textStyle(.headings5)
                    DesignTextField(
                        title: Strings.Localizable.accountDetailsLabelAccountNumber,
                        text: $viewModel.accountNumber,
                        editor: .custom(factory: {
                            $0.makeAccountEditorEditor { }
                        }),
                        validationState: viewModel.accountNumberState
                    )
                    .hideErrorWhileEditing(true)
                    .hideErrorBeforeEditing(true)
                    .padding(.top, .xxl)
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
                .disabled(viewModel.accountNumberState != .normal)
            }
        }
        .floaterAttachedToKeyboard(true)
    }
}

struct AccountClosingTransferScreen_Previews: PreviewProvider {

    class ViewModel: AccountClosingTransferScreenViewModelProtocol {
        var accountNumber: String = "1234"
        var accountNumberState: ValidationState = .error(text: "Nem megfelelő formátum!")
        func handle(event: AccountClosingTransferScreenInput) { }
    }

    static var previews: some View {
        AccountClosingTransferScreen(viewModel: ViewModel())
    }
}
