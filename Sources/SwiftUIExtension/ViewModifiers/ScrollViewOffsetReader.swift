//
//  ScrollViewOffsetReader.swift
//  CommonKitUI
//
//  Created by Long Vu on 3/10/24.
//

import Foundation
import SwiftUI

public struct ScrollViewOffsetReader: ViewModifier {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint

    public init(
        coordinateSpace: CoordinateSpace,
        position: Binding<CGPoint>
    ) {
        self.coordinateSpace = coordinateSpace
        _position = position
    }

    public func body(content: Content) -> some View {
        content
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { [$position] position in
                $position.wrappedValue = position
            }
    }

    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }

        static func reduce(value _: inout CGPoint, nextValue _: () -> CGPoint) {
            // No-op
        }
    }
}
