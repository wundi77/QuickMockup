//
//  PreviewCanvasView.swift
//  QuickMockup
//
//  The composed mockup: background + padded, framed screenshot + shadow.
//  This exact view tree is what gets rendered by ImageRenderer on export,
//  so it deliberately has no dependency on window chrome or geometry
//  outside of what's passed in.
//

import SwiftUI

struct PreviewCanvasView: View {

    @ObservedObject var settings: CanvasSettings
    let image: NSImage

    /// The natural aspect ratio of the *composed* mockup (background + content).
    private var canvasAspectRatio: CGFloat {
        settings.deviceFrame.contentAspectRatio ?? (image.size.width / max(image.size.height, 1))
    }

    var body: some View {
        ZStack {
            backgroundLayer

            framedContent
                .padding(settings.canvasPadding)
        }
        .aspectRatio(canvasAspectRatio, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: settings.cornerRadius, style: .continuous))
    }

    @ViewBuilder
    private var backgroundLayer: some View {
        switch settings.backgroundMode {
        case .solid:
            settings.solidColor
        case .gradient:
            settings.activeGradient.gradient
        case .transparent:
            Color.clear
        }
    }

    @ViewBuilder
    private var framedContent: some View {
        Group {
            switch settings.deviceFrame {
            case .macBookPro:
                MacBookProFrame(image: image)
            case .iPhone15:
                iPhone15Frame(image: image)
            case .safariWindow:
                SafariWindowFrame(image: image, cornerRadius: settings.cornerRadius)
            case .studioDisplay:
                StudioDisplayFrame(image: image)
            case .none:
                CleanShadowFrame(image: image)
                    .clipShape(RoundedRectangle(cornerRadius: settings.cornerRadius, style: .continuous))
            }
        }
        .shadow(
            color: Color.black.opacity(settings.shadowIntensity),
            radius: settings.shadowBlurRadius,
            x: 0,
            y: settings.shadowBlurRadius * 0.35
        )
    }
}

/// Placeholder shown on the canvas before an image has been dropped in.
struct EmptyCanvasPlaceholder: View {
    let isTargeted: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10, 8]))
            .foregroundColor(isTargeted ? Color.accentColor : Color.secondary.opacity(0.35))
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isTargeted ? Color.accentColor.opacity(0.08) : Color.clear)
            )
            .overlay(
                VStack(spacing: 14) {
                    Image(systemName: "square.and.arrow.down.on.square")
                        .font(.system(size: 42, weight: .light))
                        .foregroundColor(isTargeted ? .accentColor : .secondary)
                    Text("Drop a screenshot here")
                        .font(.title3.weight(.medium))
                        .foregroundColor(.primary)
                    Text("or press \u{2318}O to choose a file")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            )
            .animation(.easeOut(duration: 0.15), value: isTargeted)
    }
}
