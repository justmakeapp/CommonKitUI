//
//  KeyboardReadable.swift
//
//
//  Created by Long Vu on 24/09/2022.
//

#if os(iOS)
    import Combine
    import UIKit

    /// Publisher to read keyboard changes.
    public protocol KeyboardReadable {
        var keyboardPublisher: AnyPublisher<Bool, Never> { get }
        var keyboardSizePublisher: AnyPublisher<CGSize, Never> { get }
    }

    public extension KeyboardReadable {
        var keyboardPublisher: AnyPublisher<Bool, Never> {
            Publishers.Merge(
                NotificationCenter.default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { _ in true },

                NotificationCenter.default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false }
            )
            .eraseToAnyPublisher()
        }

        var keyboardSizePublisher: AnyPublisher<CGSize, Never> {
            return Publishers.Merge(
                NotificationCenter.default
                    .publisher(for: UIResponder.keyboardWillShowNotification)
                    .map { notification -> CGSize in
                        guard
                            let userInfo = notification.userInfo,
                            let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                        else {
                            return .zero
                        }

                        return keyboardRect.size
                    },
                NotificationCenter.default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in
                        return .zero
                    }
            )

            .removeDuplicates()
            .eraseToAnyPublisher()
        }
    }
#endif
