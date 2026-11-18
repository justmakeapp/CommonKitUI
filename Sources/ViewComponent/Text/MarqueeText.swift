//
//  MarqueeText.swift
//  AppHomeKit
//
//  Created by Long Vu on 2/5/25.
//

import SwiftUI

#if canImport(UIKit)
    public typealias PlatformFont = UIFont
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
    public typealias PlatformFont = NSFont
#endif

/// Text that scrolls sideways, with faded edges, when it is wider than its container.
///
/// The scroll is a Core Animation animation, which the render server plays: the app does no work
/// per frame, so a scrolling title doesn't keep the CPU busy. That's also why the text takes its
/// colour from `foregroundColor` rather than from `.foregroundStyle`, which UIKit can't read.
public struct MarqueeText: View {
    public var text: String
    public var font: PlatformFont
    public var foregroundColor: Color
    public var leftFade: CGFloat
    public var rightFade: CGFloat
    public var startDelay: Double
    public var alignment: Alignment

    var isCompact = false

    public var body: some View {
        let stringWidth = text.widthOfString(usingFont: font)
        let stringHeight = text.heightOfString(usingFont: font)

        GeometryReader { geo in
            if stringWidth > geo.size.width {
                scrollingText(width: geo.size.width)
            } else {
                Text(text)
                    .font(.init(font))
                    .foregroundStyle(foregroundColor)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: alignment // use alignment only if not scrolling
                    )
            }
        }
        .frame(height: stringHeight)
        .frame(maxWidth: isCompact ? stringWidth : nil)
    }

    @ViewBuilder
    private func scrollingText(width: CGFloat) -> some View {
        #if os(iOS) || os(tvOS) || os(visionOS)
            // Widened by the left fade so the text starts at the leading edge and fades into the space before it.
            MarqueeScrollingText(
                text: text,
                font: font,
                color: foregroundColor,
                leftFade: leftFade,
                rightFade: rightFade,
                startDelay: startDelay
            )
            .frame(width: width + leftFade)
            .offset(x: -leftFade)
            .accessibilityRepresentation { Text(text) }
        #else
            Text(text)
                .font(.init(font))
                .foregroundStyle(foregroundColor)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        #endif
    }

    // MARK: - Initializer

    public init(
        text: String,
        font: PlatformFont,
        foregroundColor: Color = .primary,
        leftFade: CGFloat,
        rightFade: CGFloat,
        startDelay: Double,
        alignment: Alignment? = nil
    ) {
        self.text = text
        self.font = font
        self.foregroundColor = foregroundColor
        self.leftFade = leftFade
        self.rightFade = rightFade
        self.startDelay = startDelay
        self.alignment = alignment ?? .topLeading
    }
}

public extension MarqueeText {
    func makeCompact(_ compact: Bool = true) -> Self {
        var view = self
        view.isCompact = compact
        return view
    }
}

