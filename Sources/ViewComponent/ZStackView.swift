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
                        .modifier(
                            ItemViewModifier()
                                .ordinalNumber(UInt8(index - topItemIndex))
                                .itemSpacing(config.itemSpacing)
                                .cardOffset(config.cardOffset)
                                .seed(config.seed)
                        )
                }
            }
        }
    }

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
            // Note: Can not use onGeometryChange because it block fly effect of flashcard when swipe
            .readSize(onChange: { size in
                height = size.height
            })
            .scaleEffect(scaledFactor)
            .offset(offset)
            .animation(.linear, value: scaledFactor)
            .animation(.linear, value: offset)
    }

    private var seed: CGFloat {
        if let seed = config.seed {
            seed
        } else if height == 0 {
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
        config.cardOffset(
            CardOffsetInfo(
                height: height,
                ordinalNumber: config.ordinalNumber,
                itemSpacing: config.itemSpacing
            )
        )
    }

    // MARK: - ItemViewModifier API

    private struct Configuration {
        var seed: CGFloat?
        var ordinalNumber: UInt8 = 0
        var itemSpacing: CGFloat = 30
        var cardOffset: (CardOffsetInfo) -> CGSize = { _ in .zero }
    }

    func seed(_ value: CGFloat?) -> Self {
        transform { $0.config.seed = value }
    }

    func ordinalNumber(_ value: UInt8) -> Self {
        transform { $0.config.ordinalNumber = value }
    }

    func itemSpacing(_ value: CGFloat) -> Self {
        transform { $0.config.itemSpacing = value }
    }

    func cardOffset(_ value: @escaping (CardOffsetInfo) -> CGSize) -> Self {
        transform { $0.config.cardOffset = value }
    }
}

private extension CGSize {
    func insetBy(dw: CGFloat, dh: CGFloat) -> Self {
        return .init(width: width - dw, height: height - dh)
    }
}

public struct CardOffsetInfo {
    public let height: CGFloat
    public let ordinalNumber: UInt8
    public let itemSpacing: CGFloat
}

// MARK: - API

public extension ZStackView {
    struct Config {
        var seed: CGFloat? = 0.13
        var maxVisibleItemCount = 3
        var itemSpacing: CGFloat = 30
        var cardOffset: (CardOffsetInfo) -> CGSize = { input in
            let width: CGFloat = 0
            let height: CGFloat = -CGFloat(input.ordinalNumber) * input.itemSpacing
            return .init(width: width, height: height)
        }
    }

    func seed(_ value: CGFloat?) -> Self {
        transform { $0.config.seed = value }
    }

    func maxVisibleItemCount(_ value: Int) -> Self {
        transform { $0.config.maxVisibleItemCount = value }
    }

    func itemSpacing(_ value: CGFloat) -> Self {
        transform { $0.config.itemSpacing = value }
    }

    func cardOffset(_ value: @escaping (CardOffsetInfo) -> CGSize) -> Self {
        transform { $0.config.cardOffset = value }
    }
}

#if DEBUG
    private struct PreviewContentView: View {
        @State var currentIndex = 0
        @State var heightMap: [Int: CGFloat] = [:]

        var body: some View {
            if #available(iOS 17.0, macOS 14.0, watchOS 10.0, *) {
                ZStackView(
                    numberOfViews: 10,
                    topItemIndex: $currentIndex
                ) { index in
                    VStack {
                        Text("\(index)")

                        Button("Next") {
                            currentIndex = index + 1
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: {
                        switch index {
                        case 0:
                            300
                        case 1:
                            100
                        case 2:
                            200
                        default:
                            400
                        }
                    }())
                    .onGeometryChange(for: CGFloat.self, of: { $0.size.height }, action: { newValue in
                        heightMap[index] = newValue
                    })
                    .frame(height: heightMap[currentIndex, default: 0])
                    .background(.background.secondary)
                    .shadow(radius: 3)
                }
                .itemSpacing(30)
                .padding(.horizontal)
                .onChange(of: currentIndex, initial: true) { _, newValue in
                    print("Top item index: \(newValue), height: \(heightMap[newValue] ?? 0)")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }

    #Preview {
        PreviewContentView()
    }
#endif
