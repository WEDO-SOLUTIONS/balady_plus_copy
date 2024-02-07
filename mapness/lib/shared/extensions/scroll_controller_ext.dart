import 'package:flutter/widgets.dart';

extension PaginationScrollController on ScrollController {
  bool get isCloseToEnd {
    if (!hasClients) {
      return false;
    }
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    return maxScroll - currentScroll < 100; // Threshold of 100 pixels
  }
}
