//
//  DebounceButton.swift
//
//
//  Created by Duy Truong on 11/12/2022.
//

import SwiftUI
import SwiftUIExtension

public struct DebounceButton<LabelView: View>: View {
    private let action: @MainActor () -> Void
    private let label: () -> LabelView

    @State private var canTap = true

    private var config = Config()

    public init(
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: @escaping () -> LabelView
    ) {
        self.action = action
        self.label = label
    }

    public var body: some View {
        Button {
            if canTap {
                if !config.disabledHapticFeedback {
                    FeedbackManager.selectionChangedFeedback()
                }

                action()
                canTap = false

                DispatchQueue.main.asyncAfter(deadline: .now() + config.debounceTime) {
                    canTap = true
                }
            }
        } label: {
            label()
        }
    }
}

public extension DebounceButton {
    struct Config {
        var debounceTime: DispatchTimeInterval = .seconds(1)
        var disabledHapticFeedback = false
    }

    func debounceTime(_ value: DispatchTimeInterval) -> Self {
        transform { $0.config.debounceTime = value }
    }

    func disabledHapticFeedback(_ value: Bool = true) -> Self {
        transform { $0.config.disabledHapticFeedback = value }
    }
}
