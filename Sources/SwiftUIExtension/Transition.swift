import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension AnyTransition {
    /// Fade-in transition
    static var fade: AnyTransition {
        let insertion = AnyTransition.opacity
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Fade-in transition with duration
    /// - Parameter duration: transition duration, use ease-in-out
    /// - Returns: A transition with duration
    static func fade(duration: Double) -> AnyTransition {
        let insertion = AnyTransition.opacity.animation(.easeInOut(duration: duration))
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from left transition
    static var flipFromLeft: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from left transition with duration
    /// - Parameter duration: transition duration, use ease-in-out
    /// - Returns: A transition with duration
    static func flipFromLeft(duration: Double) -> AnyTransition {
        let insertion = AnyTransition.move(edge: .leading).animation(.easeInOut(duration: duration))
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from right transition
    static var flipFromRight: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from right transition with duration
    /// - Parameter duration: transition duration, use ease-in-out
    /// - Returns: A transition with duration
    static func flipFromRight(duration: Double) -> AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing).animation(.easeInOut(duration: duration))
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from top transition
    static var flipFromTop: AnyTransition {
        let insertion = AnyTransition.move(edge: .top)
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from top transition with duration
    /// - Parameter duration: transition duration, use ease-in-out
    /// - Returns: A transition with duration
    static func flipFromTop(duration: Double) -> AnyTransition {
        let insertion = AnyTransition.move(edge: .top).animation(.easeInOut(duration: duration))
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from bottom transition
    static var flipFromBottom: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }

    /// Flip from bottom transition with duration
    /// - Parameter duration: transition duration, use ease-in-out
    /// - Returns: A transition with duration
    static func flipFromBottom(duration: Double) -> AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom).animation(.easeInOut(duration: duration))
        let removal = AnyTransition.identity
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }
}
