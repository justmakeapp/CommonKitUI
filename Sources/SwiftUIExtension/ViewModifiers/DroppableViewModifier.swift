//
//  DroppableViewModifier.swift
//
//
//  Created by Kim Anh on 22/10/2022.
//

import SwiftUI
import UniformTypeIdentifiers

#if os(iOS) || os(macOS)
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

    @available(iOS 16.0, macOS 13.0, *)
    public struct TransferableDroppableViewModifier<T: Transferable>: ViewModifier {
        @State private var isTargeted = false

        let payloadType: T.Type
        let disabled: Bool
        let action: (_ items: [T], _ location: CGPoint) -> Bool

        public init(
            for payloadType: T.Type,
            disabled: Bool = false,
            action: @escaping (_ items: [T], _ location: CGPoint) -> Bool
        ) {
            self.payloadType = payloadType
            self.disabled = disabled
            self.action = action
        }

        public func body(content: Content) -> some View {
            if disabled {
                content
            } else {
                content
                    .dropDestination(for: payloadType, action: action, isTargeted: {
                        self.isTargeted = $0
                    })
                    .overlay {
                        if isTargeted {
                            ZStack {
                                Color.black.opacity(0.5)

                                DroppableView()
                            }
                        }
                    }
                    .animation(.default, value: isTargeted)
            }
        }
    }

    private struct DroppableView: View {
        var body: some View {
            VStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                Text("Drop your item here...")
            }
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.white)
            .frame(maxWidth: 250)
            .multilineTextAlignment(.center)
        }
    }

#endif
