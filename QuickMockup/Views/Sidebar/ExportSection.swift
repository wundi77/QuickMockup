//
//  ExportSection.swift
//  QuickMockup
//

import SwiftUI

struct ExportSection: View {
    @ObservedObject var settings: CanvasSettings
    let hasImage: Bool

    var body: some View {
        SidebarSection(title: "Export") {
            Picker("Scale", selection: $settings.exportScale) {
                ForEach(CanvasSettings.ExportScale.allCases) { scale in
                    Text(scale.label).tag(scale)
                }
            }
            .pickerStyle(.segmented)

            VStack(spacing: 8) {
                Button {
                    settings.requestCopyToClipboard()
                } label: {
                    Label("Copy Image to Clipboard", systemImage: "doc.on.clipboard")
                        .frame(maxWidth: .infinity)
                }
                .keyboardShortcut("c", modifiers: .command)

                Button {
                    settings.requestExport()
                } label: {
                    Label("Export PNG…", systemImage: "square.and.arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .keyboardShortcut("s", modifiers: .command)
                .buttonStyle(.borderedProminent)
            }
            .disabled(!hasImage)
            .padding(.top, 2)

            if let error = settings.lastExportError {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
