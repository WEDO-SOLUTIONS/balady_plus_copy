import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/favorite_lists/data/models/marker_color_code.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class MarkerColorPickerPage extends HookConsumerWidget {
  final MarkerColorCode selectedColor;

  const MarkerColorPickerPage({required this.selectedColor, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useToggleSheetController(onClose: (_) => context.router.pop());
    final selected = useState(selectedColor);

    return ToggleSheet(
      scrollController: scrollController,
      backgroundColor: context.colors.backgroundSurface4,
      safeAreaColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(draggerColor: context.colors.backgroundSurface5),
      outside: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.router.pop(),
        child: const SizedBox.expand(),
      ),
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Row(
          children: [
            Expanded(
              child: Text(
                // TODO(claude): localize string
                'Marker color',
                style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            IconButton(onPressed: () => context.router.pop(), icon: const Icon(SystemIcons.close)),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(Spacing.$4x),
      content: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$4x),
          decoration: BoxDecoration(
            color: context.colors.backgroundSurface1,
            borderRadius: BorderRadius.circular(Spacing.$3x),
          ),
          child: Wrap(
            spacing: Spacing.$1_5x,
            children: MarkerColorCode.values.where((code) => code != MarkerColorCode.unknown).map((code) {
              final isSelected = selected.value == code;
              return GestureDetector(
                onTap: () => selected.value = code,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? code.getColor(context.colors) : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(Spacing.$1x + 2),
                  ),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: code.getColor(context.colors),
                      borderRadius: BorderRadius.circular(Spacing.$1x),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: Spacing.$4x),
        BaladyAppButton(
          // TODO(claude): localize string
          primaryLabel: 'Done',
          buttonColorScheme: ButtonColorScheme.accent,
          onTap: () => context.router.pop(selected.value),
        ),
      ],
    );
  }
}
