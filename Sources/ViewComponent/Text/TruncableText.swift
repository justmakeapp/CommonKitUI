//
//  TruncableText.swift
//
//
//  Created by Duy Truong on 10/23/2022.
//

import SwiftUI

public struct TruncableText<ButtonLabel: View>: View {
    @State private var intrinsicSize: CGSize
    @State private var truncatedSize: CGSize

    @Environment(\.lineLimit) private var lineLimit

    private let text: Text

    /// Label for the expand button.
    private let buttonLabel: () -> ButtonLabel

    /// Width of the gradient placed on the leading edge of the expand button.
    private let gradientWidth: Double = 60

    private var isTruncated: Bool {
        truncatedSize != intrinsicSize
    }

    public init(
        _ text: Text,
        intrinsicSize: CGSize = .zero,
        truncatedSize: CGSize = .zero,
        @ViewBuilder buttonLabel: @escaping () -> ButtonLabel
    ) {
        self.text = text
        self.intrinsicSize = intrinsicSize
        self.truncatedSize = truncatedSize
        self.buttonLabel = buttonLabel
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        ZStack(alignment: .bottomTrailing) {
            text
                .lineLimit(lineLimit)
                .readSize { size in
                    truncatedSize = size
                }
                .invertedMask {
                    if isTruncated {
                        expandButtonCutout
                    }
                }
                .background(
                    text
                        .fixedSize(horizontal: false, vertical: true)
                        .hidden()
                        .readSize { size in
                            intrinsicSize = size
                        }
                )

            if isTruncated {
                buttonLabel()
            }
        }
    }

    var expandButtonContents: some View {
        ZStack {
            // Use space for vertical alignment when the `expandButtonLabel` is shorter than the line height
            Text(" ")
                .hidden()

            buttonLabel()
        }
    }

    var expandButtonCutout: some View {
        Color.clear
            .overlay(alignment: .bottomTrailing) {
                expandButtonContents
                    .opacity(0)
                    .overlay(Color.black)
                    .overlay(alignment: .leading) {
                        LinearGradient(
                            gradient: Gradient(
                                stops: [
                                    .init(color: Color.clear, location: 0),
                                    .init(color: Color.black, location: 1),
                                ]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: gradientWidth)
                        .offset(x: -gradientWidth)
                        .flipsForRightToLeftLayoutDirection(true)
                    }
            }
    }
}

private extension View {
    func invertedMask(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> some View
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}
