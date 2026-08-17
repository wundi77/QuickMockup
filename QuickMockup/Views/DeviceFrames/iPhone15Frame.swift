//
//  iPhone15Frame.swift
//  QuickMockup
//

import SwiftUI

struct iPhone15Frame: View {
    let image: NSImage

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = width / (9.0 / 19.5)
            let cornerRadius = width * 0.14

            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.20), Color(white: 0.06)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )

                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius * 0.82, style: .continuous))
                    .padding(width * 0.028)

                // Dynamic Island
                Capsule()
                    .fill(Color.black)
                    .frame(width: width * 0.30, height: height * 0.014)
                    .offset(y: -height * 0.465)

                // Side button hints (subtle, decorative)
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color(white: 0.15))
                    .frame(width: 2, height: height * 0.05)
                    .offset(x: width * 0.505, y: -height * 0.20)
            }
        }
        .aspectRatio(9.0 / 19.5, contentMode: .fit)
    }
}
