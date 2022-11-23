//
//  AmountInput.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 02. 10..
//

import Foundation
import SwiftUI
import AnyFormatKit
import DesignKit

struct AmountInputView: UIViewRepresentable {
    private class ViewHolder {
        weak var view: AmountInput?
    }

    @Binding var text: String

    private var font: UIFont?
    private var isCurrencyPrefix = true
    private var currencySymbol = "$"
    private var accentColor: UIColor?
    private var amountForegroundColor: UIColor?
    private var currencyForegroundColor: UIColor?
    private var firstResponder = false
    private var horizontalPadding: CGFloat = 16
    private var spacing: CGFloat = 8
    private var keyboardType: UIKeyboardType = .numberPad
    private let viewHolder = ViewHolder()

    init(text: Binding<String>) {
        self._text = text
    }

    func makeUIView(context: Context) -> AmountInput {
        let input = AmountInput(isCurrencyPrefix: isCurrencyPrefix, horizontalPadding: horizontalPadding, spacing: spacing)
        input.translatesAutoresizingMaskIntoConstraints = false
        input.currencySymbol = currencySymbol
        input.currencyForegroundColor = currencyForegroundColor
        input.amountForegroundColor = amountForegroundColor
        input.accentColor = accentColor
        input.keyboardType = keyboardType
        input.text = text
        input.font = font
        input.setContentHuggingPriority(.defaultHigh, for: .vertical)
        if firstResponder {
            input.becomeFirstResponder()
        }
        input.onTextChange = { unformatted in
            text = unformatted
        }

        return input
    }

    func updateUIView(_ uiView: AmountInput, context: Context) {
        viewHolder.view = uiView
        uiView.text = text
    }

    public func textStyle(_ style: TextStyle?) -> Self {
        var view = self
        view.font = style?.uiFont
        return view
    }

    public func isCurrencyPrefix(_ isPrefix: Bool) -> Self {
        var view = self
        view.isCurrencyPrefix = isPrefix
        return view
    }

    public func currencySymbol(_ symbol: String) -> Self {
        var view = self
        view.currencySymbol = symbol
        return view
    }

    public func accentColor(_ color: Color) -> Self {
        var view = self
        view.accentColor = UIColor(color)
        return view
    }

    public func amountForegroundColor(_ color: Color) -> Self {
        var view = self
        view.amountForegroundColor = UIColor(color)
        return view
    }

    public func currencyForegroundColor(_ color: Color) -> Self {
        var view = self
        view.currencyForegroundColor = UIColor(color)
        return view
    }

    public func horizontalPadding(_ padding: CGFloat) -> Self {
        var view = self
        view.horizontalPadding = padding
        return view
    }

    public func currencySpacing(_ spacing: CGFloat) -> Self {
        var view = self
        view.spacing = spacing
        return view
    }

    public func keyboardType(_ keyboardType: UIKeyboardType) -> Self {
        var view = self
        view.keyboardType = keyboardType
        return view
    }

    public func startAsFirstResponder() -> Self {
        var view = self
        view.firstResponder = true
        return view
    }

    public func focusTrigger(_ trigger: Binding<Bool>) -> some View {
        onChange(of: trigger.wrappedValue) { _ in
            viewHolder.view?.becomeFirstResponder()
        }
    }
}

class AmountInput: UIView {

    private let moneyInputController = TextFieldStartInputController()
    private let moneyFormatter = SumTextInputFormatter(textPattern: "# ###,#")
    private let amountField = UITextField()
    private let currencyLabel = UILabel()
    private let contentView = UIStackView()

    var onTextChange: ((String) -> Void)?

    var text: String {
        get { amountField.text ?? "" }
        set {
            let formatted = moneyFormatter.format(newValue)
            if formatted != amountField.text {
                amountField.text = formatted
            }
        }
    }

    var font: UIFont? {
        get { amountField.font }
        set {
            amountField.font = newValue
            currencyLabel.font = newValue
        }
    }

    var currencySymbol: String {
        get { currencyLabel.text ?? "" }
        set { currencyLabel.text = newValue }
    }

    var accentColor: UIColor? {
        get { amountField.tintColor }
        set { amountField.tintColor = newValue}
    }

    var amountForegroundColor: UIColor? {
        get { amountField.textColor }
        set { amountField.textColor = newValue}
    }

    var currencyForegroundColor: UIColor? {
        get { currencyLabel.textColor }
        set { currencyLabel.textColor = newValue}
    }

    var keyboardType: UIKeyboardType {
        get { amountField.keyboardType }
        set { amountField.keyboardType = newValue }
    }

    init(isCurrencyPrefix: Bool, horizontalPadding: CGFloat, spacing: CGFloat) {
        super.init(frame: .zero)
        initialize(isCurrencyPrefix, horizontalPadding: horizontalPadding, spacing: spacing)
    }

    override init(frame: CGRect) {
        fatalError("use init(isCurrencyPrefix:)")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        amountField.becomeFirstResponder()
    }

    private func initialize(_ isPrefix: Bool, horizontalPadding: CGFloat, spacing: CGFloat) {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        amountField.translatesAutoresizingMaskIntoConstraints = false

        contentView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentView.axis = .horizontal
        contentView.spacing = spacing
        addSubview(contentView)
        if isPrefix {
            contentView.addArrangedSubview(currencyLabel)
        }
        contentView.addArrangedSubview(amountField)
        if !isPrefix {
            contentView.addArrangedSubview(currencyLabel)
        }

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: horizontalPadding),
            contentView.heightAnchor.constraint(equalTo: amountField.heightAnchor),
            heightAnchor.constraint(equalTo: contentView.heightAnchor),
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])

        amountField.borderStyle = .none
        amountField.backgroundColor = .clear
        amountField.textAlignment = .center
        amountField.adjustsFontSizeToFitWidth = false
        amountField.addTarget(self, action: #selector(amountDidChange), for: .editingChanged)
        amountField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        amountField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        moneyInputController.formatter = moneyFormatter
        amountField.delegate = moneyInputController

        currencyLabel.textColor = .darkGray
        currencyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        currencyLabel.font = amountField.font
    }

    @objc private func amountDidChange() {
        if let text = amountField.text, let index = text.firstIndex(of: ",") {
            amountField.text = String(text.prefix(upTo: index))
        }
        if let text = amountField.text, text == "NaN" {
            amountField.text = ""
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (1 / 60)) {
            self.currencyLabel.font = self.amountField.font
        }

        amountField.minimumFontSize = isAdapting ? 10 : (currencyLabel.font?.pointSize ?? 0)
        amountField.adjustsFontSizeToFitWidth = isAdapting

        onTextChange?(moneyFormatter.unformat(amountField.text) ?? "")
    }

    override var intrinsicContentSize: CGSize {
        .init(width: UIScreen.main.bounds.width, height: amountField.intrinsicContentSize.height)
    }

    private var isAdapting: Bool {
        amountField.bounds.width >= UIScreen.main.bounds.width / 2
    }
}
