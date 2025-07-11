//
//  EmojiTextField.swift
//  CommonKitUI
//
//  Created by Long Vu on 28/5/25.
//

import Foundation
import SwiftUI

#if os(iOS)
    import UIKit

    public class UIEmojiTextField: UITextField {
//        override public var textInputMode: UITextInputMode? {
//            .activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
//        }

        override public func caretRect(for _: UITextPosition) -> CGRect {
            return CGRect.zero
        }
    }

    public struct EmojiTextField: UIViewRepresentable {
        @Binding var text: String
        var placeholder: String
        var fontSize: CGFloat

        public init(
            text: Binding<String>,
            placeholder: String = "",
            fontSize: CGFloat
        ) {
            self._text = text
            self.placeholder = placeholder
            self.fontSize = fontSize
        }

        public func makeUIView(context: Context) -> UIEmojiTextField {
            let emojiTextField = UIEmojiTextField()
            emojiTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            emojiTextField.placeholder = placeholder

            // https://x.com/SebJVidal/status/1813900137728762026
            emojiTextField.keyboardType = UIKeyboardType(rawValue: 124) ?? .default

            emojiTextField.text = text
            emojiTextField.delegate = context.coordinator
            emojiTextField.font = .systemFont(ofSize: fontSize)
            emojiTextField.textAlignment = .center
            emojiTextField.endFloatingCursor()

            return emojiTextField
        }

        public func updateUIView(_ uiView: UIEmojiTextField, context _: Context) {
            uiView.text = text
        }

        public func makeCoordinator() -> Coordinator {
            Coordinator(parent: self)
        }

        public class Coordinator: NSObject, UITextFieldDelegate {
            var parent: EmojiTextField

            init(parent: EmojiTextField) {
                self.parent = parent
            }

            public func textFieldDidChangeSelection(_ textField: UITextField) {
                DispatchQueue.main.async { [weak self] in
                    self?.parent.text = textField.text ?? ""
                }
            }
        }
    }
#endif

#if os(macOS)
    import AppKit

    public struct EmojiTextField: NSViewRepresentable {
        @Binding var text: String
        var placeholder: String = ""
        var fontSize: CGFloat

        public init(
            text: Binding<String>,
            placeholder: String = "",
            fontSize: CGFloat
        ) {
            self._text = text
            self.placeholder = placeholder
            self.fontSize = fontSize
        }

        public func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        public func makeNSView(context: Context) -> NSTextField {
            let textField = FocusAwareTextField()
            textField.delegate = context.coordinator
            textField.placeholderString = placeholder
            textField.isBordered = false
            textField.isBezeled = false
            textField.isEditable = true
            textField.isSelectable = true
            textField.focusRingType = .none
            textField.backgroundColor = .clear
            textField.font = .systemFont(ofSize: fontSize)

            return textField
        }

        public func updateNSView(_ textField: NSTextField, context _: Context) {
            if textField.stringValue != text {
                textField.stringValue = text
            }
        }

        public class Coordinator: NSObject, NSTextFieldDelegate {
            var parent: EmojiTextField

            init(_ parent: EmojiTextField) {
                self.parent = parent
            }

            public func controlTextDidChange(_ obj: Notification) {
                if let field = obj.object as? NSTextField {
                    parent.text = field.stringValue
                }
            }
        }
    }

    private class FocusAwareTextField: NSTextField {
        var onFocus: () -> Void
        var onUnfocus: () -> Void

        init(onFocus: @escaping () -> Void = {}, onUnfocus: @escaping () -> Void = {}) {
            self.onFocus = onFocus
            self.onUnfocus = onUnfocus
            super.init(frame: .zero)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func becomeFirstResponder() -> Bool {
            let success = super.becomeFirstResponder()

            onFocus()

            if let textView = window?.fieldEditor(true, for: nil) as? NSTextView {
                textView.insertionPointColor = .clear

                // Ditch the highlight on the text.
                let zeroRange = NSRange(location: 0, length: 0)
                textView.setSelectedRange(zeroRange)

                // Move cursor to the end of the line.
                textView.moveToEndOfLine(nil)
            }

            return success
        }

        override func resignFirstResponder() -> Bool {
            onUnfocus()
            return super.resignFirstResponder()
        }
    }
#endif
