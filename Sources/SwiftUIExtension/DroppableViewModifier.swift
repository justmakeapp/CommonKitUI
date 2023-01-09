//
//  DroppableViewModifier.swift
//
//
//  Created by Kim Anh on 22/10/2022.
//

import SwiftUI
import UniformTypeIdentifiers

public struct DroppableViewModifier: ViewModifier {
    private let isDisabled: Bool
    private let supportedContentTypes: [UTType]
    private var dropDelegate: DropDelegate?

    public init(
        isDisabled: Bool,
        supportedContentTypes: [UTType],
        dropDelegate: DropDelegate? = nil
    ) {
        self.isDisabled = isDisabled
        self.supportedContentTypes = supportedContentTypes
        self.dropDelegate = dropDelegate
    }

    public func body(content: Content) -> some View {
        if isDisabled {
            content
        } else {
            if let dropDelegate {
                content.onDrop(of: supportedContentTypes, delegate: dropDelegate)
            } else {
                content
            }
        }
    }
}
