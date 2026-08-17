//
//  ImageDropDelegate.swift
//  QuickMockup
//
//  Handles drag & drop of image files (and images copied from other apps)
//  onto the canvas.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImageDropDelegate: DropDelegate {

    @ObservedObject var settings: CanvasSettings

    func validateDrop(info: DropInfo) -> Bool {
        info.hasItemsConforming(to: [.image, .fileURL])
    }

    func dropEntered(info: DropInfo) {
        settings.isDropTargeted = true
    }

    func dropExited(info: DropInfo) {
        settings.isDropTargeted = false
    }

    func performDrop(info: DropInfo) -> Bool {
        settings.isDropTargeted = false

        // Prefer a file URL so we can decode the original file directly.
        if let fileProvider = info.itemProviders(for: [.fileURL]).first {
            fileProvider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                guard let data = item as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil),
                      let image = NSImage.load(from: url) else { return }
                Task { @MainActor in
                    settings.droppedImage = image
                }
            }
            return true
        }

        // Fall back to raw image data (e.g. copy/paste from another app).
        if let imageProvider = info.itemProviders(for: [.image]).first {
            imageProvider.loadObject(ofClass: NSImage.self) { object, _ in
                guard let image = object as? NSImage else { return }
                Task { @MainActor in
                    settings.droppedImage = image
                }
            }
            return true
        }

        return false
    }
}
