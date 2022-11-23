//
//  TextInputHelper.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 02. 08..
//

import SwiftUI

public protocol TextInputCommon: View {
    var isEnabled: Bool { get }
    var isViewOnly: Bool { get set }
    var viewOnlyTapAction: (() -> Void)? { get set }
    var state: ValidationState { get }
    var focused: Bool { get }
    var isAlreadyEdited: Bool { get }
    var isHidingErrorWhileEditing: Bool { get set }
    var isHidingErrorBeforeEditing: Bool { get set }
}

extension TextInputCommon {
    var visibleState: ValidationState {
        if case .error = state {
            if focused && isHidingErrorWhileEditing {
                return .normal
            }
            if !isAlreadyEdited && isHidingErrorBeforeEditing {
                return .normal
            }
        }
        return state
    }

    var cursorColor: Color {
        return .highlight.tertiary
    }

    var borderColor: Color {
        guard isEnabled && !isViewOnly else { return .clear}

        switch visibleState {
        case .normal, .loading:
            if focused {
                return .highlight.tertiary
            } else {
                return .element.tertiary
            }
        case .validated:
            return .success.highlight
        case .warning:
            return .warning.highlight
        case .error:
            return .error.highlight
        }
    }

    var errorColor: Color {
        switch visibleState {
        case .warning:
            return .warning.highlight
        case .error:
            return .error.highlight
        default:
            return .clear
        }
    }

    var backgroundColor: Color {
        if isEnabled && !isViewOnly {
            return .background.primary
        } else {
            return .background.primaryDisabled
        }
    }

    var textColor: Color {
        if isEnabled || isViewOnly {
            return .text.primary
        } else {
            return .text.disabled
        }
    }

    var errorText: String? {
        switch visibleState {
        case .normal, .validated, .loading:
            return nil
        case .error(let text):
            return text
        case .warning(let text):
            return text
        }
    }

    var isErrorViewVisible: Bool {
        return errorText != nil && errorText?.isEmpty == false
    }

    @ViewBuilder func errorView() -> some View {
        Text(errorText ?? "")
            .textStyle(.body2)
            .fixedSize(horizontal: false, vertical: true)
            .multilineTextAlignment(.leading)
            .foregroundColor(errorColor)
            .padding(.top, .xs)
    }
}

public extension TextInputCommon {
    func hideErrorWhileEditing(_ hide: Bool) -> Self {
        var view = self
        view.isHidingErrorWhileEditing = hide
        return view
    }

    func hideErrorBeforeEditing(_ hide: Bool) -> Self {
        var view = self
        view.isHidingErrorBeforeEditing = hide
        return view
    }

    func viewOnly(_ isViewOnly: Bool, tapAction: (() -> Void)? = nil) -> some View {
        var view = self
        view.isViewOnly = isViewOnly
        view.viewOnlyTapAction = tapAction
        return view
    }
}
