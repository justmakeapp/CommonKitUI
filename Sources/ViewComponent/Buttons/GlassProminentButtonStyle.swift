//
//  GlassProminentButtonStyle.swift
//  CommonKitUI
//
//  Created by Claude on 01/11/2026.
//

import SwiftUI
import SwiftUIExtension

public extension View {
    /// A primary button's style: glass prominent from iOS 26 and macOS 26, bordered prominent before it (and on
    /// visionOS, which has no glass prominent), in a capsule either way.
    func glassProminentButtonStyle() -> some View {
        #if os(visionOS)
            buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
        #else
            modifier {
                if #available(iOS 26.0, macOS 26.0, watchOS 26.0, *) {
                    $0.buttonStyle(.glassProminent)
                } else {
                    $0.buttonStyle(.borderedProminent)
                }
            }
            .buttonBorderShape(.capsule)
        #endif
    }
}
