//
//  HiddenNavigationBarHostingViewController.swift
//
//
//  Created by longvu on 19/07/2022.
//

#if os(iOS)
    import SwiftUI
    import UIKit

    public class HiddenNavigationBarHostingViewController<V: View>: UIHostingController<V> {
        override public func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: false)
        }

        override public func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
#endif
