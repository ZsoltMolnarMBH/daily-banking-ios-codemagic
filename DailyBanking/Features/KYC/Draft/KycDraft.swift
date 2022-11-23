//
//  KycDraft.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 22..
//

import Foundation

struct KycDraft {
    var socketStatus: FaceKom.SocketStatus = .undetermined
    var stepProgress: FaceKomStepProgressData?
    var stepMessage: FaceKom.StepMessage?

    var fields = FaceKom.DataConfirmationFields(from: [])
}
