//
//  EmptyStateView.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2021. 12. 17..
//

import SwiftUI

public struct EmptyStateView: View {
    public let image: Image
    public let title: String
    public let description: String?

    public init(image: Image, title: String, description: String?) {
        self.image = image
        self.title = title
        self.description = description
    }

    public var body: some View {
        VStack {
            image
                .resizable()
                .frame(width: 72, height: 72)
            Text(title)
                .textStyle(.headings3.thin)
                .multilineTextAlignment(.center)
                .padding(.xs)
            if let description = description {
                Text(description)
                    .textStyle(.body2)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

public extension EmptyStateView {
    struct ViewModel: Equatable {
        public let imageName: String
        public let title: String
        public let description: String?

        public init(imageName: String, title: String, description: String?) {
            self.imageName = imageName
            self.title = title
            self.description = description
        }
    }

    init(viewModel: ViewModel) {
        self.init(image: Image(viewModel.imageName),
                  title: viewModel.title,
                  description: viewModel.description)
    }

    init(imageName: ImageName, title: String, description: String?) {
        self.init(image: Image(imageName.rawValue),
                  title: title,
                  description: description)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(imageName: .calendar,
                       title: "Töltse fel az egyenlegét",
                       description:
                        """
                        Első lépésként másolja ki a számlaszámát, és utaljon át a számlára egy Önnek tetsző összeget.
                        Ezután azonnal indíthat utalásokat, vagy fizethet bankkártyájával.
                        """
        )
    }
}
