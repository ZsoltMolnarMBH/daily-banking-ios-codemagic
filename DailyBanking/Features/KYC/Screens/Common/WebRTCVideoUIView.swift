//
//  WebRTCVideoView.swift
//  DailyBanking
//
//  Created by ALi on 2022. 03. 21..
//

import UIKit
import WebRTC
import FaceKomSDK

class WebRTCVideoUIView: UIView, RTCVideoViewDelegate {
#if arch(x86_64)
    let videoView = RTCEAGLVideoView(frame: .zero)
#else
    let videoView = RTCMTLVideoView(frame: .zero)
#endif
    var videoSize = CGSize.zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        videoView.delegate = self
        addSubview(videoView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        videoView.delegate = self
        addSubview(videoView)
    }

    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
        self.videoSize = size
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if self.videoSize.width > 0 && self.videoSize.height > 0 {
            var videoFrame = AVMakeRect(aspectRatio: self.videoSize, insideRect: bounds)
            var scale: CGFloat = 1.0
            if videoFrame.size.width > videoFrame.size.height {
                scale = bounds.size.width / videoFrame.size.width
            } else {
                scale = bounds.size.height / videoFrame.size.height
            }
            videoFrame.size.width *= scale
            videoFrame.size.height *= scale
            self.videoView.frame = videoFrame
            self.videoView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        } else {
            self.videoView.frame = bounds
        }
    }
}
