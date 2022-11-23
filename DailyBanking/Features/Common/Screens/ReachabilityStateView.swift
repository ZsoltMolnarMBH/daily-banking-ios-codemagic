//
//  NetworkStateView.swift
//  DailyBanking
//
//  Created by ALi on 2022. 05. 11..
//

import SwiftUI
import DesignKit

struct ReachabilityStateView: View {

    struct ReachabilityState {

        var color: Color
        var title: String
        var imageName: DesignKit.ImageName

        static let unreachable: Self = .init(
            color: .error.primary.background,
            title: Strings.Localizable.reachabilityStateViewUnreachableTitle,
            imageName: DesignKit.ImageName.signalNo
        )
        static let reachable: Self = .init(
            color: .success.primary.background,
            title: Strings.Localizable.reachabilityStateViewReachableTitle,
            imageName: DesignKit.ImageName.signal
        )
    }

    @StateObject private var keyboard = KeyboardFollower()
    @State var opacity: CGFloat = 1

    let state: ReachabilityState

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(state.color)
                .frame(height: 52)
            HStack(alignment: .center, spacing: .m) {
                Image(state.imageName)
                    .foregroundColor(.white)
                Text(state.title)
                    .textStyle(.body2)
                    .foregroundColor(.white)
                Spacer()
                Button {
                    Modals.reachabilityAlert.dismissAll()
                } label: {
                    Image(DesignKit.ImageName.close)
                        .foregroundColor(.white)
                }
            }
            .padding([.leading, .trailing], .l)
        }
        .onChange(of: keyboard.state) { state in
            if !state.isVisible {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        opacity = 1
                    }
                }
                opacity = 0
            }
        }
        .opacity(opacity)
    }
}

struct ReachabilityStateViewPreview: PreviewProvider {

    static var previews: some View {
        VStack {
            ReachabilityStateView(state: .unreachable)
                .padding(.m)
            ReachabilityStateView(state: .reachable)
                .padding(.m)
        }
    }
}

extension ReachabilityStateView.ReachabilityState {

    init(from isReachable: Bool) {
        self = isReachable ? .reachable : .unreachable
    }
}
