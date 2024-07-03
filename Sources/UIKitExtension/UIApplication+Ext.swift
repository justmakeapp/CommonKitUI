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
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .flatMap(\.windows)
                .filter(\.isKeyWindow)
                .first
        }
    }
#endif
