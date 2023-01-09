//
//  File.swift
//
//
//  Created by Long Vu on 13/12/2022.
//

#if os(iOS)
    import UIKit

    public extension NSDirectionalEdgeInsets {
        init(_ value: CGFloat) {
            self.init(top: value, leading: value, bottom: value, trailing: value)
        }
    }

#endif
