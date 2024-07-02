import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/indoor_levels.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class IndoorControl extends ConsumerStatefulWidget {
  const IndoorControl({super.key});

  @override
  ConsumerState<IndoorControl> createState() => _IndoorControlState();
}

class _IndoorControlState extends ConsumerState<IndoorControl> {

  @override
  void didUpdateWidget(covariant IndoorControl oldWidget) {
    ref.read(indoorLevelsProvider.notifier).refreshStreams();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final indoorState = ref.watch(indoorLevelsProvider);

    return indoorState == null
        ? const SizedBox.shrink()
        : _IndoorControlLevels(
      state: indoorState,
      onSelect: (level) => ref.read(indoorLevelsProvider.notifier).selectLevel(level),
    );
  }

}

class _IndoorControlLevels extends StatelessWidget {
  const _IndoorControlLevels({
    required this.state,
    required this.onSelect,
  });

  final LevelsState state;
  final void Function(IndoorLevel) onSelect;
  
  @override
  Widget build(BuildContext context) => Column(
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
                  style: Theme.of(context).extension<ThemeTextStyles>()!.callout.copyWith(
                        color: e.levelIndex == state.active
                            ? context.color.strokeAccent
                            : context.color.textAndIconsBasePrimary,
                      ),
                ),
              ),
            )
            .toList(),
      );

}
