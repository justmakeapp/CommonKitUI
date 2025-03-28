//
//  ProgressView.swift
//
//
//  Created by Long Vu on 19/09/2022.
//

import SwiftUI

public struct ProgressView: View {
    private let percentage: Double
    private var config: Configuration = .init()

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
        .cornerRadius(config.cornerRadius)
        .animation(.easeOut(duration: 0.25), value: percentage)
    }

    @ViewBuilder
    private func progressView(width: CGFloat) -> some View {
        switch config.style {
        case .bar:
            Rectangle()
                .fill(.tint)
                .frame(width: max(width * percentage, 0))
                .cornerRadius(config.cornerRadius)

        case .circular:
            Circle()
                .trim(from: 0, to: CGFloat(min(percentage, 1.0)))
                .stroke(
                    config.progressColor,
                    style: StrokeStyle(
                        lineWidth: config.lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.linear, value: percentage)
                .padding(config.lineWidth / 2)
        }
    }

    @ViewBuilder
    private var trackView: some View {
        switch config.style {
        case .bar:
            Rectangle()
                .fill(config.trackColor)

        case .circular:
            Circle()
                .stroke(config.trackColor, lineWidth: config.lineWidth)
                .padding(config.lineWidth / 2)
        }
    }
}

public extension ProgressView {
    private struct Configuration {
        var style: Style = .bar
        var progressColor: Color = .blue
        var useTintAsProgressColor = true
        var trackColor: Color = .gray
        var cornerRadius = CGFloat(8)
        var lineWidth: CGFloat = 16
    }

    enum Style {
        case circular
        case bar
    }

    func style(_ value: Style) -> Self {
        transform { $0.config.style = value }
    }

    func progressColor(_ value: Color) -> Self {
        transform { $0.config.progressColor = value }
    }

    func useTintAsProgressColor(_ value: Bool) -> Self {
        transform { $0.config.useTintAsProgressColor = value }
    }

    func trackColor(_ value: Color) -> Self {
        transform { $0.config.trackColor = value }
    }

    func cornerRadius(_ value: CGFloat) -> Self {
        transform { $0.config.cornerRadius = value }
    }

    func lineWidth(_ value: CGFloat) -> Self {
        transform { $0.config.lineWidth = value }
    }
}

#Preview {
    VStack {
        ProgressView(percentage: 0.3)
            .frame(height: 10)

        ProgressView(percentage: 0.3)
            .style(.circular)
            .frame(width: 160, height: 160)
    }
    .padding()
}
