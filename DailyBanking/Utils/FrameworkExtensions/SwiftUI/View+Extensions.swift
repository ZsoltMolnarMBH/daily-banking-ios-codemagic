//
//  View+Extensions.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 30..
//

import SwiftUI
import DesignKit

extension View {
    @ViewBuilder
    func fullScreenProgress(by condition: Bool, name: String = "progress") -> some View {
        self.onChange(of: condition) { isLoading in
            if isLoading {
                Modals.progress.show(
                    view: ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white)),
                    name: name
                )
            } else {
                Modals.progress.dismiss(name)
            }
        }
        .onDisappear {
            Modals.progress.dismiss(name)
        }
    }

    @ViewBuilder
    func addClose(_ action: @escaping () -> Void) -> some View {
        self.toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    action()
                    analytics.logButtonPress(contentType: "close icon", componentLabel: nil)
                } label: {
                    Image(.close)
                        .imageScale(.large)
                        .foregroundColor(.action.tertiary.default)
                }
            }
        })
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func paddingFloating() -> some View {
        @Environment(\.keyWindowSafeAreaInsets) var safeArea
        return self.padding([.leading, .trailing, .top], .m)
            .padding([.bottom], safeArea.bottom > 0 ? 0 : .m)
    }

    @ViewBuilder func measure(_ block: @escaping (CGSize) -> Void) -> some View {
        self.background {
            GeometryReader { geometry in
                save(size: geometry.size, block: block)
            }
        }
    }

    private func save(size: CGSize, block: @escaping (CGSize) -> Void) -> some View {
        DispatchQueue.main.async {
            block(size)
        }
        return Rectangle().fill(Color.clear)
    }

    func onAppWillResignActive(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            action()
        }
    }

    func onAppDidEnterBackground(perform action: @escaping () -> Void) -> some View {
        self.onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
            action()
        }
    }

    func feedbackOnAppear(_ feedback: UINotificationFeedbackGenerator.FeedbackType, after timeInterval: TimeInterval = 0) -> some View {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        return self.onAppear(after: timeInterval + 0.25) {
            generator.notificationOccurred(feedback)
        }
    }

    /// Focuses next field in sequence, from the given `FocusState`.
    /// Requires a currently active focus state and a next field available in the sequence.
    ///
    /// Example usage:
    /// ```
    /// .onSubmit { self.focusNextField($focusedField) }
    /// ```
    /// Given that `focusField` is an enum that represents the focusable fields. For example:
    /// ```
    /// @FocusState private var focusedField: Field?
    /// enum Field: Int, Hashable {
    ///    case name
    ///    case country
    ///    case city
    /// }
    /// ```
    func focusNextField<F: RawRepresentable>(_ field: FocusState<F?>.Binding, resignOnLast: Bool = true) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue + 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        } else if resignOnLast {
            field.wrappedValue = nil
        }
    }

    /// Focuses previous field in sequence, from the given `FocusState`.
    /// Requires a currently active focus state and a previous field available in the sequence.
    ///
    /// Example usage:
    /// ```
    /// .onSubmit { self.focusNextField($focusedField) }
    /// ```
    /// Given that `focusField` is an enum that represents the focusable fields. For example:
    /// ```
    /// @FocusState private var focusedField: Field?
    /// enum Field: Int, Hashable {
    ///    case name
    ///    case country
    ///    case city
    /// }
    /// ```
    func focusPreviousField<F: RawRepresentable>(_ field: FocusState<F?>.Binding, resignOnFirst: Bool = true) where F.RawValue == Int {
        guard let currentValue = field.wrappedValue else { return }
        let nextValue = currentValue.rawValue - 1
        if let newValue = F.init(rawValue: nextValue) {
            field.wrappedValue = newValue
        } else if resignOnFirst {
            field.wrappedValue = nil
        }
    }
}
