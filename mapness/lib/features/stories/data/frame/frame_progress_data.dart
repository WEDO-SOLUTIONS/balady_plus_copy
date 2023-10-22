class FrameProgressData {
  final int length;
  final int currentIndex;
  final double progress;

  const FrameProgressData({
    required this.progress,
    required this.length,
    required this.currentIndex,
  })  : assert((progress) <= 1, "Progress must be less than 1"),
        assert((progress) >= 0, "Progress must be greater than 0"),
        assert(0 <= currentIndex && currentIndex < length, "Current item must be between 0 and itemCount");

  FrameProgressData copyWith({
    int? itemCount,
    int? currentItem,
    double? progress,
  }) {
    return FrameProgressData(
      length: itemCount ?? length,
      currentIndex: currentItem ?? currentIndex,
      progress: progress ?? this.progress,
    );
  }
}
