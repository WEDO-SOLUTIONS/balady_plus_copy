import 'package:flutter/material.dart';

@immutable
class Selection<T> {
  final T value;
  final bool selected;

  const Selection({required this.value, required this.selected});

  Selection<T> copyWith({
    T? value,
    bool? selected,
  }) => Selection(
      value: value ?? this.value,
      selected: selected ?? this.selected,
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Selection && value == other.value && selected == other.selected);

  @override
  int get hashCode => Object.hash(value, selected);
}
