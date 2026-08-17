//
//  ContentView.swift
//  QuickMockup
//
//  Top-level layout: live preview on the left, control sidebar on the
//  right. Owns the drop target and wires the export/copy/open action
//  publishers from `CanvasSettings` to the actual `ImageRenderer` calls,
//  since only this view has access to the fully composed preview tree.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject private var settings: CanvasSettings

    var body: some View {
        HSplitView {
            previewArea
                .frame(minWidth: 480, maxWidth: .infinity, maxHeight: .infinity)

            SidebarView(settings: settings, hasImage: settings.droppedImage != nil)
                .frame(minWidth: 300, idealWidth: 320, maxWidth: 380, maxHeight: .infinity)
        }
        .onReceive(settings.exportRequested) { performExport() }
        .onReceive(settings.copyRequested) { performCopy() }
        .onReceive(settings.openImageRequested) { presentOpenPanel() }
    }

    private var previewArea: some View {
        ZStack {
            Color(nsColor: .underPageBackgroundColor)
                .ignoresSafeArea()

            GeometryReader { geo in
                ScrollView([.horizontal, .vertical]) {
                    Group {
                        if let image = settings.droppedImage {
                            PreviewCanvasView(settings: settings, image: image)
                                .frame(
                                    width: min(geo.size.width - 64, 900),
                                    height: min(geo.size.width - 64, 900) / previewAspectRatio(for: image)
                                )
                        } else {
                            EmptyCanvasPlaceholder(isTargeted: settings.isDropTargeted)
                                .frame(width: min(geo.size.width - 64, 640), height: min(geo.size.height - 64, 420))
                        }
                    }
                    .frame(minWidth: geo.size.width, minHeight: geo.size.height, alignment: .center)
                }
            }
            .onDrop(of: [.image, .fileURL], delegate: ImageDropDelegate(settings: settings))
        }
    }

    private func previewAspectRatio(for image: NSImage) -> CGFloat {
        settings.deviceFrame.contentAspectRatio ?? (image.size.width / max(image.size.height, 1))
    }

    // MARK: Export bridge

    private func performExport() {
        guard let image = settings.droppedImage else { return }
        let view = PreviewCanvasView(settings: settings, image: image)
        ImageExporter.exportPNG(view, scale: settings.exportScale.factor)
    }

    private func performCopy() {
        guard let image = settings.droppedImage else { return }
        let view = PreviewCanvasView(settings: settings, image: image)
        let succeeded = ImageExporter.copyToClipboard(view, scale: settings.exportScale.factor)
        settings.lastExportError = succeeded ? nil : "Could not copy image to clipboard."
    }

    private func presentOpenPanel() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.image]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.title = "Choose a Screenshot"

        panel.begin { response in
            guard response == .OK, let url = panel.url, let image = NSImage.load(from: url) else { return }
            settings.droppedImage = image
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CanvasSettings())
        .frame(width: 1100, height: 700)
}
