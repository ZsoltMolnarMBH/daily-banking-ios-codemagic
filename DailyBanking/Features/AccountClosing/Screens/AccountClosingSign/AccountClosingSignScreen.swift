//
//  AccountClosingWithdrawalScreen.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 24..
//

import SwiftUI
import DesignKit

protocol AccountClosingSignScreenViewModelProtocol: ObservableObject {
    var isStatementGenerating: Bool { get }
    var errorDisplay: ResultModel? { get }
    var title: String { get }
    var text1: String { get }
    var text2: String { get }

    func handle(event: AccountClosingSignScreenInput)
}

enum AccountClosingSignScreenInput {
    case sign
    case goBack
}

struct AccountClosingSignScreen<ViewModel: AccountClosingSignScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        InfoScreen(model: .init(
            images: [.documentSign],
            title: viewModel.title,
            messages: [
                viewModel.text1,
                viewModel.text2
            ],
            messageButtons: [],
            buttons: [
                .init(text: Strings.Localizable.commonPrevious,
                      style: .secondary,
                      action: { viewModel.handle(event: .goBack) }),
                .init(text: Strings.Localizable.accountClosingWithdrawalSign,
                      style: .primary,
                      action: { viewModel.handle(event: .sign) })
            ],
            buttonOrientation: .horizontal))
        .background(Color.background.primary)
        .fullScreenProgress(by: viewModel.isStatementGenerating, name: "withdrawal_statement")
        .fullscreenResult(model: viewModel.errorDisplay)
    }
}

struct AccountClosingWithdrawalScreen_Previews: PreviewProvider {
    class ViewModel: AccountClosingSignScreenViewModelProtocol {
        var title: String = Strings.Localizable.accountClosingWithdrawalTerminationTitle
        var text1: String = Strings.Localizable.accountClosingWithdrawalTerminationText1
        var text2: String = Strings.Localizable.accountClosingWithdrawalTerminationText2

        var errorDisplay: ResultModel?
        var isStatementGenerating: Bool = true

        func handle(event: AccountClosingSignScreenInput) {

        }
    }

    static var previews: some View {
        AccountClosingSignScreen(viewModel: ViewModel())
    }
}
