//
//  UIImage+Crop.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 05. 03..
//

import UIKit

extension UIImage {
    func cropCenter() -> UIImage {
        crop(cutOff: 0.25)
    }

    func crop(cutOff: CGFloat) -> UIImage {
        guard let cgImage = cgImage else { return self }
        let cropHeight = CGFloat(cgImage.height) * cutOff
        let frame = CGRect(
            x: 0.0,
            y: cropHeight,
            width: CGFloat(cgImage.width),
            height: CGFloat(cgImage.height) - (cropHeight * 2)
        )

        guard let cropped = cgImage.cropping(to: frame) else { return self }
        return UIImage(cgImage: cropped)
    }
}
