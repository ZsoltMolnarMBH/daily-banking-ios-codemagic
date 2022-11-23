//
//  SectionHeader.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 01. 02..
//

import SwiftUI

public struct SectionHeader: View {
    let title: String
    let button: ButtonData?

    public struct ButtonData {
        public let imageName: String
        public let action: (() -> Void)

        public init(imageName: String, action: @escaping (() -> Void)) {
            self.imageName = imageName
            self.action = action
        }
    }

    public init(title: String, button: ButtonData? = nil) {
        self.title = title
        self.button = button
    }

    public var body: some View {
        HStack {
            Text(title)
                .textStyle(.headings5)
                .foregroundColor(.text.tertiary)
            if let button = button {
                Button {
                    DesignKitModule.analytics?.log(buttonPress: .init(
                        contentTypeOverride: "info icon",
                        selectedLabel: nil)
                    )
                    button.action()
                } label: {
                    Image(button.imageName)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.text.tertiary)
                }
            }
            Spacer()
        }
    }
}

public extension SectionHeader.ButtonData {
    init(image: ImageName, action: @escaping (() -> Void)) {
        self.init(imageName: image.rawValue, action: action)
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SectionHeader(title: "Some section header")
            SectionHeader(title: "Mysterios section", button: .init(imageName: ImageName.calendar.rawValue, action: {

            }))
        }
    }
}
