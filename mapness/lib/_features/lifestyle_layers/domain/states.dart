import 'package:dgis_map/library.dart';

class IndoorState {
  IndoorState({
    required this.hasLevels,
    this.levelNames,
    this.activeIndex,
  });

  factory IndoorState.disabled() => IndoorState(hasLevels: false);

  final bool hasLevels;
  final List<IndoorLevel>? levelNames;
  final int? activeIndex;

  IndoorState copyWith({
    bool? hasLevels,
    List<IndoorLevel>? levelNames,
    int? activeLevel,
  }) {
    return IndoorState(
      hasLevels: hasLevels ?? this.hasLevels,
      levelNames: levelNames ?? this.levelNames,
      activeIndex: activeLevel ?? activeIndex,
    );
  }
}
