//
//  DeviceInformation.swift
//  DailyBanking
//
//  Created by Molnár Zsolt on 2021. 12. 09..
//

import Foundation
import UIKit

struct DeviceInformation {
    /// Device name
    let name: String
    /// Device model eg. iPhone iPhone14,5
    let model: String
    /// Device id
    let id: String
}

class DeviceInformationProvider {
    let information: DeviceInformation = {
        let device = UIDevice.current.model
        return .init(
            name: UIDevice.current.name,
            model: UIDevice.current.deviceName,
            id: UIDevice.current.identifierForVendor?.uuidString ?? "")
    }()
}
