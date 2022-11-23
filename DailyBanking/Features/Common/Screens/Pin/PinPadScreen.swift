//
//  PinPadScreen.swift
//  app-daily-banking-ios
//
//  Created by Molnár Zsolt on 2021. 11. 05..
//

import SwiftUI
import DesignKit
import Combine
import LocalAuthentication
import Resolver

enum PinPadScreenInput {
    case biometricAuthRequested
    case hintRequested
}

enum PinState: Equatable {
    case editing
    case error
    case success
    case disabled
}

protocol PinPadScreenViewModelProtocol: ObservableObject {
    var title: String { get }
    var pin: PinCode { get set }
    var pinError: AttributedString? { get }
    var maxDigitCount: Int { get }
    var pinState: PinState { get }
    var supportedBiometryType: LABiometryType { get }
    var hint: String? { get }
    var isLoading: Bool { get }
    var alert: AlertModel? { get set }
    var bottomAlert: AnyPublisher<AlertModel, Never> { get }
    var analyticsName: String { get }

    func handle(input: PinPadScreenInput)
}

struct PinPadScreen<ViewModel: PinPadScreenViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State var attempts: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.title)
                .textStyle(.headings3.thin)
                .multilineTextAlignment(.center)
                .frame(minHeight: 64)
                .animation(.fast, value: viewModel.title)
                .padding([.leading, .trailing, .bottom], .xl)
                .padding(.top, .xxxl)
                .transition(.slideLeft)
                .id(viewModel.title)

            PinDisplay(pin: $viewModel.pin,
                       state: viewModel.pinState,
                       maxDigitCount: viewModel.maxDigitCount
            )
            .modifier(Shake(animatableData: CGFloat(attempts)))

            if let error = viewModel.pinError {
                Text(error)
                    .textStyle(.body2)
                    .foregroundColor(.error.highlight)
                    .multilineTextAlignment(.center)
                    .padding([.top, .bottom], .m)
                    .padding([.leading, .trailing], .xxxl)
            }

            Spacer()
            PinKeyboard(pin: $viewModel.pin,
                        maxDigitCount: viewModel.maxDigitCount,
                        supportedBiometryType: viewModel.supportedBiometryType) {
                viewModel.handle(input: .biometricAuthRequested)
            }
            .disabled(viewModel.pinState != .editing)

            if let hint = viewModel.hint {
                DesignButton(style: .tertiary,
                             size: .large,
                             title: hint) {
                    viewModel.handle(input: .hintRequested)
                }
            }
        }
        .background(Color.background.secondary)
        .animation(.fast, value: viewModel.pinState)
        .onChange(of: viewModel.pinState) { newValue in
            let feedback = UINotificationFeedbackGenerator()
            switch newValue {
            case .error:
                withAnimation(.fast) {
                    attempts += 1
                }
                feedback.notificationOccurred(.error)
            case .success:
                feedback.notificationOccurred(.success)
            default: break
            }
        }
        .alert(alertModel: $viewModel.alert)
        .designAlert(viewModel.bottomAlert)
        .fullScreenProgress(by: viewModel.isLoading, name: "pinpadscreen")
        .analyticsScreenView(viewModel.analyticsName)
    }
}

struct PinDisplay: View {
    @Binding var pin: PinCode
    let state: PinState
    let maxDigitCount: Int

    struct Digit: Identifiable {
        var id: Int {
            index
        }

        let index: Int
        let isFilled: Bool
    }

    var digits: [Digit] {
        let filledCount = pin.count
        let emptyCount = maxDigitCount - filledCount
        let filled: [Bool] = .init(repeating: true, count: filledCount)
        let empty: [Bool] = .init(repeating: false, count: emptyCount)
        let digits = (filled + empty)
            .enumerated()
            .map { Digit(index: $0, isFilled: $1) }
        return digits
    }

    var body: some View {
        HStack(alignment: .center, spacing: .xl) {
            ForEach(digits) { digit in
                Circle()
                    .fill(color(for: digit))
                    .frame(width: 20, height: 20)
                    .animation(.fast, value: digit.isFilled)
            }
        }
    }

    func color(for digit: Digit) -> Color {
        if digit.isFilled {
            switch state {
            case .editing, .disabled:
                return .highlight.tertiary
            case .error:
                return .error.highlight
            case .success:
                return .success.highlight
            }
        } else {
            return .background.primaryDisabled
        }
    }
}

