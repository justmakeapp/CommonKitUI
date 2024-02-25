//
//  TypewriterView.swift
//
//
//  Created by Long Vu on 05/02/2024.
//

import SwiftUI
import SwiftUIExtension

@available(iOS 16.0, macOS 13.0, *)
public struct TypewriterView: View {
    private var text: String

    @State private var animatedText: AttributedString = ""
    @State private var typingTask: Task<Void, Error>?

    private var config: Config

    public init(
        text: String,
        typingDelay: Duration = .milliseconds(30)
    ) {
        self.text = text
        self.config = .init(typingDelay: typingDelay)
    }

    public var body: some View {
        Text(animatedText)
            .onChange(of: text) { _ in animateText() }
            .onAppear { animateText() }
    }

    private func animateText() {
        typingTask?.cancel()

        typingTask = Task {
            let defaultAttributes = AttributeContainer()
            animatedText = AttributedString(
                text,
                attributes: defaultAttributes.foregroundColor(.clear)
            )

            let stringIndex = text.index(
                text.startIndex,
                offsetBy: config.offsetBy
            )
            var index = AttributedString.Index(
                stringIndex,
                within: animatedText
            ) ?? animatedText.startIndex

            while index < animatedText.endIndex {
                try Task.checkCancellation()

                // Update the style
                animatedText[animatedText.startIndex ... index]
                    .setAttributes(defaultAttributes)

                // Wait
                try await Task.sleep(for: config.typingDelay)

                // Advance the index, character by character
                index = animatedText.index(afterCharacter: index)
            }

            config.onCompleted()
        }
    }
}

@available(iOS 16.0, *)
public extension TypewriterView {
    struct Config {
        var typingDelay: Duration = .milliseconds(30)
        var offsetBy: Int = 0
        var onCompleted: () -> Void = {}
    }

//    func typingDelay(_ value: Duration) -> Self {
//        then { $0.config.typingDelay = value }
//    }

    func offsetBy(_ value: Int) -> Self {
        then { $0.config.offsetBy = value }
    }

    func onCompleted(_ value: @escaping () -> Void) -> Self {
        then { $0.config.onCompleted = value }
    }
}
