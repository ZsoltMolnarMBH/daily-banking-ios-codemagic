//
//  ScaChallengeListComponentViewModel.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 08. 09..
//

import Resolver
import Combine
import DesignKit

enum ScaChallengeListComponentResult {
    case infoRequested
    case approved
    case declined
}

class ScaChallengeListComponentViewModel: ScreenViewModel<ScaChallengeListComponentResult>,
                                            ScaChallengeListComponentViewModelProtocol {

    @Injected private var scaChallenges: ReadOnly<[ScaChallenge]>
    @Injected private var scaChallengeAction: ScaChallengeAction

    @Published var scaChallengeList: [ScaChallengeVM] = []
    @Published private var trigger = Date()
    @Published private var isVisible = false
    private var disposeBag = Set<AnyCancellable>()

    override init() {
        super.init()
        let validChallenges = scaChallenges.publisher.compactMap { challenges in
            challenges.compactMap { $0.remainingSeconds >= 0 ? $0 : nil }
        }

        Publishers.CombineLatest(validChallenges, $trigger)
            .map { [weak self] challenges, _ in
                challenges.compactMap { item in
                    let minutes = Int(item.remainingSeconds / 60)
                    let seconds = Int(item.remainingSeconds.truncatingRemainder(dividingBy: 60))
                    return ScaChallengeVM(
                        id: item.id,
                        timeLeft: String(format: "%02d:%02d", minutes, seconds),
                        lastFourDigits: item.lastDigits,
                        amount: item.amount.localizedString,
                        merchantName: item.merchantName,
                        date: DateFormatter.userFacingWithTime.string(from: item.challengedAtDate),
                        approve: {
                            self?.approve(id: item.id)
                        }, decline: {
                            self?.decline(id: item.id)
                        }
                    )
                }
            }
            .assign(to: &$scaChallengeList)

        Publishers.CombineLatest(
            validChallenges.map { $0.count },
            $isVisible
        )
        .map { $0 > 0 && $1 }
        .removeDuplicates()
        .map { startTimer -> AnyPublisher<Date, Never> in
            if startTimer {
                return Timer.publish(every: 1.0, on: .main, in: .common)
                    .autoconnect()
                    .eraseToAnyPublisher()
            } else {
                return Just(Date())
                    .eraseToAnyPublisher()
            }
        }
        .switchToLatest()
        .assign(to: &$trigger)
    }

    func handle(event: ScaChallengeListComponentEvent) {
        switch event {
        case .paymentTransactionInfo:
            events.send(.infoRequested)
        case .onAppear:
            isVisible = true
            scaChallengeAction.getScaChallengeList().fireAndForget()
        case .onDisappear:
            isVisible = false
        }
    }

    private func approve(id: String) {
        scaChallengeAction.approveScaChallenge(id: id)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    self?.events.send(.approved)
                case .failure:
                    // Error handling will be implemented in a different story
                    break
                }
            }
            .store(in: &disposeBag)

    }

    private func decline(id: String) {
        scaChallengeAction.declineScaChallenge(id: id)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    self?.events.send(.declined)
                case .failure:
                    // Error handling will be implemented in a different story
                    break
                }
            }
            .store(in: &disposeBag)
    }
}

private extension ScaChallenge {
    var remainingSeconds: TimeInterval {
        Date().distance(to: challengedAtDate.addingTimeInterval(expiresAfter))
    }
}
