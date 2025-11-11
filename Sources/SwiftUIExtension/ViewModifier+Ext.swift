//
//  ViewModifier+Ext.swift
//  CommonKitUI
//
//  Created by Long Vu on 11/11/25.
//

import SwiftUI

public extension ViewModifier {
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
        #elseif os(watchOS)
            if platforms.contains(.watch) {
                content()
            }
        #else
            fatalError("Unsupported platform")
        #endif
    }
}
