import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/accecipilities/accessibility_controller.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:mapness/shared/extensions/build_context_ext.dart';

class TextSizePreviewPage extends StatefulWidget {
  const TextSizePreviewPage({super.key});

  @override
  State<TextSizePreviewPage> createState() => _TextSizePreviewPageState();
}

class _TextSizePreviewPageState extends State<TextSizePreviewPage> {
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    final controller =
        Provider.of<AccessibilityController>(context, listen: false);
    _fontSize = 16 * controller.textScale;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AccessibilityController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaladyTopBar.iconAndText(
        systemUiOverlayStyle: SystemUiOverlayStyle.dark,
        title: 'context.l10n.fontSize',
        colorEnabled: context.colors.accentDefault,
        leading: ActionModel(
          onPressed: () {
            controller.setTextScale(_fontSize / 16);
            context.router.pop();
          },
          icon: SystemIcons.arrowCornerLeftLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 24,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Main text will look like this.\n'
                '1234567890!@#%&*()_+-=',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                const Text(
                  'A',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      activeTrackColor: const Color(0xFF4DB6AC),
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: const Color(0xFF4DB6AC),
                      overlayColor: const Color(0xFF4DB6AC).withOpacity(0.15),
                      tickMarkShape: const RoundSliderTickMarkShape(
                        tickMarkRadius: 2,
                      ),
                      activeTickMarkColor: Colors.transparent,
                      inactiveTickMarkColor:
                          const Color(0xFF4DB6AC).withOpacity(0.4),
                    ),
                    child: Slider(
                      value: _fontSize,
                      min: 12,
                      max: 24,
                      divisions: 12,
                      onChanged: (value) {
                        setState(() => _fontSize = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'A',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('12px', style: TextStyle(color: Colors.grey)),
                  Text('24px', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
