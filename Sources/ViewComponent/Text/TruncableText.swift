//
//  TruncableText.swift
//
//
//  Created by Duy Truong on 10/23/2022.
//

import SwiftUI

public struct TruncableText: View {
    private let text: Text
    private let lineLimit: Int?
    @State private var intrinsicSize: CGSize
    @State private var truncatedSize: CGSize
    private let isTruncatedUpdate: (_ isTruncated: Bool) -> Void

    public init(
        text: Text,
        lineLimit: Int?,
        intrinsicSize: CGSize = .zero,
        truncatedSize: CGSize = .zero,
        isTruncatedUpdate: @escaping (_ isTruncated: Bool) -> Void
    ) {
        self.text = text
        self.lineLimit = lineLimit
        self.intrinsicSize = intrinsicSize
        self.truncatedSize = truncatedSize
        self.isTruncatedUpdate = isTruncatedUpdate
    }

    public var body: some View {
        text
            .lineLimit(lineLimit)
            .readSize { size in
                truncatedSize = size
                isTruncatedUpdate(truncatedSize != intrinsicSize)
            }
            .background(
                text
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .readSize { size in
                        intrinsicSize = size
                        isTruncatedUpdate(truncatedSize != intrinsicSize)
                    }
            )
    }
}
