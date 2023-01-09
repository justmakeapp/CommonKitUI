//
//  File.swift
//
//
//  Created by Long Vu on 19/09/2022.
//

import SwiftUI

public struct ProgressView: View {
    private let percentage: Double
    private var configuration: Configuration = .init()

    public init(percentage: Double) {
        self.percentage = percentage
    }

    public var body: some View {
        contentView
    }

    private var contentView: some View {
        GeometryReader { proxy in
            trackView
            progressView(width: proxy.size.width)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(configuration.cornerRadius)
        .animation(.easeOut(duration: 0.25), value: percentage)
    }

    private func progressView(width: CGFloat) -> some View {
        return Rectangle()
            .fill(configuration.progressColor)
            .frame(width: width * percentage)
            .cornerRadius(configuration.cornerRadius)
    }

    private var trackView: some View {
        Rectangle().fill(configuration.trackColor)
    }
}

public extension ProgressView {
    private struct Configuration {
        var progressColor: Color = .blue
        var trackColor: Color = .gray
        var cornerRadius = CGFloat(8)
    }

    func progressColor(_ value: Color) -> Self {
        return then { $0.configuration.progressColor = value }
    }

    func trackColor(_ value: Color) -> Self {
        return then { $0.configuration.trackColor = value }
    }

    func cornerRadius(_ value: CGFloat) -> Self {
        return then { $0.configuration.cornerRadius = value }
    }
}
