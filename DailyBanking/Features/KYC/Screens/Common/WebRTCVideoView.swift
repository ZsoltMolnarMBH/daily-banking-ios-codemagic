//
//  WebRTCVideoView.swift
//  FaceKomPOC
//
//  Created by ALi on 2022. 03. 21..
//

import UIKit
import SwiftUI

struct WebRTCVideoView: UIViewRepresentable {

    let uiKitComponent: WebRTCVideoUIView = .init()

    func makeUIView(context: Context) -> WebRTCVideoUIView {
        uiKitComponent
    }

    func updateUIView(_ uiView: WebRTCVideoUIView, context: Context) {

    }
}
