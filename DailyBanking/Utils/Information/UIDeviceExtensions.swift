//
//  UIDeviceExtensions.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2021. 11. 26..
//

import UIKit

extension UIDevice {
    var deviceName: String {
       var systemInfo = utsname()
       uname(&systemInfo)
       let str = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
           return String(cString: ptr)
       }
       return str
    }
}
