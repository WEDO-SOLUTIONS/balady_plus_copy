enum SizeMetric {
  bytes('Bytes'),
  killoBytes('KB'),
  megaBytes('MB'),
  gigaBytes('GB');

  const SizeMetric(this.label);
  final String label;
}

class FileSize {
  final double size;
  final SizeMetric metric;

  const FileSize(this.size, {required this.metric});

  @override
  String toString() => '$size $metric';
}
