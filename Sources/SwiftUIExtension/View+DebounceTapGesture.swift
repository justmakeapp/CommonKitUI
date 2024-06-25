//
//  View+DebounceTapGesture.swift
//
//
//  Created by Duy Truong on 11/12/2022.
//

import SwiftUI

private struct DebounceTapGesture: ViewModifier {
    private let debounceTime: DispatchTimeInterval
    private let action: @MainActor () -> Void

    @State private var canTap = true

    init(
        debounceTime: DispatchTimeInterval,
        action: @escaping @MainActor () -> Void
    ) {
        self.debounceTime = debounceTime
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                if canTap {
                    action()
                    canTap = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + debounceTime) {
                        canTap = true
                    }
                }
            }
    }
}

public extension View {
    func onDebounceTapGesture(
        debounceTime: DispatchTimeInterval = .seconds(1),
        perform action: @escaping @MainActor () -> Void
    ) -> some View {
        modifier(DebounceTapGesture(
            debounceTime: debounceTime,
            action: action
        ))
    }
}
