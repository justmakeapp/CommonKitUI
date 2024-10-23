//
//  TypeWriterWithIndicatorView.swift
//  CommonKitUI
//
//  Created by Long Vu on 22/10/24.
//

import SwiftUI
import SwiftUIExtension

public struct TypeWriterWithIndicatorView: View {
    private var sentences: [String]

    @State private var typingTaskId: Int = 0

    @State private var animatedText: String = ""
    @State private var currentSampleIndex = 0

    #if os(macOS)
        @Environment(\.controlActiveState) private var controlActiveState
    #endif

    #if os(iOS)
        @Environment(\.scenePhase) var scenePhase
    #endif

    private var config: Config = .init()

    public init(
        sentences: [String]
    ) {
        self.sentences = sentences
    }

    public var body: some View {
        contentView
        #if os(macOS)
        .onChange(of: controlActiveState) { newValue in
            switch newValue {
            case .key, .active:
                animateText()
            case .inactive:
                break
            @unknown default:
                break
            }
        }
        #endif
        #if os(iOS)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                animateText()
            }
        }
        #endif
    }

    private var contentView: some View {
        (Text(animatedText) + Text(" ") + Text(Image(systemName: "circle.fill")))
            .onAppear { animateText() }
            .task(id: typingTaskId) {
                #if os(macOS)
                    guard controlActiveState != .inactive else {
                        return
                    }
                #endif
                #if os(iOS)
                    guard scenePhase == .active else {
                        return
                    }
                #endif
                guard sentences.count > currentSampleIndex else {
                    return
                }
                let text = sentences[currentSampleIndex]
                if let endIndex: String.Index = text.index(
                    text.startIndex,
                    offsetBy: animatedText.count + 1,
                    limitedBy: text.endIndex
                ) {
                    try? await Task.sleep(nanoseconds: 60_000_000)
                    animatedText = String(text[text.startIndex ..< endIndex])
                    selectionChangedFeedback()
                    animateText()
                } else {
                    if sentences.count > 1 {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        await retractText()

                        try? await Task.sleep(nanoseconds: 500_000_000)
                        currentSampleIndex = (currentSampleIndex + 1) % sentences.count
                        animateText()
                        config.onNextSentence()
                    }
                }
            }
    }

    private func selectionChangedFeedback() {
        #if os(macOS)
            guard controlActiveState != .inactive else {
                return
            }
        #endif
        #if os(iOS)
            guard scenePhase == .active else {
                return
            }
        #endif
        guard config.enabledHapticFeedback else {
            return
        }
        #if os(iOS)
            UISelectionFeedbackGenerator().selectionChanged()
        #endif
        #if os(macOS)
            NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)
        #endif
    }

    private func retractText() async {
        while !animatedText.isEmpty {
            try? await Task.sleep(nanoseconds: 20_000_000)
            animatedText.removeLast()
            selectionChangedFeedback()
        }
    }

    private func animateText() {
        typingTaskId += 1
    }
}

public extension TypeWriterWithIndicatorView {
    struct ColorCombination: Sendable, Equatable {
        public var textColor: Color
        public var bgColor: Color

        public init(textColor: Color, bgColor: Color) {
            self.textColor = textColor
            self.bgColor = bgColor
        }
    }

    struct Config {
        var onNextSentence: () -> Void = {}
        var enabledHapticFeedback: Bool = true
    }

    func onNextSentence(perform action: @escaping () -> Void) -> Self {
        transform { $0.config.onNextSentence = action }
    }

    func enabledHapticFeedback(_ enabled: Bool) -> some View {
        transform { $0.config.enabledHapticFeedback = enabled }
    }
}

public extension TypeWriterWithIndicatorView.ColorCombination {
    // https://designwizard.com/blog/colour-combination/
    static let `default` = [
        Self(
            textColor: Color(hexRGBA: "#00539CFF")!, // Princess Blue
            bgColor: Color(hexRGBA: "#FFD662FF")! // Aspen Gold
        ),
        Self(textColor: Color(hexRGBA: "#E69A8DFF")!, bgColor: Color(hexRGBA: "#5F4B8BFF")!),
        Self(textColor: Color(hexRGBA: "#97BC62FF")!, bgColor: Color(hexRGBA: "#2C5F2DFF")!),
        Self(textColor: Color(hexRGBA: "#9CC3D5FF")!, bgColor: Color(hexRGBA: "#0063B2FF")!),
        Self(
            textColor: Color(hexRGBA: "#3C1053FF")!, // Purple
            bgColor: Color(hexRGBA: "#DF6589FF")! // Rose Pink
        )
    ]
}

