//
//  ActiveOcclusionAvoidance.swift
//  CommonKitUI
//
//  Created by Claude on 14/10/2026.
//

import SwiftUI

/// Geometry for keeping content out of active occlusion regions, such as the iPhone Duo's front cameras.
public enum ActiveOcclusion {
    /// The part of `bounds` left after moving in from one edge past each region it overlaps.
    ///
    /// For each region, the edge whose move keeps the largest area is taken. Ties go to top, then bottom, leading,
    /// trailing. Regions that don't overlap the remaining area are ignored, so with none the result is `bounds`.
    public static func clearRect(of bounds: CGRect, occlusions: [CGRect]) -> CGRect {
        occlusions.reduce(bounds) { rect, region in
            let overlap = rect.intersection(region)
            guard !overlap.isNull, !overlap.isEmpty else { return rect }

            let candidates = [
                CGRect(x: rect.minX, y: overlap.maxY, width: rect.width, height: rect.maxY - overlap.maxY),
                CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: overlap.minY - rect.minY),
                CGRect(x: overlap.maxX, y: rect.minY, width: rect.maxX - overlap.maxX, height: rect.height),
                CGRect(x: rect.minX, y: rect.minY, width: overlap.minX - rect.minX, height: rect.height),
            ]
            var best = candidates[0]
            for candidate in candidates.dropFirst() where area(candidate) > area(best) {
                best = candidate
            }
            return best
        }
    }

    /// Frames of the active occlusion regions that intersect `proxy`'s view, in its coordinates. Empty before
    /// iOS 27.1.
    public static func regions(in proxy: GeometryProxy) -> [CGRect] {
        #if os(iOS) && canImport(SwiftUI, _version: 8.0.85)
            // The iOS 27.1 SDK (SwiftUI 8.0.85) is the first with reserved regions.
            if #available(iOS 27.1, *) {
                return proxy.reservedRegions(kind: .occlusion).filter(\.isActive).map(\.frame)
            }
        #endif
        return []
    }

    private static func area(_ rect: CGRect) -> CGFloat {
        rect.width * rect.height
    }
}

/// Fills the available area, minus the strips that clear any active occlusion region (iOS 27.1+).
///
/// Only the frame and position change, so the content keeps its identity and state when a region turns on or off.
public struct ActiveOcclusionAvoidanceModifier: ViewModifier {
    public init() {}

    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            let rect = ActiveOcclusion.clearRect(
                of: CGRect(origin: .zero, size: proxy.size),
                occlusions: ActiveOcclusion.regions(in: proxy)
            )
            content
                .frame(width: rect.width, height: rect.height)
                .position(x: rect.midX, y: rect.midY)
        }
    }
}

public extension View {
    /// Keeps the view out of active occlusion regions, such as an iPhone Duo front camera, by moving its edge in
    /// past each one. Without one, the view fills the available area.
    ///
    /// Apply it to a container that fills the space its controls are laid out in.
    func avoidingActiveOcclusion() -> some View {
        modifier(ActiveOcclusionAvoidanceModifier())
    }
}
