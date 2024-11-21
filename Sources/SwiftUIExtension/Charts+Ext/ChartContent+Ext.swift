//
//  ChartContent+Ext.swift
//  CommonKitUI
//
//  Created by Long Vu on 21/11/24.
//

import Charts
import SwiftUI

@available(iOS 16.0, macOS 13.0, *)
public extension ChartContent {
    func modifier<ModifiedContent: ChartContent>(
        @ChartContentBuilder body: (_ content: Self) -> ModifiedContent
    ) -> ModifiedContent {
        body(self)
    }
}
