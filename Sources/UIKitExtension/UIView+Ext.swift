//
//  UIView+Ext.swift
//
//
//  Created by Long Vu on 18/8/24.
//

import UIKit

public extension UIView {
    var isRTL: Bool {
        return UIView.userInterfaceLayoutDirection(for: UIView().semanticContentAttribute) == .rightToLeft
    }
}
