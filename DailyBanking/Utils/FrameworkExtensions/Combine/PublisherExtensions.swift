//
//  Publishers+.swift
//  app-daily-banking-ios
//
//  Created by Szabó Zoltán on 2021. 10. 16..
//

import Combine
import Foundation

extension Publisher {
    func retry(times: Int = .max,
               delay: TimeInterval = 0,
               when condition: @escaping(Failure) -> Bool) -> AnyPublisher<Output, Failure> {
        map({ output -> Result<Output, Failure> in
            return .success(output)
        })
        .catch({ error -> AnyPublisher<Result<Output, Failure>, Failure> in
            if condition(error) {
                return Fail(error: error)
                    .delay(for: .seconds(delay), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            } else {
                return Just(.failure(error))
                    .setFailureType(to: Failure.self)
                    .eraseToAnyPublisher()
            }
        })
        .retry(times)
        .tryMap({ result -> Output in
            switch result {
            case .success(let output):
                return output
            case .failure(let error):
                throw error
            }
        })
        .mapError { $0 as! Failure } // swiftlint:disable:this force_cast
        .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Never {
    func sink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void)) -> AnyCancellable {
        self.sink { completion in
            receiveCompletion(completion)
        } receiveValue: { _ in }
    }

    func setOutputType<NewOutput>(to outputType: NewOutput.Type) -> Publishers.Map<Self, NewOutput> {
        map { _ -> NewOutput in }
    }

    func fireAndForget() {
        self.sink { _ in
            //
        }.store(in: &GlobalSink.instance.disposeBag)
    }
}

extension Publisher where Failure == Never {
    func assign<Root: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<Root, Output>,
        onWeak object: Root
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

extension Publisher {
    func handleSecondLevelAuthCancellation(_ onCancel: @escaping () -> Void) -> AnyPublisher<Output, Failure> {
        return self.handleEvents(receiveCompletion: { event in
            switch event {
            case .finished:
                break
            case .failure(let error):
                if case .cancelled = error as? SecondLevelAuthError {
                    onCancel()
                }
            }
        }).eraseToAnyPublisher()
    }
}

extension Publisher {
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }
}

class GlobalSink {
    static let instance = GlobalSink()
    var disposeBag = Set<AnyCancellable>()
}
