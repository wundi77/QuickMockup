//
//  CanvasSettings.swift
//  QuickMockup
//
//  Central observable state for the mockup canvas. Every control in the
//  sidebar binds directly to a property here, and the preview + exporter
//  both read from this single source of truth.
//

import SwiftUI
import Combine

@MainActor
final class CanvasSettings: ObservableObject {

    // MARK: Source Image

    @Published var droppedImage: NSImage?
    @Published var isDropTargeted: Bool = false

    // MARK: Device Frame

    @Published var deviceFrame: DeviceFrame = .macBookPro

    // MARK: Background

    @Published var backgroundMode: BackgroundMode = .gradient
    @Published var solidColor: Color = Color(hex: "#1D1D1F")
    @Published var selectedGradient: GradientPreset = GradientPreset.presets[0]
    @Published var customGradientColors: [Color] = [Color(hex: "#FF9966"), Color(hex: "#FF5E62")]
    @Published var useCustomGradient: Bool = false

    var activeGradient: GradientPreset {
        guard useCustomGradient else { return selectedGradient }
        return GradientPreset(name: "Custom", colors: customGradientColors, isCustom: true)
    }

    // MARK: Adjustments

    @Published var canvasPadding: CGFloat = 96
    @Published var cornerRadius: CGFloat = 18
    @Published var shadowIntensity: CGFloat = 0.45
    @Published var shadowBlurRadius: CGFloat = 40

    // MARK: Export

    @Published var exportScale: ExportScale = .twoX
    @Published var isExporting: Bool = false
    @Published var lastExportError: String?

    enum ExportScale: Int, CaseIterable, Identifiable {
        case oneX = 1
        case twoX = 2
        case threeX = 3

        var id: Int { rawValue }
        var label: String { "\(rawValue)x" }
        var factor: CGFloat { CGFloat(rawValue) }
    }

    // MARK: Cross-view action bridge
    //
    // The preview view owns the `ImageRenderer` (it needs the actual rendered
    // SwiftUI view tree), while the menu commands and sidebar buttons live
    // elsewhere. These publishers let those callers "request" an action that
    // the preview view performs.

    let exportRequested = PassthroughSubject<Void, Never>()
    let copyRequested = PassthroughSubject<Void, Never>()
    let openImageRequested = PassthroughSubject<Void, Never>()

    func requestExport() {
        exportRequested.send()
    }

    func requestCopyToClipboard() {
        copyRequested.send()
    }

    func requestOpenImage() {
        openImageRequested.send()
    }

    func reset() {
        droppedImage = nil
    }
}
