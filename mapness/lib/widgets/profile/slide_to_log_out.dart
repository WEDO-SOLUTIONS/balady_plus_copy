import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class SlideToLogout extends StatefulWidget {
  final String buttonText;
  final VoidCallback onLogout;

  const SlideToLogout({
    required this.onLogout,
    required this.buttonText,
    super.key,
  });

  @override
  State<SlideToLogout> createState() => _SlideToLogoutState();
}

class _SlideToLogoutState extends State<SlideToLogout> {
  static const slideSize = 48.0;

  double _dragPosition = 0;
  final radius = BorderRadius.circular(10);

  Color get _backgroundColor => context.colors.errorContainerDefault;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (ctx, constraints) {
      final maxWidth = constraints.maxWidth - slideSize;
      final textDirection = Directionality.of(context);
      final isRTL = textDirection == TextDirection.rtl;
      return Stack(
        children: [
          Container(
            alignment: AlignmentDirectional.centerStart,
            height: slideSize,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: radius,
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: slideSize + Spacing.$6x),
              child: Text(
                widget.buttonText,
                style: context.textStyles.buttonL.copyWith(
                  color: context.colors.errorDefault,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Durations.short2,
            height: slideSize,
            width: _dragPosition + slideSize,
            decoration: BoxDecoration(
              color: context.colors.errorDefault.withOpacity(0.7),
              borderRadius: radius,
            ),
          ),
          AnimatedPositionedDirectional(
            duration: Durations.short2,
            start: _dragPosition,
            child: Semantics(
              button: true,
              enabled: true,
              label: widget.buttonText,
              onTap: () {
                // VoiceOver/TalkBack double-tap or activate
                widget.onLogout();
              },
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    final factor = isRTL ? -1 : 1;
                    _dragPosition = (_dragPosition + factor * details.delta.dx).clamp(0, maxWidth);
                  });
                },
                onHorizontalDragEnd: (details) {
                  if (_dragPosition >= maxWidth - maxWidth / 3) {
                    widget.onLogout();
                    setState(() {
                      _dragPosition = maxWidth;
                    });
                  } else {
                    setState(() => _dragPosition = 0);
                  }
                },

                child: Container(
                  width: slideSize,
                  height: slideSize,
                  decoration: BoxDecoration(
                    color: context.colors.errorDefault,
                    borderRadius: radius,
                  ),
                  child: Icon(
                    SystemIcons.arrowRight,
                    size: 24,
                    color: context.colors.staticWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
