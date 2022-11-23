//
//  ScaChallengeListComponent.swift
//  DailyBanking
//
//  Created by Adrián Juhász on 2022. 08. 09..
//

import SwiftUI
import Combine
import DesignKit

protocol ScaChallengeListComponentViewModelProtocol: ObservableObject {

    var scaChallengeList: [ScaChallengeVM] { get }

    func handle(event: ScaChallengeListComponentEvent)
}

enum ScaChallengeListComponentEvent {
    case paymentTransactionInfo
    case onAppear
    case onDisappear
}

struct ScaChallengeListComponent<ViewModel: ScaChallengeListComponentViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Group {
            if viewModel.scaChallengeList.count > 0 {
                HStack(spacing: 0) {
                    DesignTextFieldHeader(
                        title: Strings.Localizable.purchaseChallengeTitle,
                        infoButtonImageAction: {
                            viewModel.handle(event: .paymentTransactionInfo)
                        })
                    Spacer()
                }
                .padding(.leading, .m)
                .padding(.top, .m)
                VStack(spacing: 0) {
                    ForEach(viewModel.scaChallengeList, id: \.id) { scaChallenge in
                        ScaChallengeCard(item: scaChallenge)
                        .padding(.bottom, .m)
                        .padding(.horizontal, .m)
                    }
                }
            } else {
                HStack { }
            }
        }
        .onAppear {
            viewModel.handle(event: .onAppear)
        }
        .onDisappear {
            viewModel.handle(event: .onDisappear)
        }
    }
}

class MockScaChallengeListComponentViewModel: ScaChallengeListComponentViewModelProtocol {
    var scaChallengeList: [ScaChallengeVM] = []

    func handle(event: ScaChallengeListComponentEvent) {
    }
}
