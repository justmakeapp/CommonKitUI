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
/// On iOS, tvOS and visionOS the scroll is a Core Animation animation, which the render server plays:
/// the app does no work per frame, so a scrolling title doesn't keep the CPU busy. UIKit can't read
/// `.foregroundStyle`, so pass the colour as `foregroundColor` there (it falls back to `.primary`).
/// On macOS and watchOS the scroll is a SwiftUI animation that inherits `.foregroundStyle`.
///
/// Either way a title scrolls once, rests at its start, and starts on the same clock tick as every
/// other marquee, so titles on screen scroll together and rest together.
public struct MarqueeText: View {
    public var text: String
    public var font: PlatformFont
    /// The text colour. When nil, the text takes the inherited `.foregroundStyle`, except when the
    /// Core Animation path scrolls it, which draws it in `.primary`.
    public var foregroundColor: Color?
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
                    .foregroundStyle(ifSet: foregroundColor)
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
                color: foregroundColor ?? .primary,
                leftFade: leftFade,
                rightFade: rightFade,
                startDelay: startDelay
            )
            .frame(width: width + leftFade)
            .offset(x: -leftFade)
            .accessibilityRepresentation { Text(text) }
        #else
            MarqueeSwiftUIScrollingText(
                text: text,
                font: font,
                leftFade: leftFade,
                rightFade: rightFade,
                startDelay: startDelay
            )
            .foregroundStyle(ifSet: foregroundColor)
            .frame(width: width + leftFade)
            .offset(x: -leftFade)
        #endif
    }

    // MARK: - Initializer

    public init(
        text: String,
        font: PlatformFont,
        foregroundColor: Color? = nil,
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

/// When marquees start their scrolls, shared by both implementations.
private enum MarqueeTiming {
    /// Every marquee starts its scrolls on the same clock ticks, this many seconds apart, so all titles on
    /// screen scroll together and rest together, and the screen has nothing to redraw in between.
    static let scrollCycle: TimeInterval = 10
    /// The least time a title rests at its start before it scrolls again.
    static let minimumPause: TimeInterval = 3
    /// Scrolling speed, in points per second.
    static let speed: CGFloat = 30

    /// The first clock tick at or after `time`.
    static func tick(atOrAfter time: TimeInterval) -> TimeInterval {
        (time / scrollCycle).rounded(.up) * scrollCycle
    }
}

private extension View {
    @ViewBuilder
    func foregroundStyle(ifSet color: Color?) -> some View {
        if let color {
            foregroundStyle(color)
        } else {
            self
        }
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

            let scrollDuration = CFTimeInterval(textWidth / MarqueeTiming.speed)
            let period = MarqueeTiming.tick(atOrAfter: scrollDuration + MarqueeTiming.minimumPause)

            // Scroll, then rest at the start for the rest of the period.
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.values = [0, -distance, -distance]
            animation.keyTimes = [0, NSNumber(value: scrollDuration / period), 1]
            animation.duration = period
            animation.repeatCount = .infinity
            animation.isRemovedOnCompletion = false
            let start = MarqueeTiming.tick(atOrAfter: CACurrentMediaTime() + content.startDelay)
            animation.beginTime = track.layer.convertTime(start, from: nil)
            track.layer.add(animation, forKey: Self.animationKey)
        }
    }

#else

    // MARK: - Scrolling text (SwiftUI)

    /// Two copies of the text, moved by a SwiftUI animation that a task starts on each clock tick.
    /// Platforms without Core Animation in UIKit use this; the app does work every frame while it moves.
    private struct MarqueeSwiftUIScrollingText: View {
        let text: String
        let font: PlatformFont
        let leftFade: CGFloat
        let rightFade: CGFloat
        let startDelay: Double

        @State private var animate = false

        var body: some View {
            let stringWidth = text.widthOfString(usingFont: font)
            let stringHeight = text.heightOfString(usingFont: font)
            let scrollDuration = Double(stringWidth / MarqueeTiming.speed)
            let distance = stringWidth + stringHeight * 2

            ZStack(alignment: .topLeading) {
                ForEach(0 ..< 2, id: \.self) { copy in
                    Text(text)
                        .lineLimit(1)
                        .font(.init(font))
                        .fixedSize(horizontal: true, vertical: false)
                        .offset(x: distance * CGFloat(copy) - (animate ? distance : 0))
                }
            }
            .animation(animate ? .linear(duration: scrollDuration) : nil, value: animate)
            .padding(.leading, leftFade)
            // minWidth 0 sizes the frame to its container, not to the wider text, so the mask clips the text.
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .mask(fadeMask)
            .task(id: text) {
                animate = false
                var earliestStart = Date.now.addingTimeInterval(startDelay)
                while !Task.isCancelled {
                    let now = Date.now.timeIntervalSinceReferenceDate
                    let start = MarqueeTiming.tick(atOrAfter: earliestStart.timeIntervalSinceReferenceDate)
                    try? await Task.sleep(nanoseconds: UInt64(max(0, start - now) * 1_000_000_000))
                    guard !Task.isCancelled else { return }
                    animate = true
                    try? await Task.sleep(nanoseconds: UInt64(scrollDuration * 1_000_000_000))
                    // The second copy now sits where the first started, so jumping back is invisible.
                    animate = false
                    earliestStart = .now.addingTimeInterval(MarqueeTiming.minimumPause)
                }
            }
        }

        private var fadeMask: some View {
            HStack(spacing: 0) {
                Color.clear.frame(width: 2)
                LinearGradient(colors: [.clear, .black], startPoint: .leading, endPoint: .trailing)
                    .frame(width: leftFade)
                Color.black
                LinearGradient(colors: [.black, .clear], startPoint: .leading, endPoint: .trailing)
                    .frame(width: rightFade)
                Color.clear.frame(width: 2)
            }
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
