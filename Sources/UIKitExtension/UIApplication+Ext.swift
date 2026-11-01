//
//  UIApplication+Ext.swift
//
//
//  Created by Long Vu on 08/12/2023.
//

#if os(iOS)
    import UIKit

    public extension UIApplication {
        /// The key window of the frontmost scene. With more than one window, each scene has a key window, so the one
        /// in the active scene wins. Any key window is the fallback: just after the app returns from the background,
        /// no scene is active yet.
        var activeKeyWindow: UIWindow? {
            #if targetEnvironment(macCatalyst)
                // On the Mac every visible scene stays foreground active, so the scene's state can't tell which
                // window is in front. The app-wide key window, the one macOS made key, can. It's read through KVC:
                // the property is deprecated for its iOS meaning, not on the Mac.
                if let keyWindow = value(forKey: "keyWindow") as? UIWindow {
                    return keyWindow
                }
            #endif
            let keyWindows = connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .filter(\.isKeyWindow)
            return keyWindows.first { $0.windowScene?.activationState == .foregroundActive } ?? keyWindows.first
        }

        @available(macCatalystApplicationExtension, unavailable)
        @available(iOSApplicationExtension, unavailable)
        @available(tvOSApplicationExtension, unavailable)
        var topmostViewController: UIViewController? {
            UIApplication.shared.activeKeyWindow?.rootViewController?.topmostViewController
        }
    }
#endif
