//
//  FeedbackManager.swift
//
//
//  Created by Long Vu on 15/07/2023.
//

import Foundation
#if os(iOS)
    import UIKit
#endif
#if os(macOS)
    import AppKit
#endif

public enum FeedbackManager {
    @MainActor
    public static func selectionChangedFeedback() {
        #if os(iOS)
            UISelectionFeedbackGenerator().selectionChanged()
        #endif
        #if os(macOS)
            NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)
        #endif
    }
}
