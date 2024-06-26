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
    @MainActor
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
                    .flatMap { notification -> AnyPublisher<CGSize, Never> in
                        #if swift(>=6)
                            nonisolated(unsafe) let userInfo = notification.userInfo
                        #else
                            let userInfo = notification.userInfo
                        #endif

                        return Deferred {
                            Future<CGSize, Never> { promise in
                                #if swift(>=6)
                                    nonisolated(unsafe) let promise = promise
                                #endif

                                Task { @MainActor in
                                    guard
                                        let keyboardRect = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                                    else {
                                        promise(.success(.zero))
                                        return
                                    }

                                    promise(.success(keyboardRect.size))
                                }
                            }
                        }
                        .eraseToAnyPublisher()
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
