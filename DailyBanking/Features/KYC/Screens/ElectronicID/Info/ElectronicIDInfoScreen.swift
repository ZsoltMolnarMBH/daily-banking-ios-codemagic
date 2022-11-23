//
//  ElectronicIDInfoScreen.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 17..
//

import DesignKit
import SwiftUI

struct ElectronicIDInfoScreen: View {
    let onAck: () -> Void

    var body: some View {
        FormLayout {
            VStack(spacing: .m) {
                SectionHeader(
                    title: Strings.Localizable.kycEidInfoTitle
                )
                SectionCard {
                    Text(Strings.Localizable.kycEidInfoDescription)
                        .textStyle(.body1)
                        .foregroundColor(.text.secondary)
                }
                .padding(.bottom, .m)
                SectionHeader(
                    title: Strings.Localizable.kycEidAppearanceInfoTitle
                )
                SectionCard {
                    VStack(alignment: .leading, spacing: .xs) {
                        HStack {
                            Text(Strings.Localizable.kycEidAppearanceInfoHeadline)
                                .textStyle(.headings5)
                                .foregroundColor(.text.primary)
                            Image(.eidLogo)
                                .resizable()
                                .frame(width: 24, height: 14)
                        }
                        Text(Strings.Localizable.kycEidAppearanceInfoDescription)
                            .textStyle(.body1)
                            .foregroundColor(.text.secondary)
                        Image(.eidLogoPosition)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .padding(.bottom, .m)
                SectionHeader(title: Strings.Localizable.kycEidBenefitsInfoTitle)
                SectionCard {
                    Text(Strings.Localizable.kycEidBenefitsInfoDescription)
                        .textStyle(.body1)
                        .foregroundColor(.text.secondary)
                }
                .padding(.bottom, .xxxl)
                DesignButton(
                    style: .primary,
                    title: Strings.Localizable.commonAllRight,
                    action: {
                        onAck()
                    }
                )
                .padding(.top, .xxxl)
            }
            .padding(.m)
        } floater: {}
    }
}

struct ElectronicIDInfoScreenPreviews: PreviewProvider {
    static var previews: some View {
        ElectronicIDInfoScreen(onAck: {})
    }
}
