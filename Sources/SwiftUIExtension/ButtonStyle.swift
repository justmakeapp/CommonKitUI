//
//  File.swift
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
