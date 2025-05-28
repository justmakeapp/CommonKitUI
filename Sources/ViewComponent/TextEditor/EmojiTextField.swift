//
//  EmojiTextField.swift
//  CommonKitUI
//
//  Created by Long Vu on 28/5/25.
//

#if os(iOS)
    import Foundation
    import SwiftUI
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
