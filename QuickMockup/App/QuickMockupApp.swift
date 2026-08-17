//
//  QuickMockupApp.swift
//  QuickMockup
//

import SwiftUI

@main
struct QuickMockupApp: App {

    @StateObject private var canvasSettings = CanvasSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(canvasSettings)
                .frame(minWidth: 980, minHeight: 640)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        .commands {
            CommandGroup(replacing: .saveItem) {
                Button("Export PNG…") {
                    canvasSettings.requestExport()
                }
                .keyboardShortcut("s", modifiers: .command)
            }
            CommandGroup(after: .pasteboard) {
                Button("Copy Image to Clipboard") {
                    canvasSettings.requestCopyToClipboard()
                }
                .keyboardShortcut("c", modifiers: .command)
            }
            CommandGroup(replacing: .newItem) {
                Button("Open Image…") {
                    canvasSettings.requestOpenImage()
                }
                .keyboardShortcut("o", modifiers: .command)
            }
        }

        Settings {
            EmptyView()
        }
    }
}
