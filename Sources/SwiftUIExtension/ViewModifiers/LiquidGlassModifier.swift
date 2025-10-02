//
//  LiquidGlassModifier.swift
//  CommonKitUI
//
//  Created by Long Vu on 2/10/25.
//
//  Credit: https://github.com/rryam/LiquidGlasKit/blob/main/Sources/LiquidGlasKit/GlassEffect.swift

import SwiftUI

/// Defines the possible glass effect variants.
///
/// Glass effects provide different levels of transparency and interactivity,
/// allowing for various visual styles in your user interface.
public enum GlassEffect {
    /// A clear glass effect with minimal visual impact.
    case clear

    /// A regular glass effect with standard opacity and blur.
    case regular

    /// A clear glass effect that responds to user interaction.
    case clearInteractive

    /// A regular glass effect that responds to user interaction.
    case regularInteractive
}

/// Represents the available shapes that can be applied to a glass effect.
public enum GlassShape: Equatable {
    /// No specific shape.
    /// Defaults to a container-relative shape (adapts based on container's style).
    case none

    /// A standard rectangle shape.
    case rect

    /// A rounded rectangle shape with a specified corner radius.
    /// - Parameter cornerRadius: The radius to apply to each corner.
    case roundedRect(cornerRadius: CGFloat)

    /// A concentric shape (new in iOS 26).
    /// Falls back to a rounded rectangle with radius `26.0` on older versions.
    case concentric

    /// A capsule shape (pill-like, stretched to container dimensions).
    case capsule

    /// A circle shape (forces equal width and height).
    case circle

    /// Returns the corresponding SwiftUI `Shape` for the enum case.
    var shape: any Shape {
        switch self {
        case .none:
            // Adapts to the container's relative shape
            return .containerRelative

        case .rect:
            return .rect

        case let .roundedRect(cornerRadius):
            return .rect(cornerRadius: cornerRadius)

        case .concentric:
            #if compiler(>=6.2)
                if #available(iOS 26.0, macOS 26.0, watchOS 26.0, *) {
                    // Uses the new concentric corners API
                    return .rect(corners: .concentric, isUniform: true)
                } else {
                    // Fallback to rounded rect for older iOS
                    return .rect(cornerRadius: 26.0)
                }
            #else
                // Fallback to rounded rect for older iOS
                return .rect(cornerRadius: 26.0)
            #endif

        case .capsule:
            return .capsule

        case .circle:
            return .circle
        }
    }
}

/// A modifier that applies a glass effect with optional corner radius and tint.
///
/// This modifier provides the implementation for the glass effect functionality,
/// utilizing iOS 26.0's native glass effects when available.
public struct GlassEffectModifier: ViewModifier {
    /// The type of glass effect to apply.
    let effect: GlassEffect

    /// The optional shape for the glass effect.
    let shape: GlassShape?

    /// The optional tint color for the glass effect.
    let tint: Color?

    public init(effect: GlassEffect, shape: GlassShape? = nil, tint: Color? = nil) {
        self.effect = effect
        self.shape = shape
        self.tint = tint
    }

    @ViewBuilder
    public func body(content: Content) -> some View {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, *) {
            // Choose effect type and apply modifications
            let base: Glass = {
                switch effect {
                case .clear:
                    return .clear
                case .regular:
                    return .regular
                case .clearInteractive:
                    return .clear.interactive()
                case .regularInteractive:
                    return .regular.interactive()
                }
            }()

            // Apply tint if provided
            let glassWithTint = tint != nil ? base.tint(tint!) : base

            // Apply shape if provided
            if let shape, shape != .none {
                content.glassEffect(glassWithTint, in: AnyShape(shape.shape))
                    .clipShape(AnyShape(shape.shape))
            } else {
                content.glassEffect(glassWithTint)
            }
        } else {
            content
        }
    }
}
