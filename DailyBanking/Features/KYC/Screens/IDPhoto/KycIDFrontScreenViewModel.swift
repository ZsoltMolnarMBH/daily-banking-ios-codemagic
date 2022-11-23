//
//  KycIDFrontScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 03. 28..
//

import DesignKit
import Foundation

class KycIDFrontScreenViewModel: BasePhotoScreenViewModel {

    override init() {
        super.init()
        shape = .rectangle
        mode = .instructions(
            text: Strings.Localizable.kycIdCardFrontInstruction,
            animation: .init(kind: .hint, asset: .idFront)
        )
    }

    override func onNext() {
        mode = .capture(info: Strings.Localizable.kycIdCardFrontCaptureInfo)
    }

    override func shouldFinish(when nextStep: FaceKom.Step) -> Bool {
        if case .idFront(let isRetry) = nextStep {
            if isRetry { state = .error(Strings.Localizable.kycPhotoError) }
            return isRetry
        }
        return true
    }
}
