//
//  DeviceFrameSection.swift
//  QuickMockup
//

import SwiftUI

struct DeviceFrameSection: View {
    @ObservedObject var settings: CanvasSettings

    private let columns = [GridItem(.adaptive(minimum: 96), spacing: 10)]

    var body: some View {
        SidebarSection(title: "Device Frame") {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(DeviceFrame.allCases) { frame in
                    FrameOptionButton(
                        frame: frame,
                        isSelected: settings.deviceFrame == frame
                    ) {
                        settings.deviceFrame = frame
                    }
                }
            }
        }
    }
}

private struct FrameOptionButton: View {
    let frame: DeviceFrame
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: frame.symbolName)
                    .font(.system(size: 20))
                    .frame(height: 22)
                Text(frame.rawValue)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.16) : Color.gray.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(isSelected ? Color.accentColor : Color.clear, lineWidth: 1.5)
            )
            .foregroundColor(isSelected ? .accentColor : .primary)
        }
        .buttonStyle(.plain)
    }
}
