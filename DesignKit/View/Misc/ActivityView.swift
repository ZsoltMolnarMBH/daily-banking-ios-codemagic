//
//  ActivityView.swift
//  DesignKit
//
//  Created by Alexa Mark on 2021. 12. 10..
//

import Foundation
import SwiftUI
import PDFKit

public struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    public init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return activityViewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
