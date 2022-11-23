//
//  BalanceText.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 02..
//

import SwiftUI
import DesignKit
import Combine

struct BalanceText: View {
    @Environment(\.redactionReasons) var redactionReasons
    let viewModel: MoneyViewModel
    let amountFont: TextStyle
    let currencyFont: TextStyle
    private var isStrikethrough: Bool = false

    init(viewModel: MoneyViewModel,
         amountFont: TextStyle = .headings1,
         currencyFont: TextStyle = .headings3) {
        self.viewModel = viewModel
        self.amountFont = amountFont
        self.currencyFont = currencyFont
    }

    private var isLoading: Bool {
        return !redactionReasons.isEmpty
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: .xxs) {
            if viewModel.currency.isPrefix {
                Text(viewModel.currency.symbol)
                    .textStyle(currencyFont)
                    .minimumScaleFactor(0.01)
                    .padding(0)
            }
            Text(isLoading ? "00000000000" : viewModel.amount)
                .if(isStrikethrough) { text in
                    text.strikethrough()
                }
                .textStyle(amountFont)
                .minimumScaleFactor(0.01)
            if !viewModel.currency.isPrefix {
                Text(viewModel.currency.symbol)
                    .textStyle(currencyFont)
                    .minimumScaleFactor(0.01)
                    .padding(0)
            }
        }
    }

    func strikethrough() -> BalanceText {
        var view = self
        view.isStrikethrough = true
        return view
    }
}

struct BalanceText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BalanceText(viewModel: .init(amount: "1234567",
                                         currency: .init(symbol: "Ft", isPrefix: false)))
            BalanceText(viewModel: .init(amount: "1234567",
                                         currency: .init(symbol: "$", isPrefix: true)))
        }
    }
}
