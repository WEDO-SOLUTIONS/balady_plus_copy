import 'dart:math';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'happiness_tags.g.dart';

@riverpod
class HappinessTags extends _$HappinessTags {
  @override
  List<String> build() {
    return [
      "streets",
      "buildings",
      "parks",
      "visual_aesthetic",
      "cleanness",
      "lighting",
      "comfort",
    ];
  }
}

@riverpod
class HappinessTagsWithIcons extends _$HappinessTagsWithIcons {
  @override
  List<(IconData, String)> build() {
    final tags = ref.watch(happinessTagsProvider);
    final random = Random(42);
    final icons = [
      Icons.favorite,
      Icons.mood,
      Icons.sentiment_very_satisfied,
      Icons.sentiment_satisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_very_dissatisfied,
      Icons.mood_bad,
      Icons.dangerous,
      Icons.one_k_outlined,
      Icons.qr_code_scanner,
    ];
    return tags.map((e) => (icons[random.nextInt(icons.length)], e)).toList();
  }
}
