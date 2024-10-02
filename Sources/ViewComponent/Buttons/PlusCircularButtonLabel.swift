//
//  PlusCircularButtonLabel.swift
//  CommonKitUI
//
//  Created by Long Vu on 2/10/24.
//

import SwiftUI

public struct PlusCircularButtonLabel: View {
    public init() {}

    public var body: some View {
        Circle()
            .frame(width: 48, height: 48)
            .shadow(color: Constants.ColorsEffectsShadowsShadowMd02, radius: 2, x: 0, y: 2)
            .shadow(color: Constants.ColorsEffectsShadowsShadowMd01, radius: 4, x: 0, y: 4)
            .overlay {
                Image(systemName: "plus")
                    .font(.title2)
                    .modifier {
                        if #available(iOS 16.0, macOS 13.0, *) {
                            $0.fontWeight(.bold)
                        } else {
                            $0
                        }
                    }
                    .foregroundColor(.white)
                    .imageScale(.large)
            }
    }
}

private enum Constants {
    static let ColorsEffectsShadowsShadowMd02: Color = .init(red: 0.06, green: 0.09, blue: 0.16).opacity(0.06)
    static let ColorsEffectsShadowsShadowMd01: Color = .init(red: 0.06, green: 0.09, blue: 0.16).opacity(0.1)
}
