//
//  ConsentsDMStatementScreen.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 03. 09..
//

import SwiftUI
import DesignKit

enum ConsentsDMStatementScreenInput {
    case proceed
    case skip
}

protocol ConsentsDMStatementScreenViewModelProtocol: ObservableObject {
    var isValidated: Bool { get }
    var isPushSelected: Bool { get set }
    var isEmailSelected: Bool { get set }
    var enableDMRBSingleOption: RadioButtonOptionSet<Bool> { get set }
    var disableDMRBSingleOption: RadioButtonOptionSet<Bool> { get set }

    func handle(event: ConsentsDMStatementScreenInput)
}

struct ConsentsDMStatementScreen<ViewModel: ConsentsDMStatementScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                dmStatementCard
            }
            .padding()
            Spacer()
        } floater: {
            VStack(spacing: .m) {
                DesignButton(
                    style: .primary,
                    size: .large,
                    title: Strings.Localizable.commonAllRight
                ) {
                    viewModel.handle(event: .proceed)
                }
                .disabled(!viewModel.isValidated)
                DesignButton(
                    style: .secondary,
                    size: .large,
                    title: Strings.Localizable.commonSkip
                ) {
                    viewModel.handle(event: .skip)
                }
            }
        }
    }

    var dmStatementCard: some View {
        Card {
            VStack(alignment: .leading, spacing: .xl) {
                VStack(alignment: .leading, spacing: .xxs) {
                    Text(Strings.Localizable.dmStatementsTitle)
                        .textStyle(.headings5)
                        .foregroundColor(.text.primary)
                    Text(Strings.Localizable.dmStatementsSubtitle)
                        .textStyle(.body2)
                        .foregroundColor(.text.secondary)
                }
                Text(Strings.Localizable.dmStatementsDescription)
                    .textStyle(.body2)
                    .foregroundColor(.text.secondary)
                RadioButtonGroup(
                    options: $viewModel.enableDMRBSingleOption,
                    axis: .horizontal)
                HStack {
                    Spacer(minLength: .xxxl)
                    VStack(spacing: .xl) {
                        CheckBoxRow(
                            isChecked: $viewModel.isPushSelected,
                            text: Strings.Localizable.dmStatementsNotificationPush,
                            textDidPress: { viewModel.isPushSelected = !viewModel.isPushSelected })
                            .padding(.bottom, .xs)

                        CheckBoxRow(
                            isChecked: $viewModel.isEmailSelected,
                            text: Strings.Localizable.dmStatementsNotificationEmail,
                            textDidPress: { viewModel.isEmailSelected = !viewModel.isEmailSelected })
                            .padding(.bottom, .xs)
                    }
                    Spacer()
                }
                RadioButtonGroup(
                    options: $viewModel.disableDMRBSingleOption,
                    axis: .horizontal,
                    state: .normal)
            }
        }
    }
}

private class MockViewModel: ConsentsDMStatementScreenViewModelProtocol {

    var isValidated: Bool = true

    var isPushSelected: Bool = true

    var isEmailSelected: Bool = true

    var enableDMRBSingleOption: RadioButtonOptionSet<Bool> = RadioButtonOptionSet<Bool>(
        dataSet: [(Strings.Localizable.dmStatementsNotificationOn, true)],
        selected: true
    )

    var disableDMRBSingleOption: RadioButtonOptionSet<Bool> = RadioButtonOptionSet<Bool>(
        dataSet: [
            .init(
                title: Strings.Localizable.dmStatementsNotificationOff,
                subtitle: Strings.Localizable.dmStatementsNotificationOffHint,
                value: true
            )
        ],
        selected: false
    )

    func handle(event: ConsentsDMStatementScreenInput) { }
}

struct DMStatementPreview: PreviewProvider {

    static var previews: some View {
        ConsentsDMStatementScreen(viewModel: MockViewModel())
    }
}
