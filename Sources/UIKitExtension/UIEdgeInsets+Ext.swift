//
//  UIEdgeInsets+Ext.swift
//
//
//  Created by Long Vu on 08/12/2023.
//

#if canImport(UIKit) && canImport(SwiftUI)
    import SwiftUI
    import UIKit

    public extension UIEdgeInsets {
        var edgeInsets: EdgeInsets {
            EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
        }
    }
#endif
