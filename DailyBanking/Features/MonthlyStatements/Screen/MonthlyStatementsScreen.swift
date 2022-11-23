//
//  MonthyStatementsScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 09..
//

import Foundation
import DesignKit
import SwiftUI

protocol MonthlyStatementsScreenViewModelProtocol: ObservableObject {
    var statements: [String: [StatementVM]] { get }
    var isLoading: Bool { get }
    var monthlyStatementsFetchErrorModel: ResultModel? { get }
}

struct MonthlyStatementsScreen<ViewModel: MonthlyStatementsScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var isEmpty: Bool {
        viewModel.statements.isEmpty
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                placeholder
            } else if self.isEmpty {
                emptyState
            } else {
                liveView
            }
        }
        .listStyle(.plain)
        .hideContentBackground()
        .background(Color.background.secondary)
        .animation(.fast, value: viewModel.isLoading)
        .analyticsScreenView("documents_monthly_statements")
        .fullscreenResult(model: viewModel.monthlyStatementsFetchErrorModel, shouldHideNavbar: false)
    }

    private var liveView: some View {
        List {
            ForEach(years, id: \.self) { year in
                Section(
                    header: Text(year)
                        .textStyle(.headings5)
                        .foregroundColor(.text.tertiary)
                ) {
                    Card(padding: 0) {
                        ForEach(statement(of: year)) { statement in
                            CardButton(
                                cornerRadius: 0,
                                title: statement.title,
                                subtitle: statement.subtitle,
                                action: { statement.selectedAction() }
                            )
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
        }
    }

    private var placeholder: some View {
        List {
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
                    ForEach(makePlaceholderdata(count: 6)) { _ in
                        CardButton(
                            title: "placeholder",
                            subtitle: "subtitle",
                            action: { }
                        )
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
    }

    private var emptyState: some View {
        ZStack {
            Color.clear
            EmptyStateView(image: Image(ImageName.accountingDocument),
                           title: Strings.Localizable.monthlyStatementEmptyText,
                           description: "")
                .padding(.xxxl)
        }
    }

    var years: [String] {
        viewModel.statements
            .lazy
            .map({ $0.key })
            .sorted()
            .reversed()
    }

    func statement(of year: String) -> [StatementVM] {
        guard let statements = viewModel.statements[year] else { fatalError() }
        return statements
    }
}

private class MockViewModel: MonthlyStatementsScreenViewModelProtocol {
    var statements: [String: [StatementVM]] = [
        "2021": [StatementVM(id: "1", title: "2021 - első", subtitle: "subtitle", selectedAction: {}),
                 StatementVM(id: "2", title: "2021 - második", subtitle: "subtitle", selectedAction: {}),
                 StatementVM(id: "3", title: "2021 - harmadik", subtitle: "subtitle", selectedAction: {})
                ],
        "2020": [StatementVM(id: "4", title: "2020 - első", subtitle: "subtitle", selectedAction: {}),
                 StatementVM(id: "5", title: "2020 - második", subtitle: "subtitle", selectedAction: {}),
                 StatementVM(id: "6", title: "2020 - harmadik", subtitle: "subtitle", selectedAction: {})
                ]
    ]
    var isLoading = false

    var monthlyStatementsFetchErrorModel: ResultModel?
}

struct MonthlyStatementsScreenPreviews: PreviewProvider {
    static var previews: some View {
        MonthlyStatementsScreen(viewModel: MockViewModel())
    }
}
