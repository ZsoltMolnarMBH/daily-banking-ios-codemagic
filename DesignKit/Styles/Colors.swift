//
//  Colors.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 21..
//

import SwiftUI

public extension Color {
    struct Pair {
        public let foreground: Color
        public let background: Color
    }

    struct ActionStyleSingle {
        public let `default`: Color
        public let pressed: Color
        public let disabled: Color
    }

    struct ActionStylePair {
        public let `default`: Pair
        public let pressed: Pair
        public let disabled: Pair
    }

    struct FeedbackStyle {
        public let primary: Pair
        public let secondary: Pair
        public let highlight: Color
    }
}

public extension Color {

    // MARK: Neutral styles

    static let background = Background()
    struct Background {
        public let primary = Color(light: Colors.grey0, dark: Colors.grey900)
        public let secondary = Color(light: Colors.grey50, dark: Colors.grey950)
        public let primaryPressed = Color(light: Colors.grey50, dark: Colors.grey950)
        public let primaryDisabled = Color(light: Colors.grey100, dark: Colors.grey800)
    }

    static let text = Text()
    struct Text {
        public let primary = Color(light: Colors.grey950, dark: Colors.grey0)
        public let secondary = Color(light: Colors.grey800, dark: Colors.grey100)
        public let tertiary = Color(light: Colors.grey600, dark: Colors.grey300)
        public let disabled = Color(light: Colors.grey400, dark: Colors.grey500)
    }

    static let element = Element()
    struct Element {
        public let primary = Pair(foreground: Color(light: Colors.grey0, dark: Colors.grey950),
                                  background: Color(light: Colors.grey900, dark: Colors.grey0))
        public let secondary = Pair(foreground: Color(light: Colors.grey800, dark: Colors.grey100),
                                    background: Color(light: Colors.grey100, dark: Colors.grey800))
        public let tertiary = Color(light: Colors.grey200, dark: Colors.grey700)
        public let disabled = Pair(foreground: Color(light: Colors.grey400, dark: Colors.grey500),
                                   background: Color(light: Colors.grey100, dark: Colors.grey800))
    }

    static let highlight = Highlight()
    struct Highlight {
        public let primary = Color.Pair(foreground: Color(light: Colors.grey0, dark: Colors.grey950),
                                        background: Color(light: Colors.action600, dark: Colors.action300))
        public let secondary = Color.Pair(foreground: Color(light: Colors.action800, dark: Colors.action300),
                                          background: Color(light: Colors.action100, dark: Colors.action900))
        public let tertiary = Color(light: Colors.action600, dark: Colors.action300)
    }

    // MARK: Action styles

    static let action = Action()
    struct Action {
        public let accent = ActionStylePair(
            default: Color.Pair(
                foreground: Color(light: Colors.grey0, dark: Colors.grey950),
                background: Color(light: Colors.accent600, dark: Colors.accent300)),
            pressed: Color.Pair(
                foreground: Color(light: Colors.grey0, dark: Colors.grey950),
                background: Color(light: Colors.accent800, dark: Colors.accent500)),
            disabled: Color.Pair(
                foreground: Color(light: Colors.grey400, dark: Colors.grey500),
                background: Color(light: Colors.grey100, dark: Colors.grey800)))

        public let primary = ActionStylePair(
            default: Color.Pair(
                foreground: Color(light: Colors.grey0, dark: Colors.grey1000),
                background: Color(light: Colors.action600, dark: Colors.action300)),
            pressed: Color.Pair(
                foreground: Color(light: Colors.grey0, dark: Colors.grey1000),
                background: Color(light: Colors.action800, dark: Colors.action500)),
            disabled: Color.Pair(
                foreground: Color(light: Colors.grey400, dark: Colors.grey500),
                background: Color(light: Colors.grey100, dark: Colors.grey800)))

        public let secondary = ActionStylePair(
            default: Color.Pair(
                foreground: Color(light: Colors.action600, dark: Colors.action300),
                background: Color(light: Colors.action50, dark: Colors.action800)),
            pressed: Color.Pair(
                foreground: Color(light: Colors.action600, dark: Colors.action300),
                background: Color(light: Colors.action200, dark: Colors.action950)),
            disabled: Color.Pair(
                foreground: Color(light: Colors.grey400, dark: Colors.grey500),
                background: Color(light: Colors.grey100, dark: Colors.grey800)))

