//
//  SafariWindowFrame.swift
//  QuickMockup
//

import SwiftUI

struct SafariWindowFrame: View {
    let image: NSImage
    var cornerRadius: CGFloat = 12

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            ZStack {
                LinearGradient(
                    colors: [Color(white: 0.94), Color(white: 0.88)],
                    startPoint: .top, endPoint: .bottom
                )

                HStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Circle().fill(Color(hex: "#FF5F57")).frame(width: 11, height: 11)
                        Circle().fill(Color(hex: "#FEBC2E")).frame(width: 11, height: 11)
                        Circle().fill(Color(hex: "#28C840")).frame(width: 11, height: 11)
                    }

                    Spacer()

                    Capsule()
                        .fill(Color.white.opacity(0.9))
                        .overlay(
                            Capsule().strokeBorder(Color.black.opacity(0.08))
                        )
                        .frame(width: 220, height: 20)
                        .overlay(
                            HStack(spacing: 4) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 9))
                                Text("your-site.com")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(.black.opacity(0.55))
                        )

                    Spacer()

                    Color.clear.frame(width: 44)
                }
                .padding(.horizontal, 14)
            }
            .frame(height: 36)

            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(Color.black.opacity(0.12), lineWidth: 1)
        )
    }
}
