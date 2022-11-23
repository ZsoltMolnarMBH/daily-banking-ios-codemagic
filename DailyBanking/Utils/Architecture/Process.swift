//
//  Process.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 03. 26..
//

import Foundation

enum Process<Success, Failure> where Failure: Error {
    case loading
    case success(Success)
    case failure(Failure)
}

extension Process {
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    @inlinable public func get() -> Success? {
        if case .success(let success) = self {
            return success
        }
        return nil
    }

    var error: Failure? {
        if case .failure(let failure) = self {
            return failure
        }
        return nil
    }
}
