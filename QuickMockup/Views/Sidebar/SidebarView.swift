//
//  SidebarView.swift
//  QuickMockup
//
//  The right-hand control panel: a scrollable stack of collapsible sections,
//  each bound to `CanvasSettings`.
//

import SwiftUI

struct SidebarView: View {
    @ObservedObject var settings: CanvasSettings
    let hasImage: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                DeviceFrameSection(settings: settings)
                Divider()
                BackgroundSection(settings: settings)
                Divider()
                AdjustmentsSection(settings: settings)
                Divider()
                ExportSection(settings: settings, hasImage: hasImage)
            }
            .padding(18)
        }
        .background(.regularMaterial)
    }
}

/// A titled, consistently-styled container used by every sidebar panel.
struct SidebarSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            content
        }
    }
}
