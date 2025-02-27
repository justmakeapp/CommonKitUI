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
    @ObservedObject var loadMoreObject: LoadMoreObject

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

public struct LoadMoreIndicator<LoadMoreObject: LoadMore>: View {
    @ObservedObject var loadMoreObject: LoadMoreObject
    let reachEndText: String

    public init(loadMoreObject: LoadMoreObject, reachEndText: String = "All out") {
        self.loadMoreObject = loadMoreObject
        self.reachEndText = reachEndText
    }

    public var body: some View {
        if loadMoreObject.isLoadMore {
            SwiftUI.ProgressView()
                .padding()
        } else if loadMoreObject.reachEnd {
            Text(reachEndText)
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}
