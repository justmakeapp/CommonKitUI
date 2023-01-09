//
//  Binding+Extension.swift
//  Loop
//
//  Created by longvu on 05/03/2022.
//

import Foundation
import SwiftUI

public extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
