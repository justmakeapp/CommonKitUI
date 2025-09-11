//
//  PrimitiveButtonStyle.swift
//  CommonKitUI
//
//  Created by Long Vu on 11/9/25.
//

import SwiftUI

public struct AnyPrimitiveButtonStyle: PrimitiveButtonStyle {
    private var _makeBody: (Configuration) -> AnyView

    public init(style: some PrimitiveButtonStyle) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    public func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

public extension PrimitiveButtonStyle {
    func eraseToAnyPrimitiveButtonStyle() -> AnyPrimitiveButtonStyle {
        return AnyPrimitiveButtonStyle(style: self)
    }
}
