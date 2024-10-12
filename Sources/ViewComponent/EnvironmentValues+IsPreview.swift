//
//  EnvironmentValues+IsPreview.swift
//  CommonKitUI
//
//  Created by Long Vu on 12/10/24.
//

import SwiftUI

private struct IsPreviewKey: EnvironmentKey {
    static let defaultValue = false
}

public extension EnvironmentValues {
    var isPreview: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }
}
