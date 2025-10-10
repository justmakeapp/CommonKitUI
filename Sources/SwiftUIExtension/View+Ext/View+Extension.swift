import SwiftUI

public extension ViewModifier {
    func transform(_ body: (inout Self) -> Void) -> Self {
        var result = self

        body(&result)

        return result
    }
}

public struct BuildPlatform: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let iPad = BuildPlatform(rawValue: 1 << 0)
    public static let iPhone = BuildPlatform(rawValue: 1 << 1)
    public static let mac = BuildPlatform(rawValue: 1 << 2)
    public static let macCatalyst = BuildPlatform(rawValue: 1 << 3)
}

public extension View {
    @ViewBuilder
    func buildView(
        for platforms: BuildPlatform,
        @ViewBuilder content: () -> some View
    ) -> some View {
        #if os(iOS)
            #if targetEnvironment(macCatalyst)
                if platforms.contains(.macCatalyst) {
                    content()
                }
            #else
                let ipad = platforms.contains(.iPad) && UIDevice.current.userInterfaceIdiom == .pad
                let iPhone = platforms.contains(.iPhone) && UIDevice.current.userInterfaceIdiom == .phone

                if ipad || iPhone {
                    content()
                }

            #endif
        #elseif os(macOS)
            if platforms.contains(.mac) {
                content()
            }
        #else
            fatalError("Unsupported platform")
        #endif
    }

    @ToolbarContentBuilder
    func buildToolbarContent(
        for platforms: BuildPlatform,
        @ToolbarContentBuilder content: () -> some ToolbarContent
    ) -> some ToolbarContent {
        #if os(iOS)
            #if targetEnvironment(macCatalyst)
                if platforms.contains(.macCatalyst) {
                    content()
                }
            #else
                let ipad = platforms.contains(.iPad) && UIDevice.current.userInterfaceIdiom == .pad
                let iPhone = platforms.contains(.iPhone) && UIDevice.current.userInterfaceIdiom == .phone

                if ipad || iPhone {
                    content()
                }

            #endif
        #elseif os(macOS)
            if platforms.contains(.mac) {
                content()
            }
        #else
            fatalError("Unsupported platform")
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