#if os(iOS) || os(tvOS) || os(visionOS)

    // MARK: - Scrolling text

    private struct MarqueeScrollingText: UIViewRepresentable {
        let text: String
        let font: UIFont
        let color: Color
        let leftFade: CGFloat
        let rightFade: CGFloat
        let startDelay: Double

        func makeUIView(context _: Context) -> MarqueeScrollingView {
            MarqueeScrollingView()
        }

        func updateUIView(_ view: MarqueeScrollingView, context: Context) {
            let uiColor = if #available(iOS 17.0, tvOS 17.0, visionOS 1.0, *) {
                // Resolved here, so a light/dark change reaches the label through this update.
                UIColor(Color(color.resolve(in: context.environment)))
            } else {
                UIColor(color)
            }
            view.update(.init(
                text: text,
                font: font,
                color: uiColor,
                leftFade: leftFade,
                rightFade: rightFade,
                startDelay: startDelay
            ))
        }
    }

    /// Two copies of the text on a track, separated by a gap. The track slides left by one copy and its gap,
    /// which leaves the second copy where the first started, so the animation can jump back without a visible seam.
    final class MarqueeScrollingView: UIView {
        struct Content: Equatable {
            var text: String
            var font: UIFont
            var color: UIColor
            var leftFade: CGFloat
            var rightFade: CGFloat
            var startDelay: Double
        }

        /// Every marquee starts its scrolls on the same clock ticks, this many seconds apart, so all titles on
        /// screen scroll together and rest together, and the screen has nothing to redraw in between.
        private static let scrollCycle: CFTimeInterval = 10
        /// The least time a title rests at its start before it scrolls again.
        private static let minimumPause: CFTimeInterval = 3
        /// Scrolling speed, in points per second.
        private static let speed: CGFloat = 30
        private static let animationKey = "marquee"

        private var content: Content?
        private let track = UIView()
        private let labels = [UILabel(), UILabel()]
        private let fadeMask = CAGradientLayer()
        /// The track distance of the running animation, to restart it only when the layout changes it.
        private var animatedDistance: CGFloat?

        init() {
            super.init(frame: .zero)
            isUserInteractionEnabled = false
            addSubview(track)
            for label in labels {
                label.numberOfLines = 1
                label.isAccessibilityElement = false
                track.addSubview(label)
            }
            let clear = UIColor.clear.cgColor
            let opaque = UIColor.black.cgColor
            fadeMask.colors = [clear, clear, opaque, opaque, clear, clear]
            fadeMask.startPoint = CGPoint(x: 0, y: 0.5)
            fadeMask.endPoint = CGPoint(x: 1, y: 0.5)
            layer.mask = fadeMask
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func update(_ newContent: Content) {
            guard newContent != content else { return }
            content = newContent
            for label in labels {
                label.text = newContent.text
                label.font = newContent.font
                label.textColor = newContent.color
            }
            animatedDistance = nil
            setNeedsLayout()
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            guard let content, bounds.width > 0 else { return }

            let textSize = labels[0].intrinsicContentSize
            let gap = textSize.height * 2
            labels[0].frame = CGRect(x: content.leftFade, y: 0, width: textSize.width, height: bounds.height)
            labels[1].frame = labels[0].frame.offsetBy(dx: textSize.width + gap, dy: 0)
            track.frame = bounds

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            fadeMask.frame = bounds
            let width = bounds.width
            fadeMask.locations = [
                0,
                2 / width,
                (2 + content.leftFade) / width,
                (width - 2 - content.rightFade) / width,
                (width - 2) / width,
                1,
            ].map { NSNumber(value: Double($0)) }
            CATransaction.commit()

            startScrolling(distance: textSize.width + gap, textWidth: textSize.width)
        }

        override func didMoveToWindow() {
            super.didMoveToWindow()
            // A layer can lose its animations while off screen, for example when the app goes to the background.
            if window != nil, track.layer.animation(forKey: Self.animationKey) == nil {
                animatedDistance = nil
                setNeedsLayout()
            }
        }

        private func startScrolling(distance: CGFloat, textWidth: CGFloat) {
            guard let content, window != nil else { return }
            if distance == animatedDistance, track.layer.animation(forKey: Self.animationKey) != nil {
                return
            }
            animatedDistance = distance

            let scrollDuration = CFTimeInterval(textWidth / Self.speed)
            let period = ((scrollDuration + Self.minimumPause) / Self.scrollCycle).rounded(.up) * Self.scrollCycle

            // Scroll, then rest at the start for the rest of the period.
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.values = [0, -distance, -distance]
            animation.keyTimes = [0, NSNumber(value: scrollDuration / period), 1]
            animation.duration = period
            animation.repeatCount = .infinity
            animation.isRemovedOnCompletion = false
            let earliestStart = CACurrentMediaTime() + content.startDelay
            let start = (earliestStart / Self.scrollCycle).rounded(.up) * Self.scrollCycle
            animation.beginTime = track.layer.convertTime(start, from: nil)
            track.layer.add(animation, forKey: Self.animationKey)
        }
    }

#endif

extension String {
    func widthOfString(usingFont font: PlatformFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: PlatformFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
}
