//
//  CriteriaView.swift
//  DesignKit
//
//  Created by Szabó Zoltán on 2021. 10. 26..
//

import SwiftUI

public struct Criteria: Identifiable {
    public var id: String { title }
    public let title: String
    public let isFulfilled: Bool

    public init(
        title: String,
        fulfilled: Bool
    ) {
        self.title = title
        self.isFulfilled = fulfilled
    }
}

public struct CriteriaView: View {
    var isEditingPassword: Bool
    var criterias: [Criteria]

    public init(criterias: [Criteria], isEditingPassword: Bool) {
        self.criterias = criterias
        self.isEditingPassword = isEditingPassword
    }

    public var body: some View {
        VStack(spacing: .m) {
            ForEach(criterias) { criteria in
                HStack {
                    image(for: criteria)
                        .resizable()
                        .foregroundColor(color(for: criteria))
                        .frame(width: 24, height: 24)
                    Text(criteria.title)
                        .textStyle(.body2)
                        .foregroundColor(.text.tertiary)
                        .padding([.leading], .xs)
                    Spacer()
                }
            }
        }
    }

    private func image(for criteria: Criteria) -> Image {
        if criteria.isFulfilled {
            return Image(.success)
        } else if isEditingPassword {
            return Image(.remove)
        } else {
            return Image(.alert)
        }
    }

    private func color(for criteria: Criteria) -> Color {
        if criteria.isFulfilled {
            return .success.highlight
        } else if isEditingPassword {
            return .text.tertiary
        } else {
            return .error.highlight
        }
    }
}
