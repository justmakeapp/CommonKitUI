//
//  File.swift
//
//
//  Created by Long Vu on 29/3/24.
//

import SwiftUI

public extension Color {
    @MainActor
    init?(
        onMac: (() -> Color)? = nil,
        onPad: (() -> Color)? = nil,
        onPhone: (() -> Color)? = nil,
        onVision: (() -> Color)? = nil,
        onWatch: (() -> Color)? = nil
    ) {
        #if targetEnvironment(macCatalyst) || os(macOS)
            if let onMac {
                self = onMac()
            } else {
                return nil
            }
        #endif

        #if os(iOS)
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                if let onPad {
                    self = onPad()
                } else {
                    return nil
                }
            case .phone:
                if let onPhone {
                    self = onPhone()
                } else {
                    return nil
                }
            default:
                return nil
            }
        #endif

        #if os(visionOS)
            if let onVision {
                self = onVision()
            } else {
                return nil
            }
        #endif

        #if os(watchOS)
            if let onWatch {
                self = onWatch()
            } else {
                return nil
            }
        #endif
    }
}
