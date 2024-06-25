//
//  ImageErrorView.swift
//
//
//  Created by Long Vu on 10/6/24.
//

import SwiftUI

public struct ImageErrorView: View {
    public init() {}

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        Rectangle()
            .fill(Color.white.opacity(0.2))
            .cornerRadius(8)
            .overlay {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .foregroundStyle(.red)
            }
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: 8, style: .continuous)
            )
    }
}
