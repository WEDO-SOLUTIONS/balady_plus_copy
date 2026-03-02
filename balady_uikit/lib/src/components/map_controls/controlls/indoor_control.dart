part of '../map_controls.dart';

class IndoorControl extends StatelessWidget {
  final LevelsState? indoorState;
  final Function(IndoorLevel) onSelect;

  const IndoorControl({required this.onSelect, super.key, this.indoorState});

  @override
  Widget build(BuildContext context) {
    return indoorState == null
        ? const SizedBox.shrink()
        : _IndoorControl(
            state: indoorState!,
            onSelect: onSelect,
          );
  }
}
