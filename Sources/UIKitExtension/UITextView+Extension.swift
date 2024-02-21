//
//  UITextView+Extension.swift
//
//
//  Created by Long Vu on 04/04/2023.
//

#if canImport(UIKit)
    import UIKit

    public extension UITextView {
        func addDoneButton() {
            // On IPad, there always will be done (close button) in keyboard
            // So we should check for device type class and not horizontal size class
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            if isIpad { return }

            let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44))
            let flexButton = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                target: nil,
                action: nil
            )
            let doneButton = UIBarButtonItem(systemItem: .done)
            doneButton.target = self
            doneButton.action = #selector(didTapDoneButton)
            toolBar.items = [flexButton, doneButton]
            toolBar.setItems([flexButton, doneButton], animated: true)
            inputAccessoryView = toolBar
        }

        @objc func didTapDoneButton() {
            resignFirstResponder()
        }
    }
#endif
