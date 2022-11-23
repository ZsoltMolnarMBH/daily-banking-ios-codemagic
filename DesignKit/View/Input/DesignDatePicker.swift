//
//  DesignDatePicker.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2022. 04. 14..
//

import Foundation
import SwiftUI

public struct DesignDatePicker: TextInputCommon {
    @Environment(\.isEnabled) public var isEnabled
    public var isViewOnly: Bool = false
    public var viewOnlyTapAction: (() -> Void)?
    @Binding var date: Date?
    public let title: String
    public let infoButtonText: String?
    public let infoButtonAction: (() -> Void)?

    public var formatter = DateFormatter()
    public var range: ClosedRange<Date>
    public var defaultDate: Date

    @State public var isAlreadyEdited = false
    @State var showError: Bool = false
    public let state: ValidationState
    public let focused = false
    public var isHidingErrorWhileEditing = false
    public var isHidingErrorBeforeEditing = false

    public init(
        title: String = "",
        date: Binding<Date?>,
        state: ValidationState,
        infoButtonText: String? = nil,
        infoButtonAction: (() -> Void)? = nil
    ) {
        self.title = title
        self._date = date
        self.state = state
        self.infoButtonText = infoButtonText
        self.infoButtonAction = infoButtonAction

        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        range = .init(uncheckedBounds: (
            lower: Date.distantPast,
            upper: Date.distantFuture)
        )
        defaultDate = Date()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(title)
                    .textStyle(.body2)
                    .foregroundColor(.text.primary)
                Spacer()
                if let buttonText = infoButtonText, isEnabled {
                    Button(buttonText) {
                        infoButtonAction?()
                    }
                    .buttonStyle(DesignHighlight(style: .tertiary))
                    .textStyle(.headings6)
                    .foregroundColor(.action.tertiary.default)
                }
            }
            .padding(.vertical, .xs)
            DatePickingField(
                date: $date,
                formatter: formatter,
                range: range,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                textColor: textColor,
                defaultDate: defaultDate
            )
            .disabled(isViewOnly)
            .simultaneousGesture(TapGesture().onEnded({
                guard isViewOnly else { return }
                viewOnlyTapAction?()
            }))
            if showError {
                errorView()
            }
        }
        .onChange(of: isErrorViewVisible) { value in
            withAnimation { showError = value }
        }
        .onAppear {
            showError = isErrorViewVisible
        }
        .onChange(of: date) { _ in
            isAlreadyEdited = true
        }
    }

    public func dateFormatter(_ formatter: DateFormatter) -> DesignDatePicker {
        var view = self
        view.formatter = formatter
        return view
    }

    public func range(_ range: ClosedRange<Date>) -> DesignDatePicker {
        var view = self
        view.range = range
        return view
    }

    public func defaultDate(_ date: Date) -> DesignDatePicker {
        var view = self
        view.defaultDate = date
        return view
    }
}

private struct DatePickingField: View {
    @Environment(\.isEnabled) public var isEnabled
    @Binding var date: Date?
    let formatter: DateFormatter
    let range: ClosedRange<Date>
    let backgroundColor: Color
    let borderColor: Color
    let textColor: Color
    let defaultDate: Date

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack {
                    Spacer()
                    DatePicker(
                        "",
                        selection: Binding<Date>(
                            get: { self.date ?? defaultDate },
                            set: { self.date = $0 }),
                        in: range,
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .frame(width: 120)
                    .clipped()
                    .scaleEffect(x: geometry.size.width / 120)
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(backgroundColor)
                        .frame(height: 48)

                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(borderColor)
                        .frame(height: 48)

                    HStack {
                        Text(text)
                            .textStyle(.body1)
                            .foregroundColor(textColor)
                            .padding(.horizontal, .s)
                        Spacer()
                        Image(.calendar)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(textColor)
                            .padding(.horizontal, .s)
                    }
                }
                .allowsHitTesting(!isEnabled)
            }
        }
        .frame(height: 48)
    }

    private var text: String {
        if let date = date {
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
}

struct DesignDatePickerPreviews: PreviewProvider {

    static var previews: some View {
        VStack(spacing: .xxxl) {
            Spacer()
            Card {
                DesignDatePicker(
                    title: "Enter the date:",
                    date: .constant(Date()),
                    state: .error(text: "Hello error"),
                    infoButtonText: "Hol találom?"
                )
                .hideErrorBeforeEditing(false)
                .viewOnly(true)
            }
            Spacer()
        }
        .padding()
        .background(Color.background.secondary)

    }
}
