//
//  DebounceButton.swift
//
//
//  Created by Duy Truong on 11/12/2022.
//

import SwiftUI
import SwiftUIExtension

#if canImport(UIKit.UIImpactFeedbackGenerator)
    import UIKit.UIImpactFeedbackGenerator
#endif

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
                #if canImport(UIKit.UIImpactFeedbackGenerator)
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                #endif

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
        then { $0.debounceTime = value }
    }
}
