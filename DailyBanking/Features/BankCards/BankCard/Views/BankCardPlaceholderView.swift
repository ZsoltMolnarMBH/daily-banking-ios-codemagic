//
//  CardPlaceholder.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 21..
//

import SwiftUI

struct BankCardPlaceholderView: View {
    var cardNumberLastDigits: String

    var body: some View {
        ZStack {
            Image(.bankCardBgr)
                .resizable()
            VStack {
                Spacer()
                HStack {
                    Text(cardNumberLastDigits)
                        .textStyle(.headings4)
                        .foregroundColor(.white)
                    Spacer()
                    Image(.mastercardd)
                }
            }
            .padding(.horizontal, .m)
            .padding(.vertical, .s)
        }
        .aspectRatio(1.58, contentMode: .fit)
        .padding(.horizontal, .m)
    }
}

struct BankCardPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        BankCardPlaceholderView(cardNumberLastDigits: "****")
.previewInterfaceOrientation(.portrait)
    }
}
