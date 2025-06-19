//
//  Animation+Ext.swift
//  CommonKitUI
//
//  Created by Long Vu on 19/6/25.
//

import SwiftUI

public extension Animation {
    func `repeat`(while expression: Bool, autoreverses: Bool = true) -> Animation {
        if expression {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
