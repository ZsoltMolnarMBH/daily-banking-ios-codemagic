//
//  CameraPermissionHandler.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 04. 06..
//

import AVFoundation
import Combine

class CameraPermissionHandler {
    func checkPermission() -> AnyPublisher<Bool, Never> {
        Deferred {
            Future { promise in
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized:
                    promise(.success(true))

                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        promise(.success(granted))
                    }

                default:
                    promise(.success(false))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
