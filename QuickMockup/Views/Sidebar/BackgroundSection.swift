//
//  BackgroundSection.swift
//  QuickMockup
//

import SwiftUI

struct BackgroundSection: View {
    @ObservedObject var settings: CanvasSettings

    private let gradientColumns = [GridItem(.adaptive(minimum: 44), spacing: 8)]

    var body: some View {
        SidebarSection(title: "Background") {
            Picker("", selection: $settings.backgroundMode) {
                ForEach(BackgroundMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            switch settings.backgroundMode {
            case .solid:
                solidControls
            case .gradient:
                gradientControls
            case .transparent:
                Text("Transparent canvas — exported PNG will keep alpha.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
    }

    private var solidControls: some View {
        ColorPicker("Canvas Color", selection: $settings.solidColor, supportsOpacity: true)
            .padding(.top, 4)
    }

    private var gradientControls: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle("Use Custom Gradient", isOn: $settings.useCustomGradient)
                .toggleStyle(.switch)
                .padding(.top, 2)

            if settings.useCustomGradient {
                customGradientEditor
            } else {
                presetGrid
            }
        }
    }

    private var presetGrid: some View {
        LazyVGrid(columns: gradientColumns, spacing: 8) {
            ForEach(GradientPreset.presets) { preset in
                GradientSwatch(
                    preset: preset,
                    isSelected: !settings.useCustomGradient && settings.selectedGradient.id == preset.id
                ) {
                    settings.selectedGradient = preset
                }
                .help(preset.name)
            }
        }
    }

    private var customGradientEditor: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(settings.customGradientColors.indices, id: \.self) { index in
                HStack {
                    ColorPicker(
                        "Stop \(index + 1)",
                        selection: Binding(
                            get: { settings.customGradientColors[index] },
                            set: { settings.customGradientColors[index] = $0 }
                        ),
                        supportsOpacity: true
                    )

                    if settings.customGradientColors.count > 2 {
                        Button {
                            settings.customGradientColors.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if settings.customGradientColors.count < 5 {
                Button {
                    settings.customGradientColors.append(.white)
                } label: {
                    Label("Add Color Stop", systemImage: "plus.circle")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            }

            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: settings.customGradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 32)
        }
    }
}

private struct GradientSwatch: View {
    let preset: GradientPreset
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(preset.gradient)
                .frame(height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(isSelected ? Color.accentColor : Color.black.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}
