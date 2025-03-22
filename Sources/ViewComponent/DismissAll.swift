import Foundation

public class DismissAll: ObservableObject {
    @Published public var id: UUID?

    private var continuation: UnsafeContinuation<Void, Never>?

    public init() {}

    @MainActor
    public func trigger() async {
        await withUnsafeContinuation { [weak self] continuation in
            self?.continuation = continuation
            DispatchQueue.main.async {
                self?.id = UUID()
            }
        }
    }

    @MainActor
    public func complete() {
        continuation?.resume()
    }
}
