//
//  SectionHeader.swift
//  AppFoundation
//
//  Created by Long Vu on 26/2/25.
//

import SwiftUI

public struct SectionHeader<TrailingButton: View>: View {
    let title: String
    let subtitle: String?
    let trailingButtonBuilder: () -> TrailingButton

    private var config = Config()

    public init(
        _ title: String,
        subtitle: String? = nil,
        @ViewBuilder trailingButtonBuilder: @escaping () -> TrailingButton = { Spacer() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.trailingButtonBuilder = trailingButtonBuilder
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 6) {
                Text(title)
                    .font(config.titleFont)
                    .frame(maxWidth: .infinity, alignment: .leading)

                trailingButtonBuilder()
            }

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
        }

        .fontWeight(.bold)
    }
}

public extension SectionHeader {
    private struct Config {
        var titleFont: Font = .title2
    }

    func titleFont(_ font: Font) -> Self {
        transform { $0.config.titleFont = font }
    }
}

#Preview {
    VStack {
        SectionHeader(
            "Documents",
            subtitle: "You can add different types of content to your topic and easily bring them all together into one high-quality document"
        ) {
            Button("Add", systemImage: "plus") {}
                .buttonStyle(.bordered)
                .clipShape(.capsule)
        }
        .padding(.horizontal)

        SectionHeader("Recent Topics") {
            Button {} label: {
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.bordered)
            .clipShape(.circle)
        }
        .padding(.horizontal)
    }
}
