//
//  ShareSheetView.swift
//  CommonKitUI
//
//  Created by Long Vu on 28/9/24.
//

import SwiftUI
#if canImport(UIKit)
    import UIKit
#endif

#if canImport(UIKit)
    public struct ShareSheetView: UIViewControllerRepresentable {
        public typealias Callback = (
            _ activityType: UIActivity.ActivityType?,
            _ completed: Bool,
            _ returnedItems: [Any]?,
            _ error: Error?
        ) -> Void

        let activityItems: [Any]
        let applicationActivities: [UIActivity]? = nil
        let excludedActivityTypes: [UIActivity.ActivityType]? = nil
        let callback: Callback? = nil

        public init(activityItems: [Any]) {
            self.activityItems = activityItems
        }

        public func makeUIViewController(context _: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(
                activityItems: activityItems,
                applicationActivities: applicationActivities
            )
            controller.excludedActivityTypes = excludedActivityTypes
            controller.completionWithItemsHandler = callback
            return controller
        }

        public func updateUIViewController(_: UIActivityViewController, context _: Context) {
            // nothing to do here
        }
    }
#endif