// MARK: - Previews

struct TypeWriterWithIndicatorView_Previews: PreviewProvider {
    struct ContainerView: View {
        static let colors = TypeWriterWithIndicatorView.ColorCombination.default

        @State private var currentColorCombination: TypeWriterWithIndicatorView.ColorCombination = Self.colors
            .randomElement()!

        var body: some View {
            VStack {
                TypeWriterWithIndicatorView(
                    sentences: [
                        "Let’s have a conversation",
                        "Speak Confidently, Learn Naturally"
                    ]
                )
                .onNextSentence {
                    let random: TypeWriterWithIndicatorView.ColorCombination = {
                        var v = Self.colors.randomElement()!
                        while v == currentColorCombination && Self.colors.count > 1 {
                            v = Self.colors.randomElement()!
                        }
                        return v
                    }()
                    withAnimation {
                        currentColorCombination = random
                    }
                }
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(currentColorCombination.textColor)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(currentColorCombination.bgColor)
        }
    }

    static var previews: some View {
        ContainerView()
    }
}

// MARK: - Color Extensions

#if canImport(UIKit)
    import UIKit.UIColor

    public typealias PlatformColor = UIColor
#endif

#if os(macOS)
    import AppKit.NSColor

    public typealias PlatformColor = NSColor
#endif

private extension Color {
    init?(hexRGB: String) {
        guard let pColor = PlatformColor(hexRGB: hexRGB) else {
            return nil
        }
        self = Color(pColor)
    }

    init?(hexRGBA: String) {
        guard let pColor = PlatformColor(hexRGBA: hexRGBA) else {
            return nil
        }
        self = Color(pColor)
    }
}

#if canImport(UIKit)
    public extension UIColor {
        convenience init?(hexRGBA: String) {
            guard let val = Int(hexRGBA.replacingOccurrences(of: "#", with: ""), radix: 16) else {
                return nil
            }

            self.init(red: CGFloat((val >> 24) & 0xFF) / 255.0,
                      green: CGFloat((val >> 16) & 0xFF) / 255.0,
                      blue: CGFloat((val >> 8) & 0xFF) / 255.0,
                      alpha: CGFloat(val & 0xFF) / 255.0)
        }

        convenience init?(hexRGB: String) {
            self.init(hexRGBA: hexRGB + "ff") // Add alpha = 1.0
        }
    }

#endif

#if canImport(AppKit) && os(macOS)
    import AppKit.NSColor
    import Foundation

    extension NSColor {
        convenience init?(hexRGB: String) {
            self.init(hex: hexRGB)
        }

        convenience init?(hexRGBA: String) {
            self.init(hex: hexRGBA)
        }

        convenience init(hex: String) {
            let trimHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            let dropHash = String(trimHex.dropFirst()).trimmingCharacters(in: .whitespacesAndNewlines)
            let hexString = trimHex.starts(with: "#") ? dropHash : trimHex
            let ui64 = UInt64(hexString, radix: 16)
            let value = ui64 != nil ? Int(ui64!) : 0
            // #RRGGBB
            var components = (
                R: CGFloat((value >> 16) & 0xFF) / 255,
                G: CGFloat((value >> 08) & 0xFF) / 255,
                B: CGFloat((value >> 00) & 0xFF) / 255,
                a: CGFloat(1)
            )
            if String(hexString).count == 8 {
                // #RRGGBBAA
                components = (
                    R: CGFloat((value >> 24) & 0xFF) / 255,
                    G: CGFloat((value >> 16) & 0xFF) / 255,
                    B: CGFloat((value >> 08) & 0xFF) / 255,
                    a: CGFloat((value >> 00) & 0xFF) / 255
                )
            }
            self.init(red: components.R, green: components.G, blue: components.B, alpha: components.a)
        }
    }
#endif
