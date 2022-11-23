//
//  KycIDBackScreenViewModel.swift
//  DailyBanking
//
//  Created by ALi on 2022. 03. 28..
//

import DesignKit
import Foundation

class KycIDBackScreenViewModel: BasePhotoScreenViewModel {
    override init() {
        super.init()
        shape = .rectangle
        mode = .instructions(
            text: Strings.Localizable.kycIdCardBackInstruction,
            animation: .init(kind: .hint, asset: .idBack)
        )
    }

    override func onNext() {
        mode = .capture(info: Strings.Localizable.kycIdCardBackCaptureInfo)
    }

    override func shouldFinish(when nextStep: FaceKom.Step) -> Bool {
        if case .idBack(let isRetry) = nextStep {
            if isRetry { state = .error(Strings.Localizable.kycPhotoError) }
            return isRetry
        }
        return true
    }
}
