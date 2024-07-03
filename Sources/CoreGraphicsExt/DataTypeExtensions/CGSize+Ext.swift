//
//  CGSize+Ext.swift
//
//
//  Created by Long Vu on 3/7/24.
//

import CoreGraphics

public extension CGSize {
    init(square: CGFloat) {
        self.init(width: square, height: square)
    }
}
