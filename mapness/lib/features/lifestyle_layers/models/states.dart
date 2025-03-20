import 'package:dgis_map/library.dart';

class IndoorState {
  final bool hasLevels;
  final List<IndoorLevel>? levelNames;
  final int? activeIndex;

  const IndoorState({
    required this.hasLevels,
    this.levelNames,
    this.activeIndex,
  });

  factory IndoorState.disabled() => const IndoorState(hasLevels: false);

  IndoorState copyWith({
    bool? hasLevels,
    List<IndoorLevel>? levelNames,
    int? activeLevel,
  }) =>
      IndoorState(
        hasLevels: hasLevels ?? this.hasLevels,
        levelNames: levelNames ?? this.levelNames,
        activeIndex: activeLevel ?? activeIndex,
      );
}
