//
//  File.swift
//
//
//  Created by Long Vu on 08/12/2023.
//

import SwiftUI
import UIKitExtension
#if canImport(UIKit)
    import UIKit
#endif

public extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        #if canImport(UIKit)
            let keyWindow = UIApplication.shared.activeKeyWindow
            return keyWindow?.safeAreaInsets.edgeInsets ?? EdgeInsets()
        #else
            EdgeInsets()
        #endif
    }
}
