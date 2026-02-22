//
//  AnyTransition+CornerRadius.swift
//
//
//  Created by Long Vu on 08/03/2024.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var cornerRadius: Double = 0
}

public struct AnimatableRoundedRectangle: View {
    @Environment(\.cornerRadius) var cornerRadius: Double

    public init() {}

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
    }
}

struct AnimatableRoundedRectangleModifier: ViewModifier {
    var cornerRadius: Double

    func body(content: Content) -> some View {
        return content
            .environment(\.cornerRadius, cornerRadius)
    }
}

#if swift(>=6)
    extension AnimatableRoundedRectangleModifier: @preconcurrency Animatable {
        var animatableData: Double {
            get {
                cornerRadius
            }
            set {
                cornerRadius = newValue
            }
        }
    }
#else
    extension AnimatableRoundedRectangleModifier: Animatable {
        var animatableData: Double {
            get {
                cornerRadius
            }
            set {
                cornerRadius = newValue
            }
        }
    }
#endif

public extension AnyTransition {
    static func cornerRadius(identity: Double, active: Double) -> AnyTransition {
        AnyTransition.modifier(
            active: AnimatableRoundedRectangleModifier(cornerRadius: active),
            identity: AnimatableRoundedRectangleModifier(cornerRadius: identity)
        )
    }
}
