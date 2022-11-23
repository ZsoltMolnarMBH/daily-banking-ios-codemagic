//
//  SecureLabel.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 01. 15..
//

import Foundation
import SwiftUI
import UIKit

public struct SecureLabel: UIViewRepresentable {
    public typealias UIViewType = UILabel

    private var mutatingWrapper = MutatingWrapper()
    class MutatingWrapper {
        var foregroundColor: UIColor = .black
        var font: UIFont = .systemFont(ofSize: 12)
    }

    public let text: String

    public init(text: String) {
        self.text = text
    }

    public func makeUIView(context: Context) -> UILabel {
        return SecureUILabel()
    }

    public func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.textColor = mutatingWrapper.foregroundColor
        uiView.font = mutatingWrapper.font
        uiView.text = text
    }

    public func foregroundColor(_ foregroundColor: Color) -> Self {
        mutatingWrapper.foregroundColor = UIColor(foregroundColor)
        return self
    }

    public func font(_ font: UIFont) -> Self {
        mutatingWrapper.font = font
        return self
    }
}

class SecureUILabel: UILabel {

    private var field: UITextField?

    override func layoutSubviews() {
        super.layoutSubviews()

#if !targetEnvironment(simulator)
        guard field == nil else { return }

        let field = UITextField()
        field.isSecureTextEntry = true
        layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.first?.addSublayer(layer)
        self.field = field
#endif
    }
}
