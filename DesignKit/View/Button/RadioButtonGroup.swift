//
//  RadioButtonGroup.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 11. 11..
//

import Combine
import SwiftUI

public struct RadioButtonOption<ValueType: Equatable>: Equatable {
    public let title: String
    public let subtitle: String?
    public let value: ValueType

    public init(title: String, subtitle: String? = nil, value: ValueType) {
        self.title = title
        self.subtitle = subtitle
        self.value = value
    }
}

public struct RadioButtonOptionSet<ValueType: Equatable>: Equatable {
    public let dataSet: [RadioButtonOption<ValueType>]
    public var selected: ValueType

    public init(dataSet: [RadioButtonOption<ValueType>], selected: ValueType) {
        self.dataSet = dataSet
        self.selected = selected
    }

    public init(dataSet: [(title: String, value: ValueType)], selected: ValueType) {
        self.dataSet = dataSet.map({ .init(title: $0.title, value: $0.value) })
        self.selected = selected
    }

    public func selecting(value: ValueType) -> RadioButtonOptionSet {
        .init(dataSet: dataSet, selected: value)
    }
}

public struct RadioButtonGroup<ValueType: Equatable>: View {

    @Binding var options: RadioButtonOptionSet<ValueType>
    let axis: Axis
    let state: ValidationState

    public init(
        options: Binding<RadioButtonOptionSet<ValueType>>,
        axis: Axis = .horizontal,
        state: ValidationState = .normal
    ) {
        self._options = options
        self.axis = axis
        self.state = state
    }

    public var body: some View {
        VStack(alignment: .leading) {
            switch axis {
            case .horizontal:
                HStack(alignment: .center, spacing: .m) {
                    content
                }
            case .vertical:
                VStack(alignment: .leading, spacing: .m) {
                    content
                }
            }
            if let errorText = errorText {
                errorView(with: errorText)
            }
        }
    }

    private var content: some View {
        ForEach(Array(options.dataSet), id: \.title) { data in
            RadioButton(
                title: data.title,
                subtitle: data.subtitle,
                selected: data.value == options.selected,
                selectedBorderColor: selectedBorderColor,
                didSelect: {
                    options = options.selecting(value: data.value)
                }
            )
        }
    }

    func errorView(with text: String) -> some View {
        Text(text)
            .textStyle(.body2)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .foregroundColor(.error.highlight)
            .frame(height: 28)
    }

    var errorText: String? {
        switch state {
        case .normal:
            return nil
        case .error(let text):
            return text
        case .loading:
            return nil
        case .validated:
            return nil
        case .warning:
            return nil
        }
    }

    var selectedBorderColor: Color {
        switch state {
        case .normal:
            return .highlight.tertiary
        case .error:
            return .error.highlight
        case .loading:
            return .highlight.tertiary
        case .validated:
            return .highlight.tertiary
        case .warning:
            return .highlight.tertiary
        }
    }
}

private struct RadioButton: View {
    @Environment(\.isEnabled) var isEnabled

    public enum ValidationState: Equatable {
        case normal
        case error
    }

    var title: String
    var subtitle: String?
    var selected: Bool
    var selectedBorderColor: Color = .highlight.tertiary
    var didSelect: () -> Void

    var body: some View {
        Button(
            action: { didSelect() },
            label: {
                HStack(spacing: 0) {
                    ZStack {
                        if !isEnabled {
                            Circle()
                                .foregroundColor(Color.background.primaryDisabled)
                                .frame(width: 32, height: 32)
                            if selected {
                                Circle()
                                    .foregroundColor(Color.element.disabled.foreground)
                                    .frame(width: 8, height: 8)
                            }
                        } else {
                            Circle()
                                .strokeBorder(Color.element.tertiary, lineWidth: 2)
                                .frame(width: 32, height: 32)
                            if selected {
                                Circle()
                                    .strokeBorder(selectedBorderColor, lineWidth: 12)
                                    .frame(width: 32, height: 32)
                            }
                        }
                    }
                    .background(Color.background.primary)
                    .cornerRadius(16)
                    VStack(alignment: .leading, spacing: .xxs) {
                        Text(title)
                            .textStyle(.headings5)
                            .foregroundColor(Color.text.primary)
                            .multilineTextAlignment(.leading)
                            .padding(.leading, .xs)
                            .fixedSize(horizontal: false, vertical: true)
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .textStyle(.body2)
                                .foregroundColor(Color.text.secondary)
                                .multilineTextAlignment(.leading)
                                .padding(.leading, .xs)
                        }
                    }
                }
            }
        ).buttonStyle(RadioButtonStyle())
    }
}

private struct RadioButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(
                configuration.isPressed ? 0.6 : 1
            )
    }
}

private class MockViewModel: ObservableObject {
    @Published var options = RadioButtonOptionSet(
        dataSet: [
            .init(title: "Igen", value: true),
            .init(title: "Nem", value: false)
        ],
        selected: true
    )

    @Published var singleOption = RadioButtonOptionSet(
        dataSet: [
            .init(
                title: "Igen",
                subtitle: "Semmilyen formában nem szeretnék értesülni az újdonságokról, ajánlatokról.",
                value: true
            )
        ],
        selected: false
    )
}

struct RadioButtonGroup_Previews: PreviewProvider {
    @ObservedObject private static var viewModel = MockViewModel()

    static var previews: some View {
        VStack {
            RadioButtonGroup(
                options: $viewModel.singleOption,
                axis: .vertical,
                state: .normal
            )
            .padding()
            RadioButtonGroup(
                options: $viewModel.options,
                state: .error(text: "Ez itt egy hiba")
            )
            .padding()
            .disabled(false)
        }
        .preferredColorScheme(.light)
    }
}

struct RadioButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: .xxxl) {
            RadioButton(title: "Title", selected: true, didSelect: {})
            RadioButton(title: "Title", selected: false, didSelect: {})
            RadioButton(title: "Title", selected: true, selectedBorderColor: .orange, didSelect: {})
        }
    }
}
