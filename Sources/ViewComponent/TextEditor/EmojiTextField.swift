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

        public init(text: Binding<String>, placeholder: String = "") {
            self._text = text
            self.placeholder = placeholder
        }

        public func makeUIView(context: Context) -> UIEmojiTextField {
            let emojiTextField = UIEmojiTextField()
            emojiTextField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            emojiTextField.placeholder = placeholder

            // https://x.com/SebJVidal/status/1813900137728762026
            emojiTextField.keyboardType = UIKeyboardType(rawValue: 124) ?? .default

            emojiTextField.text = text
            emojiTextField.delegate = context.coordinator
            emojiTextField.font = UIFont(name: "HelveticaNeue", size: 50)
            emojiTextField.textAlignment = .center
            emojiTextField.endFloatingCursor()
            emojiTextField.becomeFirstResponder()
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

    struct EmojiTextField: NSViewRepresentable {
        @Binding var text: String
        var placeholder: String = ""

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        func makeNSView(context: Context) -> NSTextField {
            let textField = FocusAwareTextField()
            textField.delegate = context.coordinator
            textField.placeholderString = placeholder
            textField.isBordered = false
            textField.isBezeled = false
            textField.isEditable = true
            textField.isSelectable = true
            textField.focusRingType = .none
            textField.backgroundColor = .clear
            textField.font = .systemFont(ofSize: 50)

            return textField
        }

        func updateNSView(_ nsView: NSTextField, context _: Context) {
            if nsView.stringValue != text {
                nsView.stringValue = text
            }
        }

        class Coordinator: NSObject, NSTextFieldDelegate {
            var parent: EmojiTextField

            init(_ parent: EmojiTextField) {
                self.parent = parent
            }

            func controlTextDidChange(_ obj: Notification) {
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
            onFocus()
            let textView = window?.fieldEditor(true, for: nil) as? NSTextView
            textView?.insertionPointColor = .clear

            return super.becomeFirstResponder()
        }

        override func resignFirstResponder() -> Bool {
            onUnfocus()
            return super.resignFirstResponder()
        }

//    override func selectText(_ sender: Any?) {
//          // Override and do nothing
//
//      }
    }
#endif
