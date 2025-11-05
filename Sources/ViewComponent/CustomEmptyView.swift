//
//  CustomEmptyView.swift
//
//
//  Created by Long Vu on 10/12/2023.
//

import SwiftUI
import SwiftUIExtension

public struct CustomEmptyView: View {
    private let title: String
    private let systemImage: String
    private let description: Text?

    private var config = Config()

    public init(_ title: String, systemImage: String = "tray", description: Text? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }

    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .symbolRenderingMode(config.symbolRenderingMode)
                .font(.largeTitle.weight(.semibold))
                .imageScale(.large)

            VStack {
                Text(title)
                    .font(.title3.weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(config.titleColor)

                description?
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

public extension CustomEmptyView {
    struct Config {
        var symbolRenderingMode: SymbolRenderingMode?
        var titleColor: Color = .secondary
    }

    func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> Self {
        transform { $0.config.symbolRenderingMode = mode }
    }

    func titleColor(_ color: Color) -> Self {
        transform { $0.config.titleColor = color }
    }
}
