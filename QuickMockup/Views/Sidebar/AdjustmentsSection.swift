//
//  AdjustmentsSection.swift
//  QuickMockup
//

import SwiftUI

struct AdjustmentsSection: View {
    @ObservedObject var settings: CanvasSettings

    var body: some View {
        SidebarSection(title: "Adjustments") {
            LabeledSlider(
                title: "Canvas Padding",
                value: $settings.canvasPadding,
                range: 0...240,
                unit: "pt"
            )

            LabeledSlider(
                title: "Corner Radius",
                value: $settings.cornerRadius,
                range: 0...64,
                unit: "pt"
            )

            LabeledSlider(
                title: "Shadow Intensity",
                value: $settings.shadowIntensity,
                range: 0...1,
                unit: "",
                decimals: 2
            )

            LabeledSlider(
                title: "Shadow Blur",
                value: $settings.shadowBlurRadius,
                range: 0...120,
                unit: "pt"
            )
        }
    }
}

private struct LabeledSlider: View {
    let title: String
    @Binding var value: CGFloat
    let range: ClosedRange<CGFloat>
    let unit: String
    var decimals: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.subheadline)
                Spacer()
                Text(formattedValue)
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
            }
            Slider(value: $value, in: range)
        }
    }

    private var formattedValue: String {
        let format = "%.\(decimals)f%@"
        return String(format: format, value, unit)
    }
}
