part of 'place_card.dart';

class _GradientPlaceholder extends StatelessWidget {
  final Widget child;

  const _GradientPlaceholder({required this.child});

  @override
  Widget build(BuildContext context) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0x00666666),
            Colors.black.withOpacity(0.7),
          ],
        ).createShader(bounds),
        child: child,
      );
}
