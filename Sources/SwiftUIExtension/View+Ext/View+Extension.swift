import SwiftUI

public extension ViewModifier {
    func transform(_ body: (inout Self) -> Void) -> Self {
        var result = self

        body(&result)

        return result
    }
}

public extension View {
    @ViewBuilder
    func buildView(
        @ViewBuilder macBuilder: () -> some View,
        @ViewBuilder nonMacBuilder: () -> some View
    ) -> some View {
        #if targetEnvironment(macCatalyst) || os(macOS)
            macBuilder()
        #else
            nonMacBuilder()
        #endif
    }

    @ViewBuilder
    func buildView(
        @ViewBuilder onMac: () -> some View,
        @ViewBuilder onPad: () -> some View,
        @ViewBuilder onPhone: () -> some View
    ) -> some View {
        #if targetEnvironment(macCatalyst) || os(macOS)
            onMac()
        #endif

        #if os(iOS)
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                onPad()
            case .phone:
                onPhone()
            default:
                EmptyView()
            }
        #endif
    }

    @ViewBuilder
    func buildPadView(
        @ViewBuilder viewBuilder: () -> some View
    ) -> some View {
        #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .pad {
                viewBuilder()
            }
        #endif
    }

    @ViewBuilder
    func buildPhoneView(
        @ViewBuilder viewBuilder: () -> some View
    ) -> some View {
        #if os(iOS)
            if UIDevice.current.userInterfaceIdiom == .phone {
                viewBuilder()
            }
        #endif
    }

    @ViewBuilder
    func buildPhoneAndPadView(
        @ViewBuilder viewBuilder: () -> some View
    ) -> some View {
        #if os(iOS) && !targetEnvironment(macCatalyst)
            viewBuilder()
        #endif
    }

    @ViewBuilder
    func buildMacView(
        @ViewBuilder viewBuilder: () -> some View
    ) -> some View {
        #if targetEnvironment(macCatalyst) || os(macOS)
            viewBuilder()
        #endif
    }

    @ViewBuilder
    func buildNonMacView(
        @ViewBuilder viewBuilder: () -> some View
    ) -> some View {
        #if !targetEnvironment(macCatalyst) && !os(macOS)
            viewBuilder()
        #endif
    }
}

public extension View {
    func transform(_ body: (inout Self) -> Void) -> Self {
        var result = self

        body(&result)

        return result
    }

    @ViewBuilder
    func `if`(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> some View
    ) -> some View {
        if condition { transform(self) }
        else { self }
    }

    /**
     View modifier to conditionally add a view modifier else add a different one.

     [Five Stars](https://fivestars.blog/swiftui/conditional-modifiers.html)
     */
    @ViewBuilder
    func `if`(
        _ condition: Bool,
        @ViewBuilder _ ifTransform: (Self) -> some View,
        @ViewBuilder else elseTransform: (Self) -> some View
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }

    func readSize(_ size: Binding<CGSize>) -> some View {
        modifier(SizeReader(size: size))
    }

    func readSize(onChange: @MainActor @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self) { size in
            Task { @MainActor in
                onChange(size)
            }
        }
    }
}

public extension View {
    /// Modify a view with a `ViewBuilder` closure.
    ///
    /// This represents a streamlining of the
    /// [`modifier`](https://developer.apple.com/documentation/swiftui/view/modifier(_:))
    /// \+ [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier)
    /// pattern.
    /// - Note: Useful only when you don't need to reuse the closure.
    /// If you do, turn the closure into an extension! ♻️
    func modifier<ModifiedContent: View>(
        @ViewBuilder body: (_ content: Self) -> ModifiedContent
    ) -> ModifiedContent {
        body(self)
    }
}

public extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    ///     Text("Label")
    ///         .isHidden(true)
    ///
    /// Example for complete removal:
    ///
    ///     Text("Label")
    ///         .isHidden(true, remove: true)
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

// MARK: - Gesture

public extension View {
    @ViewBuilder
    func simultaneousGesture(_ gesture: some Gesture, enabled: Bool) -> some View {
        if enabled {
            simultaneousGesture(
                gesture
            )
        } else {
            self
        }
    }
}

private struct SizeReader: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self) { proxy in
                proxy.size
            } action: { newVal in
                size = newVal
            }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}
