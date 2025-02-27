//
//  LoadMore.swift
//  AppFoundation
//
//  Created by Long Vu on 12/1/25.
//

import Combine
import Foundation

public protocol LoadMore: ObservableObject {
    var pageSize: Int { get set }
    var isLoadMore: Bool { get set }
    var canLoadMore: Bool { get set }
    var reachEnd: Bool { get set }

    static var pageSizeStep: Int { get }

    func makeCanLoadMorePublisher<T: Equatable>(_ data: AnyPublisher<[T], Never>) -> AnyPublisher<Bool, Never>

    @MainActor
    func loadMore() async
}

public extension LoadMore {
    static var pageSizeStep: Int {
        10
    }

    @MainActor
    func loadMore() async {
        guard canLoadMore else {
            return
        }

        isLoadMore = true

        try? await Task.sleep(nanoseconds: 1_500_000_000) // Sleep for 1.5s seconds

        self.pageSize += Self.pageSizeStep
    }

    func makeCanLoadMorePublisher(_ data: AnyPublisher<[some Equatable], Never>) -> AnyPublisher<Bool, Never> {
        data
            .pairwise()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] prev, current in
                let prevCount = prev.count
                let currentCount = current.count
                self?.reachEnd = prevCount == currentCount && prevCount > 0
            })
            .map { prev, current in
                let prevCount = prev.count
                let currentCount = current.count
                return prevCount < currentCount && currentCount >= Self.pageSizeStep
            }
            .eraseToAnyPublisher()
    }
}

private extension Publisher {
    /// Groups the elements of the source publisher into arrays of N consecutive elements.
    /// The resulting publisher:
    ///    - does not emit anything until the source publisher emits at least N elements;
    ///    - emits an array for every element after that;
    ///    - forwards any errors or completed events.
    ///
    /// - parameter size: size of the groups, must be greater than 1
    ///
    /// - returns: A type erased publisher that holds an array with the given size.
    func nwise(_ size: Int) -> AnyPublisher<[Output], Failure> {
        assert(size > 1, "n must be greater than 1")

        return scan([]) { acc, item in Array((acc + [item]).suffix(size)) }
            .filter { $0.count == size }
            .eraseToAnyPublisher()
    }

    /// Groups the elements of the source publisher into tuples of the previous and current elements
    /// The resulting publisher:
    ///    - does not emit anything until the source publisher emits at least 2 elements;
    ///    - emits a tuple for every element after that, consisting of the previous and the current item;
    ///    - forwards any error or completed events.
    ///
    /// - returns: A type erased publisher that holds a tuple with 2 elements.
    func pairwise() -> AnyPublisher<(Output, Output), Failure> {
        nwise(2)
            .map { ($0[0], $0[1]) }
            .eraseToAnyPublisher()
    }
}
