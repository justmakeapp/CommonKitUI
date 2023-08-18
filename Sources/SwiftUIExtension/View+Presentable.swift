//
//  View+Presentable.swift
//
//
//  Created by longvu on 05/07/2022.
//

import SwiftUI

public extension View {
    func alert<Value>(
        using value: Binding<Value?>,
        content: (Value) -> Alert
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return alert(isPresented: binding) {
            content(value.wrappedValue!)
        }
    }

    @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
    func alert<Value>(
        title: Text,
        using value: Binding<Value?>,
        @ViewBuilder actions: @escaping (Value) -> some View
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )

        return alert(title, isPresented: binding) {
            if let value = value.wrappedValue {
                actions(value)
            }
        }
    }

    @available(iOS 15, *)
    func alert<Value>(
        using value: Binding<Value?>,
        title: (Value) -> String,
        @ViewBuilder content: @escaping (Value) -> some View,
        @ViewBuilder message: @escaping (Value) -> some View
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        let titleText: String = {
            if let value = value.wrappedValue {
                return title(value)
            } else {
                return ""
            }
        }()

        return alert(titleText, isPresented: binding) {
            if let value = value.wrappedValue {
                content(value)
            } else {
                EmptyView()
            }
        } message: {
            if let value = value.wrappedValue {
                message(value)
            } else {
                EmptyView()
            }
        }
    }

    func sheet<Value>(
        using value: Binding<Value?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Value) -> some View
    ) -> some View {
        let binding = Binding<Bool>(
            get: { value.wrappedValue != nil },
            set: { _ in value.wrappedValue = nil }
        )
        return sheet(isPresented: binding, onDismiss: onDismiss) {
            content(value.wrappedValue!)
        }
    }
}
