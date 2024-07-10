//
//  CustomEmptyView.swift
//
//
//  Created by Long Vu on 10/12/2023.
//

import SwiftUI

public struct CustomEmptyView: View {
    private let title: String
    private let systemImage: String
    private let description: Text?

    public init(_ title: String, systemImage: String = "tray", description: Text? = nil) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }

    public var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .imageScale(.large)

            VStack {
                Text(title)
                    .font(.title3.weight(.semibold))

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
