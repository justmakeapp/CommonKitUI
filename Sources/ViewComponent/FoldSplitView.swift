//
//  FoldSplitView.swift
//  CommonKitUI
//
//  Created by Claude on 01/11/2026.
//

import SwiftUI

/// Two panes on either side of a partly folded iPhone Duo's hinge, which `ArrangementView` keeps them clear of, with
/// the primary pane's background running up to the hinge. Before iOS 27.1, which reports no folds, and off iOS, the
/// panes sit side by side.
public struct FoldSplitView<Primary: View, Secondary: View>: View {
    private let sideBySide: Bool
    private let primaryBackground: Color
    private let primary: Primary
    private let secondary: Secondary

    /// - Parameters:
    ///   - sideBySide: whether the fold runs top to bottom, with the panes side by side; otherwise they sit above and
    ///     below it.
    ///   - primaryBackground: the primary pane's background, painted up to the hinge.
    public init(
        sideBySide: Bool,
        primaryBackground: Color,
        @ViewBuilder primary: () -> Primary,
        @ViewBuilder secondary: () -> Secondary
    ) {
        self.sideBySide = sideBySide
        self.primaryBackground = primaryBackground
        self.primary = primary()
        self.secondary = secondary()
    }

    public var body: some View {
        #if os(iOS) && canImport(SwiftUI, _version: 8.0.85)
            // The iOS 27.1 SDK (SwiftUI 8.0.85) is the first with ArrangementView.
            if #available(iOS 27.1, *) {
                ArrangementView {
                    primary
                } secondary: {
                    secondary
                }
                .arrangementViewStyle(.split)
                .background {
                    FoldSideBackground(primaryBackground, sideBySide: sideBySide)
                }
            } else {
                sideBySideFallback
            }
        #else
            sideBySideFallback
        #endif
    }

    private var sideBySideFallback: some View {
        HStack(spacing: 0) {
            primary

            secondary
        }
    }
}
