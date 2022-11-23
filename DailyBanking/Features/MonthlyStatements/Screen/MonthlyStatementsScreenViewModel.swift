//
//  MonthlyStatementsScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 09..
//

import Combine
import Foundation
import Resolver
import Apollo

enum MonthlyStatementsScreenResult {
    case statementSelected(_ statement: MonthlyStatement)
}

class MonthlyStatementsScreenViewModel: ScreenViewModel<MonthlyStatementsScreenResult>,
                                        MonthlyStatementsScreenViewModelProtocol {
    @Injected var action: UserAction
    @Injected var domainStatements: ReadOnly<[MonthlyStatement]>

    @Published var statements: [String: [StatementVM]] = [:]
    @Published var isLoading = true
    @Published var monthlyStatementsFetchErrorModel: ResultModel?

    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        isLoading = domainStatements.value.count == 0
        domainStatements.publisher
            .map { [weak self] domain in
                guard let self = self else { return [:] }
                return self.convert(domain)
            }
            .assign(to: \.statements, onWeak: self)
            .store(in: &disposeBag)

        self.loadData()
    }

    private func loadData() {
        action
            .loadMonthlyStatements()
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false

                switch completion {
                case .failure:
                    self?.monthlyStatementsFetchErrorModel = .monthlyStatementsFetchError {
                        self?.monthlyStatementsFetchErrorModel = nil
                        self?.loadData()
                    }
                case .finished: break
                }

            })
            .store(in: &disposeBag)
    }

    private func convert(_ domain: [MonthlyStatement]) -> [String: [StatementVM]] {
        var result: [String: [StatementVM]] = [:]
        for statement in domain {
            let section = "\(Calendar.current.component(.year, from: statement.startDate))"
            result[section] = (result[section] ?? []) + [convert(statement)]
        }
        return result
    }

    private func convert(_ statement: MonthlyStatement) -> StatementVM {
        StatementVM(
            id: statement.id,
            title: DateFormatter.yearAndMonth.string(from: statement.startDate),
            subtitle: "\(DateFormatter.monthAndDay.string(from: statement.startDate)) - \(DateFormatter.monthAndDay.string(from: statement.endDate))",
            selectedAction: { [weak self] in
                self?.events.send(.statementSelected(statement))
            }
        )
    }
}
