import 'package:flutter/material.dart';

/// TIFO launch screen — Figma `StepLaunch` (node 1:6873).
///
/// Black hero with a faint city-map dot layer, the Balady+ wordmark on top,
/// a stadium card with a "NEW" pill, and a TIFO title with tagline.
///
/// Tap anywhere to close (Navigator.maybePop).
class TifoLaunchScreen extends StatelessWidget {
  const TifoLaunchScreen({super.key});

  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _accent = Color(0xFF16A34A);
  static const Color _accentLight = Color(0xFF22C55E);
  static const Color _accentDark = Color(0xFF14532D);
  static const Color _textPrimary = Color(0xFFF5F5F5);
  static const Color _textSecondary = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).maybePop(),
        child: Stack(
          children: [
            const Positioned.fill(child: _CityDotsBackground()),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, 0.0),
                    radius: 0.55,
                    colors: [
                      _accent.withOpacity(0.18),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    _BrandRow(),
                    SizedBox(height: 40),
                    _TifoCard(),
                    SizedBox(height: 28),
                    Text(
                      'TIFO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        height: 32 / 24,
                        letterSpacing: 0.6,
                        color: _textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Territory battles. Now in Riyadh.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                        color: _textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: TifoLaunchScreen._accent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: TifoLaunchScreen._accent.withOpacity(0.45),
                blurRadius: 10,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'B+',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              height: 20 / 14,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Balady+',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            height: 28 / 18,
            letterSpacing: 0.45,
            color: TifoLaunchScreen._textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TifoCard extends StatelessWidget {
  const _TifoCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 104,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    TifoLaunchScreen._accentDark,
                    TifoLaunchScreen._accent,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: TifoLaunchScreen._accentLight,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: TifoLaunchScreen._accent.withOpacity(0.5),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🏟',
                  style: TextStyle(
                    fontSize: 40,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: -8,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: TifoLaunchScreen._accentLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9.5,
                  height: 1.3,
                  color: Color(0xFF052E16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Scattered dots that hint at a city map in the background.
/// Positions/sizes lifted from Figma `CityMapSVG` (~13 vector dots),
/// fractions are relative to Figma 394x852 canvas. Layer is at 20% opacity.
class _CityDotsBackground extends StatelessWidget {
  const _CityDotsBackground();

  static const List<_Dot> _dots = [
    _Dot(0.013, 0.347, 18.19, Color(0xFFFACC15)),
    _Dot(0.323, 0.311, 17.76, Color(0xFFDC2626)),
    _Dot(0.633, 0.276, 16.95, Color(0xFF3B82F6)),
    _Dot(0.943, 0.348, 15.83, Color(0xFF60A5FA)),
    _Dot(0.018, 0.563, 14.58, Color(0xFFFB923C)),
    _Dot(0.328, 0.528, 13.46, Color(0xFF22C55E)),
    _Dot(0.638, 0.493, 12.66, Color(0xFFA855F7)),
    _Dot(0.948, 0.564, 12.25, Color(0xFFEAB308)),
    _Dot(0.175, 0.457, 12.18, Color(0xFFEF4444)),
    _Dot(0.485, 0.422, 12.18, Color(0xFFFACC15)),
    _Dot(0.794, 0.422, 12.18, Color(0xFF94A3B8)),
    _Dot(0.330, 0.636, 12.18, Color(0xFFF87171)),
    _Dot(0.639, 0.636, 12.18, Color(0xFF94A3B8)),
  ];

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: [
              for (final dot in _dots)
                Positioned(
                  left: dot.x * w,
                  top: dot.y * h,
                  width: dot.size,
                  height: dot.size,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: dot.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Dot {
  const _Dot(this.x, this.y, this.size, this.color);

  final double x;
  final double y;
  final double size;
  final Color color;
}
