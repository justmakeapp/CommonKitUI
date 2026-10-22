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
    ///
    /// ```
    /// Vertical division         Horizontal division
    /// +----------+--+-------+   +---------------------+
    /// |          |//|       |   |         top         |
    /// |          |//|       |   |/////////////////////|
    /// |  result  |//|       |   |                     |
    /// |          |//|       |   |       result        |
    /// |          |//|       |   |                     |
    /// +----------+--+-------+   +---------------------+
    /// ```
    ///
    /// `/` marks the division; `result` is the returned rect.
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

    /// The first active division in `proxy`'s coordinates, or `nil` before iOS 27.1 or without one.
    public static func activeFrame(in proxy: GeometryProxy) -> CGRect? {
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
    private let isEnabled: Bool

    /// - Parameter isEnabled: false fills the whole area even with a division; the content keeps its identity.
    public init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }

    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            let side = sideRect(in: proxy)
            content
                .frame(width: side.width, height: side.height)
                .position(x: side.midX, y: side.midY)
        }
    }

    private func sideRect(in proxy: GeometryProxy) -> CGRect {
        ActiveDivision.largerSide(of: CGRect(origin: .zero, size: proxy.size), division: activeDivision(in: proxy))
    }

    private func activeDivision(in proxy: GeometryProxy) -> CGRect? {
        guard isEnabled else { return nil }
        return ActiveDivision.activeFrame(in: proxy)
    }
}

public extension View {
    /// Keeps the view wholly on the larger side of an active display division, such as a partly folded
    /// iPhone Duo. Without one, the view fills the available area.
    func avoidingActiveDivision(isEnabled: Bool = true) -> some View {
        modifier(ActiveDivisionAvoidanceModifier(isEnabled: isEnabled))
    }
}
