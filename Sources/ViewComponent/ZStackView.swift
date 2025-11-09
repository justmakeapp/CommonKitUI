//
//  ZStackView.swift
//
//
//  Created by Duy Truong on 01/09/2022.
//

import SwiftUI

public struct ZStackView<Item: View>: View {
    private let numberOfViews: Int
    private let itemBuilder: (_ viewIndex: Int) -> Item

    private var config: Config = .init()

    @Binding private var topItemIndex: Int

    public init(
        numberOfViews: Int,
        topItemIndex: Binding<Int>,
        @ViewBuilder itemBuilder: @escaping (_ viewIndex: Int) -> Item
    ) {
        self.numberOfViews = numberOfViews
        _topItemIndex = topItemIndex
        self.itemBuilder = itemBuilder
    }

    public var body: some View {
        ZStack(alignment: .top) {
            ForEach(0 ..< numberOfViews, id: \.self) { forEachIndex in
                let index = numberOfViews - 1 - forEachIndex
                if index >= topItemIndex, index < topItemIndex + config.maxVisibleItemCount {
                    itemView(at: index)
                        .modifier(ItemViewModifier()
                            .ordinalNumber(UInt8(index - topItemIndex))
                            .itemSpacing(config.itemSpacing))
                }
            }
        }
    }

    @ViewBuilder
    private func itemView(at index: Int) -> some View {
        itemBuilder(index)
            .zIndex(index == topItemIndex ? 1 : 0)
            .disabled(index != topItemIndex)
    }
}

// MARK: - ItemViewModifier

private struct ItemViewModifier: ViewModifier {
    @State private var height: CGFloat = 0
    private var config = Configuration()

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { newValue in
                height = newValue
            })
            .scaleEffect(scaledFactor)
            .offset(offset)
            .animation(.linear, value: scaledFactor)
            .animation(.linear, value: offset)
    }

    private var seed: CGFloat {
        if height == 0 {
            0.12
        } else {
            (height + config.itemSpacing) / height - 1
        }
    }

    private var scaledFactor: CGFloat {
        let ordinalNumber = CGFloat(config.ordinalNumber)

        let factor: CGFloat = 1 - ordinalNumber * seed

        return factor
    }

    private var offset: CGSize {
        let width: CGFloat = 0
        let lossHeight = height * (1 - scaledFactor)
        let height: CGFloat = -lossHeight
        return .init(width: width, height: height)
    }

    // MARK: - ItemViewModifier API

    private struct Configuration {
        var ordinalNumber: UInt8 = 0
        var itemSpacing: CGFloat = 30
    }

    func ordinalNumber(_ value: UInt8) -> Self {
        transform { $0.config.ordinalNumber = value }
    }

    func itemSpacing(_ value: CGFloat) -> Self {
        transform { $0.config.itemSpacing = value }
    }
}

private extension CGSize {
    func insetBy(dw: CGFloat, dh: CGFloat) -> Self {
        return .init(width: width - dw, height: height - dh)
    }
}

// MARK: - API

public extension ZStackView {
    struct Config {
        var maxVisibleItemCount = 3
        var itemSpacing: CGFloat = 30
    }

    func maxVisibleItemCount(_ value: Int) -> Self {
        transform { $0.config.maxVisibleItemCount = value }
    }

    func itemSpacing(_ value: CGFloat) -> Self {
        transform { $0.config.itemSpacing = value }
    }
}

// #Preview {
//    @Previewable @State var currentIndex = 0
//
//    ZStackView(
//        numberOfViews: 10,
//        topItemIndex: $currentIndex
//    ) { index in
//        VStack {
//            Text("\(index)")
//
//            Button("Next") {
//                currentIndex = index + 1
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .frame(minHeight: currentIndex == 0 ? 200 : 350)
//        .background(.background.secondary)
//        .shadow(radius: 3)
//    }
//    .itemSpacing(30)
//    .padding(.horizontal)
// }
