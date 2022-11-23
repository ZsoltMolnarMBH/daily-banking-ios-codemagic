//
//  BeneficiaryScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 25..
//

import SwiftUI
import DesignKit
import Combine

protocol BeneficiaryScreenViewModelProtocol: ObservableObject {
    var beneficiaryName: String { get set }
    var beneficiaryNameState: ValidationState { get }
    var accountNumber: String { get set }
    var accountNumberState: ValidationState { get }
    var notice: String { get set }
    var noticeState: ValidationState { get }
    var isFormValid: Bool { get }
    func handle(event: BeneficiaryScreenInput)
}

enum BeneficiaryScreenInput {
    case onConfirm
}

struct BeneficiaryScreen<ViewModel: BeneficiaryScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Namespace private var noticeInput
    @FocusState private var focusedField: Field?
    enum Field: Int, Hashable {
        case name
        case accountNumber
        case notice
    }

    var body: some View {
        FormLayout(content: { proxy in
            VStack(spacing: .m) {
                SectionCard {
                    DesignTextField(title: Strings.Localizable.newTransferBeneficiaryBeneficiaryName,
                                    text: $viewModel.beneficiaryName,
                                    validationState: viewModel.beneficiaryNameState)
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .focused($focusedField, equals: .name)
                        .onSubmit { self.focusNextField($focusedField) }

                }
                SectionCard(spacing: .xxxl) {
                    DesignTextField(title: Strings.Localizable.newTransferBeneficiaryIdType,
                                    text: .constant(Strings.Localizable.newTransferBeneficiaryIdTypeAccountNumber),
                                    validationState: .normal)
                        .disabled(true)
                    DesignTextField(title: Strings.Localizable.newTransferBeneficiaryAccountNumber,
                                    text: $viewModel.accountNumber.filtered(characterSet: .decimalDigits),
                                    hint: Strings.Localizable.newTransferBeneficiaryAccountNumberFooter,
                                    editor: .custom(factory: {
                                        $0.makeAccountEditorEditor {
                                            self.focusNextField($focusedField)
                                        }
                                    }),
                                    validationState: viewModel.accountNumberState)
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .focused($focusedField, equals: .accountNumber)
                }
                SectionCard {
                    DesignTextEditor(title: Strings.Localizable.newTransferBeneficiaryNoticeTitle,
                                     titleHint: Strings.Localizable.newTransferBeneficiaryNoticeTitleRequired,
                                     state: viewModel.noticeState,
                                     maxCharacterCount: 140,
                                     fixedHeight: 120,
                                     text: $viewModel.notice,
                                     characterCounter: { $0.ig2Escaped().utf8.count })
                        .hideErrorBeforeEditing(true)
                        .hideErrorWhileEditing(true)
                        .returnKeyType(.done)
                        .resignOnReturn(true)
                        .focused($focusedField, equals: .notice)
                }
                .id(noticeInput) // Please don't move this deeper, otherwise it doesn't work (Apple bug)
                Spacer()
            }
            .animation(.fast, value: focusedField)
            .onChange(of: focusedField) { newValue in
                if newValue == .notice {
                    withAnimation(.default) {
                        proxy.scrollTo(noticeInput)
                    }
                }
            }
            .padding()
        }, floater: {
            DesignButton(title: Strings.Localizable.commonNext) {
                viewModel.handle(event: .onConfirm)
            }
            .disabled(!viewModel.isFormValid)
        })
        .analyticsScreenView("new_transfer_beneficiary")
    }
}

struct BeneficiaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BeneficiaryScreen<BeneficiaryScreenViewModelMock>(viewModel: .init())
                .preferredColorScheme(.light)
        }
    }
}

class BeneficiaryScreenViewModelMock: BeneficiaryScreenViewModelProtocol {
    @Published var beneficiaryName: String = ""
    @Published var beneficiaryNameState: ValidationState = .normal
    @Published var accountNumber: String = ""
    @Published var accountNumberState: ValidationState = .normal
    @Published var notice = ""
    @Published var noticeState: ValidationState = .normal
    @Published var isFormValid = true
    func handle(event: BeneficiaryScreenInput) {
    }
}
