/// Convert anything to Future or Future with delay
extension WithDelay<T> on T {
  Future<T> toFuture({Duration? delay}) => delay != null ? Future.delayed(delay, () => this) : Future.value(this);
}
