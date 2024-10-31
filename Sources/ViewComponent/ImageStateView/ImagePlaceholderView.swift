//
//  ImagePlaceholderView.swift
//  CommonKitUI
//
//  Created by Long Vu on 31/10/24.
//

import SwiftUI

public struct ImagePlaceholderView: View {
    public init() {}

    public var body: some View {
        Rectangle()
            .fill(Color.clear)
            .overlay {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundStyle(.tertiary)
                    .modifier {
                        if #available(iOS 17.0, macOS 14.0, *) {
                            $0
                                .symbolEffect(.pulse)
                        } else {
                            $0
                        }
                    }
            }
    }
}

#Preview {
    ImagePlaceholderView()
}
