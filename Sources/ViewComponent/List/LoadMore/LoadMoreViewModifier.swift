//
//  LoadMoreViewModifier.swift
//  AppFoundation
//
//  Created by Long Vu on 12/1/25.
//

import SwiftUI

public struct LoadMoreViewModifier<T: Equatable, LoadMoreObject: LoadMore>: ViewModifier {
    let item: T
    let lastItem: T?
    var loadMoreObject: LoadMoreObject

    public init(item: T, lastItem: T?, loadMoreObject: LoadMoreObject) {
        self.item = item
        self.lastItem = lastItem
        self.loadMoreObject = loadMoreObject
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if let lastItem, lastItem == item && !loadMoreObject.reachEnd {
                    Task { @MainActor in
                        await loadMoreObject.loadMore()
                    }
                }
            }
    }
}

public struct LoadMoreIndicator: View {
    let isLoadMore: Bool
    let reachEnd: Bool
    let reachEndText: String

    public init(
        isLoadMore: Bool,
        reachEnd: Bool,
        reachEndText: String = "All out"
    ) {
        self.isLoadMore = isLoadMore
        self.reachEnd = reachEnd
        self.reachEndText = reachEndText
    }

    public var body: some View {
        if isLoadMore {
            SwiftUI.ProgressView()
                .padding()
        } else if reachEnd {
            Text(reachEndText)
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}
