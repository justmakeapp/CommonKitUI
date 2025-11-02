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

                description?
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .foregroundColor(.secondary)
        .padding()
    }
}

public extension CustomEmptyView {
    struct Config {
        var symbolRenderingMode: SymbolRenderingMode?
    }

    func symbolRenderingMode(_ mode: SymbolRenderingMode?) -> CustomEmptyView {
        transform { $0.config.symbolRenderingMode = mode }
    }
}
