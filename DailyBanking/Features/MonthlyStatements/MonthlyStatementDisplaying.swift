//
//  MonthlyStatementDisplaying.swift
//  DailyBanking
//
//  Created by ALi on 2022. 07. 29..
//

import Foundation

protocol MonthlyStatementDisplaying: DocumentDisplaying { }

extension MonthlyStatementDisplaying {

    func showMonthlyStatement(_ statement: MonthlyStatement, analyticsName: String) {
        let analyticsYearAndMonth: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMM"
            formatter.locale = Locale(identifier: "hu")
            return formatter
        }()
        let title = DateFormatter.yearAndMonth.string(from: statement.startDate)
        let analyticsDate = analyticsYearAndMonth.string(from: statement.startDate).replacingOccurrences(of: ".", with: "")
        showDocument(
            source: .statement(statement.id),
            title: title,
            analyticsName: "\(analyticsName)_\(analyticsDate)"
        )
    }
}
