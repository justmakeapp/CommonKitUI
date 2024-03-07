//
//  DebounceButton.swift
//
//
//  Created by Duy Truong on 11/12/2022.
//

import SwiftUI
import SwiftUIExtension

public struct DebounceButton<LabelView: View>: View {
    private let action: () -> Void
    private let label: () -> LabelView

    @State private var canTap = true
    private var debounceTime: DispatchTimeInterval = .seconds(1)

    public init(
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> LabelView
    ) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button {
            if canTap {
                FeedbackManager.selectionChangedFeedback()

                action()
                canTap = false
                DispatchQueue.main.asyncAfter(deadline: .now() + debounceTime) {
                    canTap = true
                }
            }
        } label: {
            label()
        }
    }
}

public extension DebounceButton {
    func debounceTime(_ value: DispatchTimeInterval) -> Self {
        transform { $0.debounceTime = value }
    }
}
