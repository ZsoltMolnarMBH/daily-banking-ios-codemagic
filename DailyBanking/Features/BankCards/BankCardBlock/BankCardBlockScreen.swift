//
//  BankCardBlockScreen.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 17..
//

import SwiftUI
import DesignKit
import Resolver
import Combine

struct BankCardBlockScreen<ViewModel: BankCardBlockViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                blockCard
            }
            .padding()
            Spacer()
        } floater: {
            VStack(spacing: .m) {
                DesignButton(
                    style: .primary,
                    size: .large,
                    title: Strings.Localizable.bankCardBlockScreenBlockCardButton
                ) {
                    viewModel.handle(.block)
                }
                DesignButton(
                    style: .secondary,
                    size: .large,
                    title: Strings.Localizable.commonCancel
                ) {
                    viewModel.handle(.cancel)
                }
            }
            .padding(.bottom, 20.0)
        }
        .fullScreenProgress(by: viewModel.isLoading)
        .designAlert(viewModel.bottomAlert)
    }

    var blockCard: some View {
        VStack {
            VStack(alignment: .leading, spacing: .m) {
                HStack {
                    Spacer()
                    VStack(alignment: .center, spacing: .m) {
                        Image(.warningSemantic)
                            .resizable()
                            .frame(width: 72, height: 72)
                        Text(Strings.Localizable.bankCardBlockScreenTitle)
                            .textStyle(.headings3.thin)
                            .foregroundColor(.text.primary)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                .padding(.top, 40)
                Markdown(Strings.Localizable.bankCardBlockScreenMarkdown)
                Spacer()
            }
        }
    }
}

private class MockViewModel: BankCardBlockViewModelProtocol {

    var bottomAlert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()

    var isLoading: Bool = false

    func handle(_ event: BankCardBlockScreenInput) {}
}

struct BankCardBlockScreen_Previews: PreviewProvider {
    static var previews: some View {
        BankCardBlockScreen(viewModel: MockViewModel())
    }
}
