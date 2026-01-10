//
//  DefaultTextFieldStyle.swift
//  CommonKitUI
//
//  Created by Long Vu on 10/1/26.
//

import SwiftUI

public struct DefaultTextFieldStyle: ViewModifier {
    let strokeColor: Color

    public init(strokeColor: Color) {
        self.strokeColor = strokeColor
    }

    public func body(content: Content) -> some View {
        content
            .font(.body)
        #if os(macOS)
            .textFieldStyle(.plain)
        #endif
            .padding(.horizontal, 12)
            .frame(height: CGFloat(46).scaledToMac())
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: {
                    if #available(iOS 26.0, macOS 26.0, *) {
                        CGFloat(46).scaledToMac() / 2
                    } else {
                        CGFloat(10).onMac(7)
                    }
                }())
                    .modifier {
                        #if os(macOS)
                            $0.strokeBorder(strokeColor, lineWidth: 1)
                        #endif

                        #if os(iOS)
                            $0.stroke(strokeColor, lineWidth: 1)
                        #endif
                    }
            }
    }
}

private extension CGFloat {
    func scaledToMac() -> CGFloat {
        #if targetEnvironment(macCatalyst) || os(macOS)
            return ceil(self * 0.765)
        #else
            return self
        #endif
    }

    func onMac(_ value: CGFloat) -> CGFloat {
        #if targetEnvironment(macCatalyst) || os(macOS)
            return value
        #else
            return self
        #endif
    }
}
