//
//  RoundedPrimaryButtonStyle.swift
//  CommonKitUI
//
//  Created by Long Vu on 3/5/25.
//

import SwiftUI

public struct RoundedPrimaryButtonStyle: ViewModifier {
    public var cornerRadius: CGFloat

    /// A disabled button must look disabled: the fill alone looked the same either way.
    @Environment(\.isEnabled) private var isEnabled

    public init(cornerRadius: CGFloat = 8) {
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal)
            .background(.tint)
            .clipShape(.rect(cornerRadius: cornerRadius))
            .opacity(isEnabled ? 1 : Self.disabledOpacity)
    }

    private static let disabledOpacity = 0.4
}

#Preview {
    VStack {
        Button {} label: {
            Text("Test")
                .modifier(RoundedPrimaryButtonStyle())
                .frame(height: 50)
        }
        .buttonStyle(PressEffectButtonStyle())

        Button {} label: {
            Text("Test")
                .modifier(RoundedPrimaryButtonStyle())
                .frame(height: 50)
        }
        .buttonStyle(PressEffectButtonStyle())
        .disabled(true)
    }
    .padding()
}