        public let tertiary = ActionStyleSingle(
            default: Color(light: Colors.action600, dark: Colors.action300),
            pressed: Color(light: Colors.action800, dark: Colors.action500),
            disabled: Color(light: Colors.grey400, dark: Colors.grey500))

        public let quarterly = ActionStyleSingle(
            default: Color(light: Colors.grey600, dark: Colors.grey300),
            pressed: Color(light: Colors.grey800, dark: Colors.grey500),
            disabled: Color(light: Colors.grey400, dark: Colors.grey500))
    }

    static let destructive = Destructive()
    struct Destructive {
        public let primary = ActionStylePair(
            default: Color.Pair(
                foreground: Color(light: Colors.grey0, dark: Colors.grey0),
                background: Color(light: Colors.error700, dark: Colors.error300)),
            pressed: Color.Pair(
                foreground: Color(light: Colors.grey0, dark: Colors.grey0),
                background: Color(light: Colors.error900, dark: Colors.error500)),
            disabled: Color.Pair(
                foreground: Color(light: Colors.grey400, dark: Colors.grey500),
                background: Color(light: Colors.grey100, dark: Colors.grey800)))

        public let secondary = ActionStylePair(
            default: Color.Pair(
                foreground: Color(light: Colors.error700, dark: Colors.error300),
                background: Color(light: Colors.error50, dark: Colors.error800)),
            pressed: Color.Pair(
                foreground: Color(light: Colors.error700, dark: Colors.error300),
                background: Color(light: Colors.error200, dark: Colors.error900)),
            disabled: Color.Pair(
                foreground: Color(light: Colors.grey400, dark: Colors.grey500),
                background: Color(light: Colors.grey100, dark: Colors.grey800)))

        public let tertiary = ActionStyleSingle(
            default: Color(light: Colors.error700, dark: Colors.error300),
            pressed: Color(light: Colors.error900, dark: Colors.error500),
            disabled: Color(light: Colors.grey400, dark: Colors.grey500))
    }

    // MARK: Feedback styles

    static let error = FeedbackStyle(
        primary: Color.Pair(
            foreground: Color(light: Colors.grey0, dark: Colors.grey0),
            background: Color(light: Colors.error700, dark: Colors.error700)),
        secondary: Color.Pair(
            foreground: Color(light: Colors.error800, dark: Colors.error300),
            background: Color(light: Colors.error100, dark: Colors.error900)),
        highlight: Color(light: Colors.error700, dark: Colors.error300))

    static let warning = FeedbackStyle(
        primary: Color.Pair(
            foreground: Color(light: Colors.grey950, dark: Colors.grey950),
            background: Color(light: Colors.warning600, dark: Colors.warning600)),
        secondary: Color.Pair(
            foreground: Color(light: Colors.warning800, dark: Colors.warning300),
            background: Color(light: Colors.warning100, dark: Colors.warning900)),
        highlight: Color(light: Colors.warning800, dark: Colors.warning300))

    static let success = FeedbackStyle(
        primary: Color.Pair(
            foreground: Color(light: Colors.grey0, dark: Colors.grey0),
            background: Color(light: Colors.success700, dark: Colors.success700)),
        secondary: Color.Pair(
            foreground: Color(light: Colors.success800, dark: Colors.success300),
            background: Color(light: Colors.success100, dark: Colors.success900)),
        highlight: Color(light: Colors.success800, dark: Colors.success300))

    static let info = FeedbackStyle(
        primary: Color.Pair(
            foreground: Color(light: Colors.grey0, dark: Colors.grey0),
            background: Color(light: Colors.info700, dark: Colors.info700)),
        secondary: Color.Pair(
            foreground: Color(light: Colors.info800, dark: Colors.info300),
            background: Color(light: Colors.info100, dark: Colors.info900)),
        highlight: Color(light: Colors.info700, dark: Colors.info300))
}

public extension UIColor {
    convenience init(
        light lightModeColor: @escaping @autoclosure () -> UIColor,
        dark darkModeColor: @escaping @autoclosure () -> UIColor
     ) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return darkModeColor()
            default:
                return lightModeColor()
            }
        }
    }
}

public extension Color {
    init(
        light lightModeColor: @escaping @autoclosure () -> Color,
        dark darkModeColor: @escaping @autoclosure () -> Color
    ) {
        self.init(UIColor(
            light: UIColor(lightModeColor()),
            dark: UIColor(darkModeColor())
        ))
    }
}
