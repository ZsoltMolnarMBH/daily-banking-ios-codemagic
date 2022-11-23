//
//  ResultScreen.swift
//  DailyBanking
//
//  Created by Zsolt Molnár on 2022. 01. 28..
//

import SwiftUI
import DesignKit

struct ResultModel {
    enum Icon {
        case success
        case failure
        case image(ImageName)
        case animation(ThemeAwareAnimation)
    }

    struct Action {
        let title: String
        let action: (() -> Void)
    }

    let icon: Icon
    let title: String
    let subtitles: [String]
    let primaryAction: Action?
    let secondaryAction: Action?
    let tertiaryAction: Action?
    let screenView: String?

    init(icon: ResultModel.Icon = .success,
         title: String,
         subtitle: String,
         primaryAction: Action? = nil,
         secondaryAction: Action? = nil,
         tertiaryAction: Action? = nil,
         analyticsScreenView: String? = nil) {
        self.init(icon: icon,
                  title: title,
                  subtitles: [subtitle],
                  primaryAction: primaryAction,
                  secondaryAction: secondaryAction,
                  tertiaryAction: tertiaryAction,
                  analyticsScreenView: analyticsScreenView)
    }

    init(icon: ResultModel.Icon = .success,
         title: String,
         subtitles: [String] = [],
         primaryAction: Action? = nil,
         secondaryAction: Action? = nil,
         tertiaryAction: Action? = nil,
         analyticsScreenView: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitles = subtitles
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.tertiaryAction = tertiaryAction
        self.screenView = analyticsScreenView
    }
}

extension View {
    @ViewBuilder
    func fullscreenResult(model: ResultModel?, shouldHideNavbar: Bool = true) -> some View {
        Group {
            if let model = model {
                ResultScreen(model: model)
                    .navigationBarHidden(shouldHideNavbar)
            } else {
                self
            }
        }
        .animation(.fast, value: model == nil)
    }
}

struct ResultScreen: View {
    @Environment(\.keyWindowSafeAreaInsets) private var safeArea
    var model: ResultModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            VStack(alignment: .center, spacing: .xl) {
                HStack(spacing: 0) {
                    Spacer()
                    switch model.icon {
                    case .success:
                        LottieView(animation: .success, loopMode: .playOnce, schedule: .delayed(.transition))
                            .frame(width: 72, height: 72)
                    case .failure:
                        LottieView(animation: .alert, loopMode: .playOnce, schedule: .delayed(.transition))
                            .frame(width: 72, height: 72)
                    case .image(let imageName):
                        Image(imageName)
                            .resizable()
                            .frame(width: 72, height: 72)
                    case .animation(let animation):
                        LottieView(animation: animation, loopMode: .playOnce, schedule: .delayed(.transition))
                            .frame(width: 72, height: 72)
                    }
                    Spacer()
                }
                VStack(spacing: .xs) {
                    Text(model.title)
                        .multilineTextAlignment(.center)
                        .textStyle(.headings3.thin)
                        .foregroundColor(.text.primary)
                    ForEach(Array(model.subtitles.enumerated()), id: \.offset) { subtitle in
                        Text(subtitle.element)
                            .multilineTextAlignment(.center)
                            .textStyle(.body1)
                            .foregroundColor(.text.secondary)
                    }
                }
                if let tertiaryAction = model.tertiaryAction {
                    DesignButton(
                        style: .tertiary,
                        width: .fluid,
                        size: .large,
                        title: tertiaryAction.title) { tertiaryAction.action() }
                }
            }
            .padding(.horizontal, .m)
            Spacer()
            if let primaryAction = model.primaryAction {
                DesignButton(
                    style: .primary,
                    title: primaryAction.title,
                    action: { model.primaryAction?.action() }
                )
            }
            if let secondaryAction = model.secondaryAction {
                DesignButton(
                    style: .secondary,
                    title: secondaryAction.title,
                    action: { secondaryAction.action() }
                ).padding(.top, .m)
            }
        }
        .if(model.screenView != nil, transform: {
            $0.analyticsScreenView(model.screenView ?? "")
        })
        .padding(.horizontal, .m)
        .padding(.bottom, bottomPadding)
        .background(Color.background.primary)
    }

    var bottomPadding: CGFloat {
        safeArea.bottom > 0 ? 0 : .m
    }
}

struct InfoScreenPreview: PreviewProvider {
    static var previews: some View {
        ResultScreen(model: .mock.failure)
            .preferredColorScheme(.light)
    }
}

private extension ResultModel {
    static let mock = Mock()
    struct Mock {
        let success = ResultModel(icon: .success,
                                  title: "Az összeg már úton van.",
                                  subtitle: "Várhatóan pár másodperc múlva megérkezik a kedvezményezetthez.",
                                  primaryAction: .init(title: "Happy", action: {}))

        let failure = ResultModel(icon: .failure,
                                  title: "Az átutalás visszautasításra került.",
                                  subtitles: ["Kérjük, ismételje meg később!", "Nagyon nagy hiba történt"],
                                  primaryAction: .init(title: "Sad", action: {}),
                                  secondaryAction: .init(title: "Really sad", action: {}),
                                  tertiaryAction: .init(title: "Please help!", action: {}))
    }
}
