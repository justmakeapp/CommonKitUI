//
//  AnyTransition+Ext.swift
//
//
//  Created by Long Vu on 08/03/2024.
//

import Foundation
import SwiftUI

public struct CornerRadiusKey: EnvironmentKey {
    public static let defaultValue: Double = 0
}

extension EnvironmentValues {
    var cornerRadius: Double {
        get { return self[CornerRadiusKey.self] }
        set { self[CornerRadiusKey.self] = newValue }
    }
}

public struct AnimatableRoundedRectangle: View {
    @Environment(\.cornerRadius) var cornerRadius: Double

    public init() {}

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
}

struct AnimatableRoundedRectangleModifier: ViewModifier, Animatable {
    var cornerRadius: Double

    var animatableData: Double {
        get { cornerRadius }
        set { cornerRadius = newValue }
    }

    func body(content: Content) -> some View {
        return content
            .environment(\.cornerRadius, cornerRadius)
    }
}

public extension AnyTransition {
    static func cornerRadius(identity: Double, active: Double) -> AnyTransition {
        AnyTransition.modifier(
            active: AnimatableRoundedRectangleModifier(cornerRadius: active),
            identity: AnimatableRoundedRectangleModifier(cornerRadius: identity)
        )
    }
}
