import DGis

extension Future {

    /// Convert DGis.Future<T> to Swift async
    func asAsync() async throws -> Value {
        var cancellable: Cancellable?

        let result = try await withCheckedThrowingContinuation {
            continuation in
            cancellable = sinkOnMainThread {
                value in
                continuation.resume(returning: value)
            } failure: {
                simpleError in
                continuation.resume(throwing: simpleError)
            }
        }

        cancellable?.cancel()

        return result
    }
}
