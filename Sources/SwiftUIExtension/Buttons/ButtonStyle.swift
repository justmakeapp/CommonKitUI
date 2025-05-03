//
//  ButtonStyle.swift
//
//
//  Created by Long Vu on 02/09/2022.
//

import SwiftUI

public struct AnyButtonStyle: ButtonStyle {
    public typealias Body = AnyView

    private var _makeBody: (Configuration) -> AnyView

    public init(style: some ButtonStyle) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    public func makeBody(configuration: Configuration) -> AnyView {
        _makeBody(configuration)
    }
}

public extension ButtonStyle {
    func eraseToAnyButtonStyle() -> AnyButtonStyle {
        return AnyButtonStyle(style: self)
    }
}

// MARK: - PressEffectButtonStyle

public struct PressEffectButtonStyle: ButtonStyle {
    let pressedScale: CGFloat
    public init(
        pressedScale: CGFloat = 0.9
    ) {
        self.pressedScale = pressedScale
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.default, value: configuration.isPressed)
    }
}

public extension ButtonStyle where Self == PressEffectButtonStyle {
    static var pressEffect: PressEffectButtonStyle { .init() }
}
