//
//  RoundedPrimaryButtonStyle.swift
//  CommonKitUI
//
//  Created by Long Vu on 3/5/25.
//

import SwiftUI

public struct RoundedPrimaryButtonStyle: ViewModifier {
    public var cornerRadius: CGFloat

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
    }
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
