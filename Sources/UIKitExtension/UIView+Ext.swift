//
//  UIView+Ext.swift
//
//
//  Created by Long Vu on 18/8/24.
//

#if os(iOS)
    import UIKit

    public extension UIView {
        var isRTL: Bool {
            return UIView.userInterfaceLayoutDirection(for: UIView().semanticContentAttribute) == .rightToLeft
        }
    }
#endif
