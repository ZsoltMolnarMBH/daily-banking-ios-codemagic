//
//  TrimmedTextInput.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 04. 15..
//

import SwiftUI

public protocol TrimmedTextInput: TextInputCommon {
    var trimmedCharacters: CharacterSet? { get set }
}

extension TrimmedTextInput {
    func trim(text: Binding<String>) {
        if let trimmedCharacters = trimmedCharacters, !focused {
            text.wrappedValue = text.wrappedValue.trimmingCharacters(in: trimmedCharacters)
        }
    }

    func trimming(_ characters: CharacterSet?) -> Self {
        var view = self
        view.trimmedCharacters = characters
        return view
    }
}
