//
//  PageIndicator.swift
//  CommonKitUI
//
//  Created by Long Vu on 14/4/25.
//

import SwiftUI

public struct PageIndicator: View {
    let numPages: Int
    @Binding var selectedIndex: Int

    private var config = Config()

    public init(numPages: Int, currentPage: Binding<Int>) {
        self.numPages = numPages
        _selectedIndex = currentPage
    }

    public var body: some View {
        HStack(alignment: .center, spacing: config.spacing) {
            ForEach(0 ..< numPages, id: \.self) {
                DotIndicator(
                    pageIndex: $0,
                    slectedPage: self.$selectedIndex
                ).frame(
                    width: config.diameter,
                    height: config.diameter
                )
            }
        }
        .padding(6)
        .cornerRadius(10)
    }
}

public extension PageIndicator {
    struct Config {
        var diameter: CGFloat = 8
        var spacing: CGFloat = 3
    }

    func diameter(_ diameter: CGFloat) -> Self {
        transform { $0.config.diameter = diameter }
    }

    func spacing(_ spacing: CGFloat) -> Self {
        transform { $0.config.spacing = spacing }
    }
}

private struct DotIndicator: View {
    let minScale: CGFloat = 1
    let maxScale: CGFloat = 1.1
    let minOpacity: Double = 0.6

    let pageIndex: Int
    @Binding var slectedPage: Int

    private var isSelected: Bool {
        return slectedPage == pageIndex
    }

    var body: some View {
        Circle()
            .scaleEffect(
                isSelected
                    ? maxScale
                    : minScale
            )
            .animation(.linear, value: slectedPage)
            .if(isSelected) {
                $0.foregroundStyle(.tint)
            } else: {
                $0.foregroundStyle(.separator.opacity(minOpacity))
            }
            .onTapGesture {
                self.slectedPage = self.pageIndex
            }
    }
}
