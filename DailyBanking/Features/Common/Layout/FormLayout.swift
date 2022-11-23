//
//  FormLayout.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 01. 26..
//

import SwiftUI
import DesignKit

public struct FormLayout<Content: View, Floater: View>: View {
    // MARK: Given content
    @ViewBuilder let content: (ScrollViewProxy) -> Content
    @ViewBuilder let floater: () -> Floater

    // MARK: Settable properties
    private var backgroundColor = Color.background.secondary
    private var floaterHint: String?
    private var moveFloaterWithKeyboard = false

    // MARK: Internals
    @Environment(\.keyWindowSafeAreaInsets) private var safeArea
    @StateObject private var keyboard = KeyboardFollower()
    @State private var keyboardHeight: CGFloat = 0
    @State private var floaterHeight: CGFloat = 155
    @State private var layoutHeight: CGFloat = 0
    @State private var contentHeight: CGFloat = UIScreen.main.bounds.height

    @State private var didAppear: Bool = false

    public init(@ViewBuilder content: @escaping () -> Content,
                @ViewBuilder floater: @escaping () -> Floater) {
        self.content = { _ in content() }
        self.floater = floater
    }

    public init(@ViewBuilder content: @escaping (ScrollViewProxy) -> Content,
                @ViewBuilder floater: @escaping () -> Floater) {
        self.content = content
        self.floater = floater
    }

    public var body: some View {
        ZStack {
            backgroundColor.ignoresSafeArea(.all)
            ScrollViewReader { proxy in
                ScrollView {
                    content(proxy)
                        .frame(minHeight: contentHeight)
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Spacer().frame(height: bottomInsetHeight)
            }
            VStack {
                Spacer()
                VStack(spacing: .m) {
                    floater()
                    if let floaterHint = floaterHint {
                        Text(floaterHint)
                            .frame(maxWidth: .infinity)
                            .textStyle(.body2)
                            .foregroundColor(.text.tertiary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding([.leading, .trailing, .top], .m)
                .padding(.bottom, (moveFloaterWithKeyboard && keyboardHeight > 0) ? .xs : bottomPadding)
                .background(LinearGradient(
                    gradient: Gradient(colors: [backgroundColor.opacity(0.01), backgroundColor]),
                    startPoint: .top, endPoint: .bottom))
                .measure { size in
                    guard floaterHeight != size.height else { return }
                    floaterHeight = size.height
                    calculateContentHeight()
                }
            }
            .if(!moveFloaterWithKeyboard) {
                $0.ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
        .onChange(of: keyboard.state) { state in
            withAnimation {
                if state.isVisible {
                    keyboardHeight = state.height
                } else {
                    keyboardHeight = 0
                }
            }
        }
        .onTapGesture { hideKeyboard() }
        .measure { size in
            guard layoutHeight != size.height else { return }
            layoutHeight = size.height
            calculateContentHeight()
        }
        .onAppear(after: .transition, action: { didAppear = true })
    }

    var bottomPadding: CGFloat {
        safeArea.bottom > 0 ? 0 : .m
    }

    func calculateContentHeight() {
        let newHeight = layoutHeight - bottomInsetHeight
        guard newHeight != contentHeight else { return }
        if didAppear {
            withAnimation { contentHeight = newHeight }
        } else {
            contentHeight = newHeight
        }
    }

    var bottomInsetHeight: CGFloat {
        if moveFloaterWithKeyboard {
            return floaterHeight
        } else {
            return keyboardHeight == 0 ? floaterHeight : .m
        }
    }
}

public extension FormLayout {
    func floaterHint(_ floaterHint: String) -> Self {
        configure(\.floaterHint, floaterHint)
    }

    func formBackground(_ color: Color) -> Self {
        configure(\.backgroundColor, color)
    }

    func floaterAttachedToKeyboard(_ value: Bool) -> Self {
        configure(\.moveFloaterWithKeyboard, value)
    }

    private func configure<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var view = self
        view[keyPath: keyPath] = value
        return view
    }
}

struct DesignForm_Previews: PreviewProvider {
    static var previews: some View {
        FormLayout(content: {
            VStack {
                ForEach(0..<10) { number in
                    SectionCard {
                        Text("Hello \(number)")
                    }
                }
                SectionCard {
                    TextField("", text: .constant(""))
                }
                ForEach(0..<6) { number in
                    SectionCard {
                        Text("Hello \(number)")
                    }
                }
                Spacer()
            }
            .padding()
        }, floater: {
            DesignButton(title: "Okay") { }
        })
        .floaterHint("Next page will be interesting\n123")
        .floaterAttachedToKeyboard(true)
        .formBackground(.background.secondary)
    }
}
