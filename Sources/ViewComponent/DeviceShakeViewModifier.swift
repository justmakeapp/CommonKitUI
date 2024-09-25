//
//  DeviceShakeViewModifier.swift
//  CommonKitUI
//
//  Created by Long Vu on 25/9/24.
//

#if os(iOS)
    import Foundation
    import SwiftUI
    import UIKit

    extension UIDevice {
        static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
    }

    extension UIWindow {
        override open func motionEnded(_ motion: UIEvent.EventSubtype, with _: UIEvent?) {
            if motion == .motionShake {
                NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
            }
        }
    }

    // A view modifier that detects shaking and calls a function of our choosing.
    public struct DeviceShakeViewModifier: ViewModifier {
        public let action: () -> Void

        public init(action: @escaping () -> Void) {
            self.action = action
        }

        public func body(content: Content) -> some View {
            content
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                    action()
                }
        }
    }
#endif