struct PinKeyboard: View {
    @Binding var pin: PinCode
    let maxDigitCount: Int
    let supportedBiometryType: LABiometryType
    let biometricAuthHandler: (() -> Void)?

    @ViewBuilder
    var body: some View {
        VStack(spacing: .m) {
            HStack(spacing: 40) {
                make(number: 1)
                make(number: 2)
                make(number: 3)
            }
            HStack(spacing: 40) {
                make(number: 4)
                make(number: 5)
                make(number: 6)
            }
            HStack(spacing: 40) {
                make(number: 7)
                make(number: 8)
                make(number: 9)
            }
            HStack(spacing: 40) {
                makeEmpty()
                make(number: 0)
                if pin.count > 0 {
                    makeBackspace()
                } else {
                    switch supportedBiometryType {
                    case .touchID:
                        makeBiometric(with: .fingerprint)
                    case .faceID:
                        makeBiometric(with: .faceId)
                    default:
                        makeEmpty()
                    }
                }
            }
        }
    }

    private func make(number: Int) -> some View {
        DesignButton(style: .secondary,
                     width: .fluid,
                     size: .giant,
                     title: "\(number)") {
            var values = pin
            guard values.count < maxDigitCount else { return }
            values.append(number)
            pin = values
        }
        .disableAnalytics()
        .hapticOnTouch()
    }

    private func makeBackspace() -> some View {
        DesignButton(style: .secondary,
                     width: .fluid,
                     size: .giant,
                     imageName: DesignKit.ImageName.keyboardDelete) {
            var values = pin
            guard values.count > 0 else { return }
            values = values.dropLast()
            pin = values
        }
        .disableAnalytics()
        .hapticOnTouch()
    }

    private func makeBiometric(with imageName: DesignKit.ImageName) -> some View {
        return DesignButton(style: .secondary,
                            width: .fluid,
                            size: .giant,
                            imageName: imageName) {
            biometricAuthHandler?()
        }
        .disableAnalytics()
        .hapticOnTouch()
    }

    private func makeEmpty() -> some View {
        let size = DesignButton.Size.giant.diameter
        return Circle()
            .fill(.clear)
            .frame(width: size, height: size)
    }
}

struct PinPadScreen_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                PinPadScreen<MockPinPadScreenViewModel>(viewModel: MockPinPadScreenViewModel())
                    .navigationTitle("Welcome")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .previewDevice("iPhone SE (2nd generation)")

            NavigationView {
                PinPadScreen<MockPinPadScreenViewModel>(viewModel: MockPinPadScreenViewModel())
                    .navigationTitle("Welcome")
                    .navigationBarTitleDisplayMode(.inline)

            }
            .previewDevice("iPhone 12 Pro Max")
        }
    }
}

class MockPinPadScreenViewModel: PinPadScreenViewModelProtocol {
    private var disposeBag = Set<AnyCancellable>()

    var bottomAlert: AnyPublisher<AlertModel, Never> = PassthroughSubject<AlertModel, Never>().eraseToAnyPublisher()
    var analyticsName: String = ""
    let isLoading: Bool = true
    let maxDigitCount: Int = 6
    var supportedBiometryType: LABiometryType = .none
    var title: String {
        "Adjon meg egy \(maxDigitCount) jegyből álló számot!"
    }

    @Published var pin: PinCode = []
    @Published var pinError: AttributedString?
    @Published var pinState: PinState = .editing

    init() {
        $pin
            .map { pin -> PinState in
                if pin.count == 6 {
                    return self.evaluatePin(pin: pin)
                } else {
                    return .editing
                }
            }
            .sink {
                self.pinState = $0
            }
            .store(in: &disposeBag)
    }

    private func evaluatePin(pin: PinCode) -> PinState {
//        if Bool.random() {
//            return .success
//        } else {
//
//        }
        pinError = "Nem megfelelő mPIN kód. Kérjük, különböző számokból álló kódot adjon meg!"
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.pinState = .editing
//        }
        return .error
    }

    var hint: String? {
        "Milyen a megfelelő mPIN kód?"
    }

    var alert: AlertModel?

    func handle(input: PinPadScreenInput) {
    }
}
