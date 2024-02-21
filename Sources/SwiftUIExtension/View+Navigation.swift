//
//  File.swift
//
//
//  Created by Long Vu on 20/01/2024.
//

import SwiftUI

public extension View {
    @available(iOS 16.0, macOS 13.0, *)
    func navigationDestination<Value>(
        using value: Binding<Value?>,
        @ViewBuilder content: (Value) -> some View
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return navigationDestination(isPresented: binding) {
            if let v = value.wrappedValue {
                content(v)
            }
        }
    }
}
