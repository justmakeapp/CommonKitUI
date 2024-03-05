//
//  View+Redacted.swift
//
//
//  Created by Long Vu on 02/02/2024.
//

import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func redacted(if condition: @autoclosure () -> Bool) -> some View {
        redacted(reason: condition() ? .placeholder : [])
    }
}
