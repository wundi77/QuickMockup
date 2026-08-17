//
//  MacBookProFrame.swift
//  QuickMockup
//

import SwiftUI

struct MacBookProFrame: View {
    let image: NSImage
    var screenCornerRadius: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = width / (16.0 / 10.0)

            VStack(spacing: 0) {
                // Lid with screen
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color(white: 0.16), Color(white: 0.08)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )

                    // Screen bezel
                    RoundedRectangle(cornerRadius: screenCornerRadius)
                        .fill(Color.black)
                        .padding(width * 0.022)

                    // Screenshot content
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: max(screenCornerRadius - 4, 0)))
                        .padding(width * 0.028)

                    // Camera notch
                    Capsule()
                        .fill(Color.black)
                        .frame(width: width * 0.10, height: height * 0.028)
                        .offset(y: -height * 0.46)
                }
                .frame(width: width, height: height * 0.88)

                // Hinge + base
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: [Color(white: 0.78), Color(white: 0.55)],
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: width, height: height * 0.05)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(white: 0.25))
                        .frame(width: width * 0.18, height: height * 0.012)
                }

                // Base wedge
                Trapezoid()
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.82), Color(white: 0.62)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: width, height: height * 0.035)
            }
            .frame(width: width, height: height)
        }
        .aspectRatio(16.0 / 10.0, contentMode: .fit)
    }
}

/// A simple trapezoid used to suggest the tapered base of a laptop.
private struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let inset = rect.width * 0.04
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width - inset, y: rect.height))
        path.addLine(to: CGPoint(x: inset, y: rect.height))
        path.closeSubpath()
        return path
    }
}
