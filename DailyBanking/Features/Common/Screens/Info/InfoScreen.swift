//
//  InfoScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 06. 21..
//

import SwiftUI
import DesignKit

struct InfoScreenModel {

    let images: [ImageName]
    let title: String
    let imageOrientation: Orientation
    let messages: [String]
    let messageButtons: [Button]
    let buttons: [Button]
    let buttonOrientation: Orientation

    struct Button {
        let text: String
        let style: DesignButton.Style
        let action: (() -> Void)
    }

    enum Orientation {
        case horizontal
        case vertical
    }

    /// Generated member-wise initializer
    init(images: [ImageName],
         title: String,
         imageOrientation: InfoScreenModel.Orientation = .horizontal,
         messages: [String],
         messageButtons: [InfoScreenModel.Button],
         buttons: [InfoScreenModel.Button],
         buttonOrientation: InfoScreenModel.Orientation = .vertical) {
        self.images = images
        self.title = title
        self.imageOrientation = imageOrientation
        self.messages = messages
        self.messageButtons = messageButtons
        self.buttons = buttons
        self.buttonOrientation = buttonOrientation
    }

    /// Convenience initializer
    init(image: ImageName,
         title: String,
         message: String,
         button: Button) {
        self.images = [image]
        self.title = title
        self.imageOrientation = .horizontal
        self.messages = [message]
        self.messageButtons = []
        self.buttons = [button]
        self.buttonOrientation = .horizontal
    }

    init(image: ImageName,
         title: String,
         message: String,
         messageButton: Button,
         button: Button) {
        self.images = [image]
        self.title = title
        self.imageOrientation = .horizontal
        self.messages = [message]
        self.messageButtons = [messageButton]
        self.buttons = [button]
        self.buttonOrientation = .horizontal
    }
}

struct InfoScreen: View {
    let model: InfoScreenModel
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(spacing: .m) {
                Group {
                    switch model.imageOrientation {
                    case .horizontal:
                        HStack(spacing: .xl) {
                            images()
                        }
                    case .vertical:
                        VStack(spacing: .xl) {
                            images()
                        }
                    }
                }
                .padding(.bottom, .m)
                Text(model.title)
                    .textStyle(.headings3.thin)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.text.primary)
                VStack(spacing: .m) {
                    ForEach(Array(model.messages.enumerated()), id: \.offset) { item in
                        Text(item.element)
                    }
                }
                .multilineTextAlignment(.center)
                .textStyle(.body1)
                .foregroundColor(.text.tertiary)
                ForEach(Array(model.messageButtons.enumerated()), id: \.offset) { item in
                    DesignButton(
                        style: item.element.style,
                        title: item.element.text,
                        action: item.element.action
                    )
                }
            }
            .padding(.horizontal, .m)
            .lineSpacing(6)
            .padding()
            Spacer()
            switch model.buttonOrientation {
            case .horizontal:
                HStack(spacing: .m) {
                    floatingButtons()
                }
                .paddingFloating()
            case .vertical:
                VStack(spacing: .m) {
                    floatingButtons()
                }
                .paddingFloating()
            }
        }
        .background(Color.background.primary)
    }

    @ViewBuilder
    private func images() -> some View {
        ForEach(Array(model.images.enumerated()), id: \.offset) { item in
            Image(item.element)
                .resizable()
                .frame(width: 72, height: 72)
        }
    }

    @ViewBuilder
    private func floatingButtons() -> some View {
        ForEach(Array(model.buttons.enumerated()), id: \.offset) { item in
            DesignButton(
                style: item.element.style,
                title: item.element.text,
                action: item.element.action
            )
        }
    }

}

struct InfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoScreen(model: .init(
            images: [.faceid, .touchId],
            title: "Information",
            imageOrientation: .horizontal,
            messages: [
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqu",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqu",
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqu"
            ],
            messageButtons: [
                .init(text: "Read terms and conditions", style: .tertiary, action: {})
            ],
            buttons: [
                .init(text: "Accept", style: .primary, action: {}),
                .init(text: "Cancel", style: .secondary, action: {})
            ],
            buttonOrientation: .vertical)
        )
    }
}
