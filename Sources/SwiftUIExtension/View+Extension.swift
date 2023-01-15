import SwiftUI

public extension ViewModifier {
    func then(_ body: (inout Self) -> Void) -> Self {
        var result = self

        body(&result)

        return result
    }
}

public extension View {
    @ViewBuilder
    func buildView(
        @ViewBuilder catalystBuilder: () -> some View,
        @ViewBuilder nonCatalystBuilder: () -> some View
    ) -> some View {
        #if targetEnvironment(macCatalyst)
            catalystBuilder()
        #else
            nonCatalystBuilder()
        #endif
    }

    @ViewBuilder
    func buildCatalystView(
        @ViewBuilder catalystBuilder: () -> some View
    ) -> some View {
        #if targetEnvironment(macCatalyst)
            catalystBuilder()
        #endif
    }

    @ViewBuilder
    func buildNonCatalystView(
        @ViewBuilder nonCatalystBuilder: () -> some View
    ) -> some View {
        #if !targetEnvironment(macCatalyst)
            nonCatalystBuilder()
        #endif
    }
}

public extension View {
    func padding(edgeInsets: EdgeInsets) -> some View {
        self
            .padding(.top, edgeInsets.top)
            .padding(.bottom, edgeInsets.bottom)
            .padding(.leading, edgeInsets.leading)
            .padding(.trailing, edgeInsets.trailing)
    }
}

public extension View {
    func then(_ body: (inout Self) -> Void) -> Self {
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

    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
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

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue _: () -> CGSize) {}
}
