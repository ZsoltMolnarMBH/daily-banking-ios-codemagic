//
//  DesignSlider.swift
//  DesignKit
//
//  Created by Zsolt Molnár on 2022. 11. 22..
//

import SwiftUI

public struct DesignSlider: View {
    private let value: Binding<Float>
    private let range: ClosedRange<Float>

    public init(value: Binding<Float>, range: ClosedRange<Float> = 0...1) {
        self.value = value
        self.range = range
    }

    public var body: some View {
        SwiftUISlider(value: value,
                      min: range.lowerBound,
                      max: range.upperBound,
                      thumbColor: UIColor(Color.action.primary.default.background),
                      minTrackColor: UIColor(Color.action.primary.default.background),
                      maxTrackColor: UIColor(Color.element.tertiary))
    }
}

struct DesignSlider_Previews: PreviewProvider {
    static var previews: some View {
        DesignSlider(value: .constant(5), range: 0...10)
    }
}

struct SwiftUISlider: UIViewRepresentable {
    final class Coordinator: NSObject {
        var value: Binding<Float>

        init(value: Binding<Float>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Float(sender.value)
        }
    }

    @Binding var value: Float
    var min: Float
    var max: Float
    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = min
        slider.maximumValue = max
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.value = Float(value)

        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )

        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(self.value)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }
}
