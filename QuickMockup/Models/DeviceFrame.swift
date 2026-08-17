//
//  DeviceFrame.swift
//  QuickMockup
//

import Foundation

/// The device chrome rendered around the dropped screenshot.
enum DeviceFrame: String, CaseIterable, Identifiable, Codable {
    case macBookPro = "MacBook Pro"
    case iPhone15 = "iPhone 15"
    case safariWindow = "Minimal Safari Window"
    case studioDisplay = "Studio Display"
    case none = "None / Clean Shadow"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .macBookPro: return "laptopcomputer"
        case .iPhone15: return "iphone"
        case .safariWindow: return "macwindow"
        case .studioDisplay: return "display"
        case .none: return "square.dashed"
        }
    }

    /// The aspect ratio the image content area is fit into for this frame, if any.
    /// `nil` means the frame adapts to the image's own aspect ratio.
    var contentAspectRatio: CGFloat? {
        switch self {
        case .macBookPro: return 16.0 / 10.0
        case .iPhone15: return 9.0 / 19.5
        case .safariWindow: return nil
        case .studioDisplay: return 16.0 / 9.0
        case .none: return nil
        }
    }

    /// Extra chrome padding/height (in points, at design scale) the frame needs
    /// around the content area, used to reserve space when the frame is composed.
    var chromeInsets: EdgeInsetsSpec {
        switch self {
        case .macBookPro: return EdgeInsetsSpec(top: 18, leading: 18, bottom: 70, trailing: 18)
        case .iPhone15: return EdgeInsetsSpec(top: 34, leading: 12, bottom: 34, trailing: 12)
        case .safariWindow: return EdgeInsetsSpec(top: 36, leading: 0, bottom: 0, trailing: 0)
        case .studioDisplay: return EdgeInsetsSpec(top: 22, leading: 22, bottom: 90, trailing: 22)
        case .none: return EdgeInsetsSpec(top: 0, leading: 0, bottom: 0, trailing: 0)
        }
    }
}

struct EdgeInsetsSpec {
    var top: CGFloat
    var leading: CGFloat
    var bottom: CGFloat
    var trailing: CGFloat
}
