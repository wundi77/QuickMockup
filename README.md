# QuickMockup

Native macOS (SwiftUI, macOS 14+ Sonoma) app for graphic designers: drag a
screenshot in, get a presentation-ready device mockup out.

## Layout

- **Left** — live preview of the composed mockup.
- **Right** — sidebar with control panels (device frame, background, adjustments, export).

## Project structure

```
QuickMockup/
├── App/
│   └── QuickMockupApp.swift        // App entry point, menu commands & shortcuts
├── Models/
│   ├── CanvasSettings.swift        // ObservableObject holding all canvas state
│   ├── DeviceFrame.swift           // Device frame enum + layout metadata
│   └── GradientPreset.swift        // Background mode + gradient presets
├── Views/
│   ├── ContentView.swift           // Top-level split layout, drop target, export bridge
│   ├── PreviewCanvasView.swift     // The composed mockup (also the exported view tree)
│   ├── DeviceFrames/               // MacBook Pro, iPhone 15, Safari window, Studio Display, Clean shadow
│   └── Sidebar/                    // Device frame / background / adjustments / export sections
└── Utilities/
    ├── ImageExporter.swift         // ImageRenderer-based PNG export + clipboard copy
    ├── ImageDropDelegate.swift     // Drag & drop handling
    └── NSImage+Extensions.swift    // File loading & PNG encoding helpers
```

## Features

- Device frame selector: MacBook Pro, iPhone 15, Minimal Safari Window, Studio Display, None/Clean Shadow.
- Background: solid color picker, gradient presets + fully custom gradients, transparent.
- Adjustments: canvas padding, corner radius, drop shadow intensity & blur — all live sliders.
- Drag & drop screenshots onto the canvas, or `⌘O` to open a file.
- `⌘S` — Export PNG at 1x/2x/3x.
- `⌘C` — Copy the rendered mockup straight to the clipboard.

## Requirements

- Xcode 15.2+
- macOS 14 (Sonoma) deployment target

## Opening the project

Open `QuickMockup.xcodeproj` in Xcode and run the `QuickMockup` scheme (⌘R).
