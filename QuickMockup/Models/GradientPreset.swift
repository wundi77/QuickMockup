//
//  GradientPreset.swift
//  QuickMockup
//

import SwiftUI

/// Which background mode is currently active for the canvas.
enum BackgroundMode: String, CaseIterable, Identifiable, Codable {
    case solid = "Solid Color"
    case gradient = "Gradient"
    case transparent = "Transparent"

    var id: String { rawValue }
}

/// A named linear gradient, either a built-in preset or a user-defined custom gradient.
struct GradientPreset: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var colors: [CodableColor]
    var startPoint: UnitPointSpec
    var endPoint: UnitPointSpec
    var isCustom: Bool

    init(id: UUID = UUID(), name: String, colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing, isCustom: Bool = false) {
        self.id = id
        self.name = name
        self.colors = colors.map(CodableColor.init)
        self.startPoint = UnitPointSpec(point: startPoint)
        self.endPoint = UnitPointSpec(point: endPoint)
        self.isCustom = isCustom
    }

    var gradient: LinearGradient {
        LinearGradient(
            colors: colors.map(\.color),
            startPoint: startPoint.unitPoint,
            endPoint: endPoint.unitPoint
        )
    }

    static let presets: [GradientPreset] = [
        GradientPreset(name: "Sunset", colors: [Color(hex: "#FF9966"), Color(hex: "#FF5E62")]),
        GradientPreset(name: "Ocean", colors: [Color(hex: "#2E3192"), Color(hex: "#1BFFFF")]),
        GradientPreset(name: "Aurora", colors: [Color(hex: "#00C9FF"), Color(hex: "#92FE9D")]),
        GradientPreset(name: "Candy", colors: [Color(hex: "#FC5C7D"), Color(hex: "#6A82FB")]),
        GradientPreset(name: "Midnight", colors: [Color(hex: "#0F2027"), Color(hex: "#203A43"), Color(hex: "#2C5364")]),
        GradientPreset(name: "Peach", colors: [Color(hex: "#FFDDE1"), Color(hex: "#EE9CA7")]),
        GradientPreset(name: "Mono Slate", colors: [Color(hex: "#3A3A3A"), Color(hex: "#0D0D0D")]),
        GradientPreset(name: "Lavender", colors: [Color(hex: "#834D9B"), Color(hex: "#D04ED6")])
    ]
}

/// `Color` is not `Codable` by default — wrap it so gradients can be persisted.
struct CodableColor: Codable, Equatable {
    var red: Double
    var green: Double
    var blue: Double
    var opacity: Double

    init(_ color: Color) {
        let resolved = color.resolve(in: EnvironmentValues())
        red = Double(resolved.red)
        green = Double(resolved.green)
        blue = Double(resolved.blue)
        opacity = Double(resolved.opacity)
    }

    var color: Color {
        Color(red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct UnitPointSpec: Codable, Equatable {
    var x: CGFloat
    var y: CGFloat

    init(point: UnitPoint) {
        x = point.x
        y = point.y
    }

    var unitPoint: UnitPoint { UnitPoint(x: x, y: y) }
}

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255.0
        let g = Double((value >> 8) & 0xFF) / 255.0
        let b = Double(value & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
