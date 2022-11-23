//
//  KycSelfiePhotoScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 08..
//

import AVFoundation
import Foundation
import SwiftUI

class KycSelfiePhotoScreenViewModel: BasePhotoScreenViewModel {

    override var capturePosition: AVCaptureDevice.Position { .front }

    override init() {
        super.init()
        previewOrientation = .upMirrored
        shape = .capsule
        mode = .instructions(text: Strings.Localizable.kycSelfieInstruction, animation: .init(kind: .hint, asset: .faceTheCamera))
    }

    override func onNext() {
       mode = .capture(info: Strings.Localizable.kycSelfieInfo)
    }

    override func prepare(frame: CGImage) -> UIImage {
        let image = UIImage(cgImage: frame)
        snapshotImage = UIImage(cgImage: frame, scale: image.scale, orientation: .upMirrored)
        let cutOff = max(0, min(config.selfieCropSize, 0.5))
        return image.crop(cutOff: cutOff)
    }

    override func display(error: FaceKomActionPhotoUploadError) {
        switch error {
        case .portraitMoveHeadCloser:
            state = .error(Strings.Localizable.kycPhotoErrorMoveHeadCloser)
        case .portraitMoveHeadAway:
            state = .error(Strings.Localizable.kycPhotoErrorMoveHeadAway)
        case .portraitFaceIsMissing:
            state = .error(Strings.Localizable.kycPhotoErrorFaceMissing)
        default:
            state = .error(Strings.Localizable.kycPhotoError)
        }
    }

    override func shouldFinish(when nextStep: FaceKom.Step) -> Bool {
        if case .customerPortrait(let isRetry) = nextStep {
            if isRetry { state = .error(Strings.Localizable.kycPhotoError) }
            return isRetry
        }
        return true
    }
}
