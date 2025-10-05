//
//  NavigationSubtitleModifier.swift
//  CommonKitUI
//
//  Created by Long Vu on 5/10/25.
//

import SwiftUI

public struct NavigationSubtitleModifier: ViewModifier {
    let subtitle: String?

    public init(_ subtitle: String?) {
        self.subtitle = subtitle
    }

    public func body(content: Content) -> some View {
        content
        #if os(iOS) || os(macOS)
        .modifier {
            if #available(iOS 26.0, macOS 26.0, *), let subtitle {
                $0.navigationSubtitle(subtitle)
            } else {
                $0
            }
        }
        #endif
    }
}

#Preview {
    NavigationStack {
        Text("Hello, World!")
            .modifier(NavigationSubtitleModifier("Hello"))
    }
}
