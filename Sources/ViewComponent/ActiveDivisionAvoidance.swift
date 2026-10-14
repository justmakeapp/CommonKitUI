//
//  ActiveDivisionAvoidance.swift
//  CommonKitUI
//
//  Created by Claude on 13/10/2026.
//

import SwiftUI

/// Geometry for keeping content off an active display division (the fold of a partly folded iPhone Duo).
public enum ActiveDivision {
    /// The part of `bounds` on the larger side of `division`.
    ///
    /// A division taller than it is wide splits `bounds` into leading and trailing sides; otherwise into top and
    /// bottom. Ties go to the leading (or top) side. Returns `bounds` when there is no active division (`nil`) or it
    /// doesn't overlap `bounds`.
    public static func largerSide(of bounds: CGRect, division: CGRect?) -> CGRect {
        guard let division else { return bounds }
        let overlap = bounds.intersection(division)
        guard !overlap.isNull, !overlap.isEmpty else { return bounds }

        if division.height > division.width {
            let leadingWidth = overlap.minX - bounds.minX
            let trailingWidth = bounds.maxX - overlap.maxX
            return leadingWidth >= trailingWidth
                ? CGRect(x: bounds.minX, y: bounds.minY, width: leadingWidth, height: bounds.height)
                : CGRect(x: overlap.maxX, y: bounds.minY, width: trailingWidth, height: bounds.height)
        } else {
            let topHeight = overlap.minY - bounds.minY
            let bottomHeight = bounds.maxY - overlap.maxY
            return topHeight >= bottomHeight
                ? CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: topHeight)
                : CGRect(x: bounds.minX, y: overlap.maxY, width: bounds.width, height: bottomHeight)
        }
    }

    /// Leading and trailing insets that keep `bounds` on the larger side of a side-by-side division.
    ///
    /// Only a division taller than it is wide counts, and only its horizontal extent: content in a vertical scroll
    /// view passes a top-and-bottom fold as it scrolls, so it moves aside only for a leading-and-trailing one.
    /// Returns zero insets when there is no such division (`nil`) or it doesn't overlap `bounds` horizontally.
    public static func horizontalInsets(of bounds: CGRect, division: CGRect?) -> EdgeInsets {
        guard let division, division.height > division.width else { return EdgeInsets() }
        let band = CGRect(x: bounds.minX, y: division.minY, width: bounds.width, height: division.height)
        let side = largerSide(of: band, division: division)
        return EdgeInsets(top: 0, leading: side.minX - bounds.minX, bottom: 0, trailing: bounds.maxX - side.maxX)
    }

    /// The first active division in `proxy`'s coordinates, or `nil` before iOS 27.1 or without one.
    static func activeFrame(in proxy: GeometryProxy) -> CGRect? {
        #if os(iOS) && canImport(SwiftUI, _version: 8.0.85)
            // The iOS 27.1 SDK (SwiftUI 8.0.85) is the first with reserved regions.
            if #available(iOS 27.1, *) {
                return proxy.reservedRegions(kind: .division).first(where: \.isActive)?.frame
            }
        #endif
        return nil
    }
}

/// Fills the available area, or only its larger side while a display division is active (iOS 27.1+).
///
/// Only the frame and position change, so the content keeps its identity and state across a fold.
public struct ActiveDivisionAvoidanceModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            let side = sideRect(in: proxy)
            content
                .frame(width: side.width, height: side.height)
                .position(x: side.midX, y: side.midY)
        }
    }

    private func sideRect(in proxy: GeometryProxy) -> CGRect {
        ActiveDivision.largerSide(
            of: CGRect(origin: .zero, size: proxy.size),
            division: ActiveDivision.activeFrame(in: proxy)
        )
    }
}

/// Pads the content to the larger side of an active side-by-side division (iOS 27.1+), without taking the
/// proposed size the way `ActiveDivisionAvoidanceModifier`'s `GeometryReader` does.
///
/// For content that sizes itself, such as a column in a vertical scroll view or a self-sizing collection view
/// cell. The content must fill the proposed width (`.frame(maxWidth: .infinity)`), so the padding narrows what is
/// inside it rather than the measured frame. Only the padding changes, so the content keeps its identity and state
/// across a fold.
public struct ActiveDivisionInsetModifier: ViewModifier {
    @State private var insets = EdgeInsets()

    public init() {}

    public func body(content: Content) -> some View {
        content
            .padding(insets)
            // Measures the padded view, whose width the padding doesn't change, so the insets can't feed back.
            .onGeometryChange(for: EdgeInsets.self) { proxy in
                ActiveDivision.horizontalInsets(
                    of: CGRect(origin: .zero, size: proxy.size),
                    division: ActiveDivision.activeFrame(in: proxy)
                )
            } action: { newInsets in
                insets = newInsets
            }
    }
}

public extension View {
    /// Keeps the view wholly on the larger side of an active display division, such as a partly folded
    /// iPhone Duo. Without one, the view fills the available area.
    func avoidingActiveDivision() -> some View {
        modifier(ActiveDivisionAvoidanceModifier())
    }

    /// Insets the view to the larger side of an active side-by-side display division, such as an iPhone Duo
    /// partly folded like a book. Without one, the view is unchanged.
    func insettingFromActiveDivision() -> some View {
        modifier(ActiveDivisionInsetModifier())
    }
}
