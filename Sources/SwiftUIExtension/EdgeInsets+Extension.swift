//
//  EdgeInsets+Extension.swift
//
//
//  Created by Long Vu on 14/12/2022.
//

import SwiftUI

public extension EdgeInsets {
    init(_ value: CGFloat) {
        self.init(
            top: value,
            leading: value,
            bottom: value,
            trailing: value
        )
    }

    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(
            top: vertical,
            leading: horizontal,
            bottom: vertical,
            trailing: horizontal
        )
    }
}
