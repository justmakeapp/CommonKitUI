//
//  KeyboardObserverViewModifer.swift
//  CommonKitUI
//
//  Created by Long Vu on 21/4/25.
//

import Combine
import SwiftUI

#if os(iOS)
    public struct KeyboardObserverViewModifer: ViewModifier {
        @Binding var didShow: Bool

        public init(didShow: Binding<Bool>) {
            self._didShow = didShow
        }

        private var keyboardPublisher: AnyPublisher<Bool, Never> {
            Publishers.Merge(
                NotificationCenter.default
                    .publisher(for: UIResponder.keyboardDidShowNotification)
                    .map { _ in true },

                NotificationCenter.default
                    .publisher(for: UIResponder.keyboardWillHideNotification)
                    .map { _ in false }
            )
            .eraseToAnyPublisher()
        }

        public func body(content: Content) -> some View {
            content
                .onReceive(keyboardPublisher.receive(on: DispatchQueue.main)) { didShow in
                    withAnimation {
                        self.didShow = didShow
                    }
                }
        }
    }
#endif
