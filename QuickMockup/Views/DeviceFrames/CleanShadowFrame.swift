//
//  CleanShadowFrame.swift
//  QuickMockup
//
//  "None" frame: the raw screenshot with just the canvas's own corner
//  radius and drop shadow applied — no device chrome.
//

import SwiftUI

struct CleanShadowFrame: View {
    let image: NSImage

    var body: some View {
        Image(nsImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}
