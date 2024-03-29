//
//  File.swift
//
//
//  Created by Long Vu on 29/3/24.
//

import SwiftUI

public extension Color {
    init?(onMac: () -> Color, onPad: () -> Color, onPhone: () -> Color) {
        #if targetEnvironment(macCatalyst) || os(macOS)
            self = onMac()
        #endif

        #if os(iOS)
            switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                self = onPad()
            case .phone:
                self = onPhone()
            default:
                return nil
            }
        #endif
    }
}
