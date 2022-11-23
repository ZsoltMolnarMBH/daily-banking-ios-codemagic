//
//  Image+Extensions.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 13..
//

import SwiftUI

extension Image {
    static func optional(_ name: String?) -> Image? {
        guard let name = name else { return nil }
        return Image(name)
    }
}
