//
//  FoldSideBackground.swift
//  CommonKitUI
//
//  Created by Claude on 31/10/2026.
//

import SwiftUI

/// Paints the leading (or top) side of a partly folded iPhone Duo up to the hinge. A pane's own background
/// stops where the fold starts, which puts the color edge beside the hinge, not on it.
public struct FoldSideBackground: View {
    let color: Color
    /// Whether the fold runs top to bottom, with the panes side by side; otherwise they sit above and below it.
    let sideBySide: Bool

    /// - Parameters:
    ///   - color: the leading (or top) side's color.
    ///   - sideBySide: whether the fold runs top to bottom, with the panes side by side.
    public init(_ color: Color, sideBySide: Bool) {
        self.color = color
        self.sideBySide = sideBySide
    }

    public var body: some View {
        GeometryReader { proxy in
            if let fold = ActiveDivision.activeFrame(in: proxy) {
                let side = sideBySide
                    ? CGRect(x: 0, y: 0, width: fold.midX, height: proxy.size.height)
                    : CGRect(x: 0, y: 0, width: proxy.size.width, height: fold.midY)
                color
                    .frame(width: side.width, height: side.height)
                    .position(x: side.midX, y: side.midY)
            }
        }
        .ignoresSafeArea()
    }
}
