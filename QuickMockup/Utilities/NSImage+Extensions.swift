//
//  NSImage+Extensions.swift
//  QuickMockup
//

import AppKit
import UniformTypeIdentifiers

extension NSImage {

    /// Loads an `NSImage` from a file URL, returning `nil` for non-image files.
    static func load(from url: URL) -> NSImage? {
        guard let type = UTType(filenameExtension: url.pathExtension),
              type.conforms(to: .image) else { return nil }
        return NSImage(contentsOf: url)
    }

    /// Encodes the image as PNG data.
    func pngData() -> Data? {
        guard let tiffData = tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: tiffData) else { return nil }
        return bitmap.representation(using: .png, properties: [:])
    }
}
