//
//  ImageExporter.swift
//  QuickMockup
//
//  Renders an arbitrary SwiftUI view tree to a bitmap using `ImageRenderer`
//  and either copies it to the pasteboard or writes it to disk as PNG.
//

import SwiftUI
import AppKit

@MainActor
enum ImageExporter {

    /// Renders `view` at the given scale factor and returns the resulting `NSImage`.
    static func render<Content: View>(_ view: Content, scale: CGFloat) -> NSImage? {
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        renderer.isOpaque = false
        return renderer.nsImage
    }

    /// Copies the rendered view to the system pasteboard as PNG image data.
    @discardableResult
    static func copyToClipboard<Content: View>(_ view: Content, scale: CGFloat) -> Bool {
        guard let image = render(view, scale: scale),
              let data = image.pngData() else { return false }

        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        return pasteboard.setData(data, forType: .png)
    }

    /// Presents a save panel and writes the rendered view to disk as PNG.
    static func exportPNG<Content: View>(_ view: Content, scale: CGFloat, suggestedName: String = "QuickMockup") {
        guard let image = render(view, scale: scale), let data = image.pngData() else { return }

        let panel = NSSavePanel()
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "\(suggestedName)@\(Int(scale))x.png"
        panel.canCreateDirectories = true
        panel.title = "Export Mockup"

        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            do {
                try data.write(to: url)
            } catch {
                NSSound.beep()
            }
        }
    }
}
