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
            titleView
                .modifier {
                    if let action = config.onTitleTapped {
                        $0.onTapGesture(perform: action)
                    } else {
                        $0
                    }
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

    private var titleView: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(config.titleFont)

            trailingButtonBuilder()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

public extension SectionHeader {
    private struct Config {
        var titleFont: Font = .title2
        var onTitleTapped: (() -> Void)?
    }

    func titleFont(_ font: Font) -> Self {
        transform { $0.config.titleFont = font }
    }

    func onTitleTapped(_ action: @escaping () -> Void) -> Self {
        transform { $0.config.onTitleTapped = action }
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
