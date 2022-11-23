//
//  View+reverseMask.swift
//  DailyBanking
//
//  Created by ALi on 2022. 03. 26..
//

import SwiftUI

extension View {
    @inlinable
    public func reverseMask<Mask: View>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask().blendMode(.destinationOut)
                }
        }
    }
}
