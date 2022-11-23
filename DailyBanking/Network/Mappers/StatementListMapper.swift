//
//  StatementListMapper.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 01. 10..
//

import BankAPI
import Foundation

class MonthlyStatementMapper: Mapper<StatementFragment, MonthlyStatement> {
    override func map(_ item: StatementFragment) throws -> MonthlyStatement {
        guard let start = DateFormatter.simple.date(from: item.periodStart) else {
            throw makeError(item: item, reason: "Invalid dateformat at .periodStart")
        }
        guard let end = DateFormatter.simple.date(from: item.periodEnd) else {
            throw makeError(item: item, reason: "Invalid dateformat at .periodEnd")
        }
        return MonthlyStatement(
            id: item.statementId,
            startDate: start,
            endDate: end
        )
    }
}
