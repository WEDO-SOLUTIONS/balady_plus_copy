import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class CountdownButton extends StatelessWidget {
  final String? primaryLabel;
  final VoidCallback? onTap;
  final VoidCallback? onAnimationCompleted;
  final Duration duration;

  const CountdownButton({
    super.key,
    this.primaryLabel,
    this.onTap,
    this.onAnimationCompleted,
    this.duration = const Duration(seconds: 4),
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: Stack(
      fit: StackFit.expand,
      children: [
        _Button(primaryLabel: primaryLabel, onTap: onTap),
        _AnimatedClipWidget(
          onAnimationCompleted: onAnimationCompleted,
          duration: duration,
          child: _Button(
            primaryLabel: primaryLabel,
            bgColor: context.colors.neutralOnContainer,
            textColor: context.colors.accentSecondaryOnAccentSecondary,
            onTap: onTap,
          ),
        ),
      ],
    ),
  );
}

class _Button extends StatelessWidget {
  final String? primaryLabel;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? textColor;

  const _Button({this.primaryLabel, this.onTap, this.bgColor, this.textColor});

  @override
  Widget build(BuildContext context) => AppButton(
    buttonColorScheme: ButtonColorScheme.accentSecondary,
    size: ButtonSize.large,
    color: bgColor,
    textColor: textColor,
    primaryLabel: primaryLabel,
    onTap: onTap,
  );
}

class _AnimatedClipWidget extends StatefulWidget {
  final Duration duration;
  final Widget child;
  final VoidCallback? onAnimationCompleted;

  const _AnimatedClipWidget({required this.duration, required this.child, this.onAnimationCompleted});

  @override
  _AnimatedClipWidgetState createState() => _AnimatedClipWidgetState();
}

class _AnimatedClipWidgetState extends State<_AnimatedClipWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.forward().then((_) => widget.onAnimationCompleted?.call());

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _animation,
    builder: (context, child) => ClipRRect(
      clipper: _Clipper(_animation.value),
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(Spacing.$2_5x)),
      child: child,
    ),
    child: widget.child,
  );
}

// Animates the clipping rectangle width from 0 to full size
class _Clipper extends CustomClipper<RRect> {
  final double progress;

  _Clipper(this.progress);

  @override
  RRect getClip(Size size) {
    if (size.width == 0 || size.height == 0) {
      return RRect.zero;
    }
    return RRect.fromRectAndRadius(
      Rect.fromPoints(Offset.zero, Offset(size.width * progress, size.height)),
      Radius.zero,
    );
  }

  @override
  bool shouldReclip(covariant _Clipper oldClipper) => oldClipper.progress != progress;
}
