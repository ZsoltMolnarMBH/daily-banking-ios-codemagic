//
//  PaymentTransactionHistoryScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 31..
//

import DesignKit
import SwiftUI

struct PaymentTransactionSection: Identifiable, Equatable {
    var id: String { title }
    let title: String
    let items: [PaymentTransactionItemVM]
}

protocol PaymentTransactionHistoryScreenViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var sections: [PaymentTransactionSection] { get }

    func handle(_ event: PaymentTransactionHistoryEvent)
}

enum PaymentTransactionHistoryEvent {
    case onAppear
}

struct PaymentTransactionHistoryScreen<ViewModel: PaymentTransactionHistoryScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var isEmpty: Bool {
        !viewModel.isLoading && viewModel.sections.isEmpty
    }

    var body: some View {
        ZStack {
            if isEmpty {
                emptyState
            } else {
                if viewModel.isLoading {
                    placeholder
                } else {
                    liveView
                }

            }
        }
        .hideContentBackground()
        .background(Color.background.secondary)
        .analyticsScreenView("transaction_list")
        .animation(.default, value: viewModel.isLoading)
        .onAppear(perform: {
            viewModel.handle(.onAppear)
        })
    }

    private var liveView: some View {
        List(viewModel.sections) { section in
            Section(
                header: Text(section.title)
                    .textStyle(.headings5)
                    .foregroundColor(.text.tertiary)
            ) {
                Card(padding: 0) {
                    ForEach(section.items) { item in
                        PaymentTransactionHistoryRow(item: item)
                    }
                }
            }
            .id(section.id)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollTo(viewModel.sections.first?.id, onReselect: .transactionHistory)
    }

    private var placeholder: some View {
        List(placeholderSections) { section in
            Section(
                header: Text("Section")
                    .textStyle(.headings5)
                    .foregroundColor(.text.tertiary)
                    .shimmeringPlaceholder(
                        when: viewModel.isLoading,
                        for: .background.primary
                    )
            ) {
                Card(padding: 0) {
                    ForEach(section.items) { item in
                        PaymentTransactionHistoryRow(item: item)
                    }
                }
                .shimmeringPlaceholder(
                    when: viewModel.isLoading,
                    for: .background.primary
                )
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    private var placeholderSections: [PaymentTransactionSection] {
        [PaymentTransactionSection(
            title: "Section title",
            items: makePlaceholderdata(count: 3).map({ data in
                PaymentTransactionItemVM(
                    id: data.id,
                    imageName: .document,
                    title: "Placeholder title",
                    subtitle: "Subtitle",
                    amount: "10 000",
                    detail: .fee("100 Ft"),
                    status: .outgoing,
                    action: {}
                )
            })
        )]
    }

    private var emptyState: some View {
        ZStack {
            Color.clear
            EmptyStateView(image: Image(ImageName.giroNeutral),
                           title: Strings.Localizable.transactionHistoryEmptyStateDescription,
                           description: "")
                .padding(.xxxl)
        }
    }
}

private class MockViewModel: PaymentTransactionHistoryScreenViewModelProtocol {
    var isLoading: Bool = false
    // var sections: [PaymentTransactionSection] = []
    var sections: [PaymentTransactionSection] = [
        .init(
            title: "Section1",
            items: [
                .init(id: "1",
                      imageName: .document,
                      title: "Title1",
                      subtitle: "Subtitle1",
                      amount: "12 700",
                      detail: .fee("100"),
                      status: .rejected,
                      action: {}
                     ),
                .init(id: "2",
                      imageName: .document,
                      title: "Title1",
                      subtitle: "Subtitle1",
                      amount: "12 700",
                      detail: nil,
                      status: .outgoing,
                      action: {}
                     ),
                .init(id: "3",
                      imageName: .document,
                      title: "Title1",
                      subtitle: "Subtitle1",
                      amount: "12 700",
                      detail: nil,
                      status: .incoming,
                      action: {}
                     ),
                .init(id: "4",
                      imageName: .document,
                      title: "Title1",
                      subtitle: "Subtitle1",
                      amount: "12 700",
                      detail: .text("Rejection"),
                      status: .incoming,
                      action: {}
                     )
            ]
        )
    ]

    func handle(_ event: PaymentTransactionHistoryEvent) {}
}

struct PaymentTransactionHistoryScreenPreviews: PreviewProvider {
    static var previews: some View {
        PaymentTransactionHistoryScreen(viewModel: MockViewModel())
            .preferredColorScheme(.light)
    }
}
