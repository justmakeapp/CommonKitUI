//
//  TypewriterView.swift
//
//
//  Created by Long Vu on 05/02/2024.
//

import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public struct TypewriterView: View {
    private var text: String
    private var typingDelay: Duration

    @State private var animatedText: AttributedString = ""
    @State private var typingTask: Task<Void, Error>?

    let onCompleted: () -> Void

    public init(
        text: String,
        typingDelay: Duration = .milliseconds(30),
        onCompleted: @escaping () -> Void = {}
    ) {
        self.text = text
        self.typingDelay = typingDelay
        self.onCompleted = onCompleted
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

            var index = animatedText.startIndex
            while index < animatedText.endIndex {
                try Task.checkCancellation()

                // Update the style
                animatedText[animatedText.startIndex ... index]
                    .setAttributes(defaultAttributes)

                // Wait
                try await Task.sleep(for: typingDelay)

                // Advance the index, character by character
                index = animatedText.index(afterCharacter: index)
            }

            onCompleted()
        }
    }
}
