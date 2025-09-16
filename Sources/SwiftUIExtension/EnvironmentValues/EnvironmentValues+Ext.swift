//
//  EnvironmentValues+Ext.swift
//  PaymentKit
//
//  Created by Long Vu on 8/12/24.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry
    var safeAreaInsets: EdgeInsets = .init()

    @Entry
    var isPreview = false
}
