import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/accecipilities/accessibility_controller.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:provider/provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart' as p;

class TextSizePreviewPage extends ConsumerStatefulWidget {
  const TextSizePreviewPage({super.key});

  @override
  ConsumerState<TextSizePreviewPage> createState() => _TextSizePreviewPageState();
}

class _TextSizePreviewPageState extends ConsumerState<TextSizePreviewPage> {
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    final controller = p.Provider.of<AccessibilityController>(context, listen: false);

    _fontSize = 16 * controller.textScale;
  }

  @override
  Widget build(BuildContext context) {
    final controller = p.Provider.of<AccessibilityController>(context);
    final dgisController = ref.watch(dgisControllerProvider);
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bodyTextColor = isDark ? colors.accentDefault : colors.foregroundDefault;
    final titleStyle = context.textStyles.bodyLargeSemiBold.copyWith(color: bodyTextColor);
    final accent = colors.accentDefault;

    return Scaffold(
      backgroundColor: colors.backgroundSurface4,

      appBar: BaladyTopBar(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        title: 'fontSize'.tr(),
        onLeadingPressed: () {
          context.router.pop();
        },
        leading: Semantics(
          label: 'a11yBack'.tr(),
          button: true,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: Spacing.$4x),
                Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.accentDefault),
                const SizedBox(width: Spacing.$4x),
              ],
            ),
          ),
        ),
        textStyle: titleStyle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(color: colors.backgroundSurface1, borderRadius: BorderRadius.circular(24)),
              child: Text(
                'Main text will look like this.\n'
                '1234567890!@#%&*()_+-=',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: _fontSize, height: 1.4, color: bodyTextColor),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Text('A', style: TextStyle(fontSize: 12, color: bodyTextColor)),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      activeTrackColor: accent,
                      inactiveTrackColor: context.colors.backgroundSurface1,
                      thumbColor: accent,
                      overlayColor: accent.withOpacity(0.15),
                      tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 2),
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor: accent.withOpacity(0.4),
                    ),
                    child: Slider(
                      value: _fontSize,
                      min: 12,
                      max: 24,
                      divisions: 12,
                      onChanged: (value) {
                        setState(() => _fontSize = value);
                        controller.setTextScale(_fontSize / 16, dgisController.value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('A', style: TextStyle(fontSize: 24, color: bodyTextColor)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('12px', style: TextStyle(color: isDark ? accent : Colors.grey)),
                  Text('24px', style: TextStyle(color: isDark ? accent : Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
