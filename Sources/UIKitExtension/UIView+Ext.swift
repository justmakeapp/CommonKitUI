//
//  UIView+Ext.swift
//
//
//  Created by Long Vu on 18/8/24.
//

#if canImport(UIKit)
    import UIKit

    public extension UIView {
        var isRTL: Bool {
            return UIView.userInterfaceLayoutDirection(for: UIView().semanticContentAttribute) == .rightToLeft
        }
    }
#endif
