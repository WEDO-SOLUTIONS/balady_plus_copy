import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/indoor_levels.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class IndoorControl extends ConsumerWidget {
  const IndoorControl({super.key, this.objectId});

  final int? objectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indoorLevels = indoorLevelsProvider(objectId: objectId);
    final indoorState = ref.watch(indoorLevels);

    return indoorState == null
        ? const SizedBox.shrink()
        : _IndoorControl(
            state: indoorState,
            onSelect: (level) => ref.read(indoorLevels.notifier).selectLevel(level),
          );
  }
}

class _IndoorControl extends StatelessWidget {
  final LevelsState state;
  final void Function(IndoorLevel) onSelect;

  const _IndoorControl({
    required this.state,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: state.levels.reversed
            .mapIndexed(
              (index, e) => MapButton(
                onTap: () => onSelect(e),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(index == 0 ? 10 : 0),
                  topRight: Radius.circular(index == 0 ? 10 : 0),
                  bottomLeft: Radius.circular(index == state.levels.length - 1 ? 10 : 0),
                  bottomRight: Radius.circular(index == state.levels.length - 1 ? 10 : 0),
                ),
                child: Text(
                  e.name,
                  style: context.textStyle.callout.copyWith(
                    color: e.levelIndex == state.active
                        ? context.colors.accentOnContainer
                        : context.colors.foregroundDefault,
                  ),
                ),
              ),
            )
            .toList(),
      );
}
