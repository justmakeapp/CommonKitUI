//
//  File.swift
//
//
//  Created by longvu on 27/03/2024.
//

import SwiftUI

public extension ToolbarContent {
    //	@available(iOS 16.0, *)
    //	@ToolbarContentBuilder
    //	func buildPadToolbarItem(
    //		@ToolbarContentBuilder builder: () -> some ToolbarContent
    //	) -> some ToolbarContent {
    // #if os(iOS)
    //			if UIDevice.current.userInterfaceIdiom == .pad {
    //				builder()
    //			}
    // #endif
    //	}

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
    func buildMacView(
        @ViewBuilder viewBuilder: () -> some View
    ) -> some View {
        #if targetEnvironment(macCatalyst) || os(macOS)
            viewBuilder()
        #endif
    }
}
