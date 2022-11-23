//
//  AccountClosingReasonScreen.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 18..
//

import SwiftUI
import DesignKit

protocol AccountClosingReasonScreenViewModelProtocol: ObservableObject {
    var reasonOptions: RadioButtonOptionSet<AccountClosingDraft.Reason?> { get set}
    var comment: String { get set }

    func handle(event: AccountClosingReasonScreenInput)
}

enum AccountClosingReasonScreenInput {
    case moveNext
}

struct AccountClosingReasonScreen<ViewModel: AccountClosingReasonScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel
    @Namespace private var commentInput
    @FocusState private var isTextEditorFocused: Bool?

    var body: some View {
        FormLayout { proxy in
            VStack(spacing: 0) {
                Image(.sad)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .scaledToFit()
                    .padding(.top, .xl)
                Text(Strings.Localizable.accountClosingReasonPageTitle)
                    .textStyle(.headings3.thin)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], .xxxl)
                    .padding([.top, .bottom], .xl)
                Card {
                    VStack(alignment: .leading, spacing: .xl) {
                        Text(Strings.Localizable.accountClosingReasonTitle)
                            .textStyle(.body2)
                            .fixedSize(horizontal: false, vertical: true)
                        RadioButtonGroup(
                            options: $viewModel.reasonOptions,
                            axis: .vertical,
                            state: .normal
                        )
                        DesignTextEditor(
                            title: Strings.Localizable.accountClosingReasonCommentTitle,
                            maxCharacterCount: 140,
                            fixedHeight: 118,
                            text: $viewModel.comment
                        )
                        .returnKeyType(.done)
                        .resignOnReturn(true)
                        .focused($isTextEditorFocused, equals: true)
                    }
                }
                .padding([.leading, .trailing], .m)
                .id(commentInput)
                Spacer()
            }
            .animation(.fast, value: isTextEditorFocused)
            .onChange(of: isTextEditorFocused) { _ in
                withAnimation(.default) {
                    proxy.scrollTo(commentInput)
                }
            }

        } floater: {
            DesignButton(
                style: .primary,
                title: Strings.Localizable.commonNext) {
                    viewModel.handle(event: .moveNext)
                }
        }
    }
}

struct AccountClosingReasonScreen_Previews: PreviewProvider {

    class ViewModel: AccountClosingReasonScreenViewModelProtocol {
        var comment: String = ""
        var reasonOptions: RadioButtonOptionSet<AccountClosingDraft.Reason?> =
            .init(
                dataSet: AccountClosingDraft.Reason.allCases.map {
                    ($0.displayString, $0)
                },
                selected: .none)

        func handle(event: AccountClosingReasonScreenInput) {

        }
    }

    static var previews: some View {
        AccountClosingReasonScreen(viewModel: ViewModel())
    }
}
