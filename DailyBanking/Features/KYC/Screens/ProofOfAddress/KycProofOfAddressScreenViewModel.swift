//
//  KycProofOfAddressScreenViewModel.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 19..
//

import Combine
import DesignKit
import Foundation

class KycProofOfAddressScreenViewModel: BasePhotoScreenViewModel {

    override init() {
        super.init()
        shape = .rectangle
        mode = .instructions(
            text: Strings.Localizable.kycProofOfAddressInstructions,
            animation: .init(kind: .hint, asset: .addressCard)
        )
    }

    override func onNext() {
        mode = .capture(info: Strings.Localizable.kycProofOfAddressCaptureInfo)
    }

    override func shouldFinish(when nextStep: FaceKom.Step) -> Bool {
        if case .proofOfAddress(let isRetry) = nextStep {
            if isRetry { state = .error(Strings.Localizable.kycPhotoError) }
            return isRetry
        }
        return true
    }
}
