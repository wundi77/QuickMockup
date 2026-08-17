//
//  StudioDisplayFrame.swift
//  QuickMockup
//

import SwiftUI

struct StudioDisplayFrame: View {
    let image: NSImage

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = width / (16.0 / 9.0)

            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color(white: 0.90))

                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding(width * 0.018)
                }
                .frame(width: width, height: height * 0.90)

                // Stand neck
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.88), Color(white: 0.75)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .frame(width: width * 0.10, height: height * 0.07)

                // Stand base
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.90), Color(white: 0.72)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: width * 0.28, height: height * 0.025)
            }
            .frame(width: width, height: height)
        }
        .aspectRatio(16.0 / 9.0, contentMode: .fit)
    }
}
