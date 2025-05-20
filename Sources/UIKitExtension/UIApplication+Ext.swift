//
//  UIApplication+Ext.swift
//
//
//  Created by Long Vu on 08/12/2023.
//

#if os(iOS)
    import UIKit

    public extension UIApplication {
        var activeKeyWindow: UIWindow? {
            connectedScenes
                // I disabled this because it return nil if the app is in background then comeback and expect to have a
                // key window
                // .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .filter(\.isKeyWindow)
                .first
        }

        @available(macCatalystApplicationExtension, unavailable)
        @available(iOSApplicationExtension, unavailable)
        @available(tvOSApplicationExtension, unavailable)
        var topmostViewController: UIViewController? {
            UIApplication.shared.activeKeyWindow?.rootViewController?.topmostViewController
        }
    }
#endif
