import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart' show TifoActivationSource;
import 'package:mapness/features/tifo/team_select_screen.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// TIFO onboarding — Figma `StepOnboarding` (node 1:6913 / 1:6916).
///
/// Shown right after [TifoLaunchScreen] is dismissed (when game mode is still
/// active). Layout: top header with Balady+ logo and close, a preview section
/// with a floating "TIFO is live" card, "Compete for Riyadh" heading and three
/// feature rows, then a sticky "Join Tifo / Maybe Later" CTA at the bottom.
class TifoOnboardingScreen extends StatelessWidget {
  const TifoOnboardingScreen({super.key});

  static const Color _bg = Colors.white;
  static const Color _textPrimary = Color(0xFF101828);
  static const Color _textSecondary = Color(0xFF6A7282);
  static const Color _textMuted = Color(0xFF99A1AF);
  static const Color _accent = Color(0xFF16A34A);
  static const Color _accentLight = Color(0xFF22C55E);
  static const Color _divider = Color(0xFFF3F4F6);
  static const Color _featureBg = Color(0xFFF9FAFB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const _Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _PreviewSection(),
                  _DescriptionSection(),
                ],
              ),
            ),
          ),
          const _BottomCta(),
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: TifoOnboardingScreen._divider,
            width: 0.75,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 13),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: TifoOnboardingScreen._accent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'B+',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    height: 16 / 12,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Balady+',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 20 / 14,
                  color: TifoOnboardingScreen._textPrimary,
                ),
              ),
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 28, height: 28),
                icon: const Icon(
                  Icons.close,
                  color: TifoOnboardingScreen._textSecondary,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Preview section ─────────────────────────────────────────────────────────

class _PreviewSection extends StatefulWidget {
  const _PreviewSection();

  /// Asset paths the carousel cycles through. Drop the corresponding files
  /// into [_previewAssetDir] and they'll appear here on the next restart.
  static const List<String> _previewAssets = [
    'assets/tifo/preview/preview_1.png',
    'assets/tifo/preview/preview_2.png',
    'assets/tifo/preview/preview_3.png',
  ];

  static const Duration _interval = Duration(seconds: 4);
  static const Duration _slideDuration = Duration(milliseconds: 600);

  @override
  State<_PreviewSection> createState() => _PreviewSectionState();
}

class _PreviewSectionState extends State<_PreviewSection> {
  // Start far from 0 so we can advance "forward" indefinitely in either
  // direction (manual swipe back or programmatic next) without ever hitting
  // the edge. itemBuilder uses modulo to wrap to the real asset list.
  static const int _initialPage = 1 << 20;

  final PageController _controller = PageController(initialPage: _initialPage);
  Timer? _timer;
  int _page = _initialPage;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_PreviewSection._interval, (_) => _advance());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _advance() {
    if (!mounted || !_controller.hasClients) return;
    _controller.animateToPage(
      _page + 1,
      duration: _PreviewSection._slideDuration,
      curve: Curves.easeInOut,
    );
  }

  int get _activeIndex => _page % _PreviewSection._previewAssets.length;

  String _assetForPage(int page) {
    final assets = _PreviewSection._previewAssets;
    return assets[page % assets.length];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 298,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              // null = unbounded list → infinite forward loop.
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                return Image.asset(
                  _assetForPage(i),
                  package: 'mapness',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const _PreviewFallback(),
                );
              },
            ),
          ),
          // Subtle bottom gradient so the floating card stays legible.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.35),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Page indicator dots.
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _PreviewSection._previewAssets.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _activeIndex == i ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_activeIndex == i ? 0.95 : 0.45),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
          // Floating info card pinned near the bottom of the preview.
          const Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: _LiveCard(),
          ),
        ],
      ),
    );
  }
}

/// Plain dark gradient shown while preview images are missing.
class _PreviewFallback extends StatelessWidget {
  const _PreviewFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E1B4B),
            Color(0xFF065F46),
            Color(0xFF134E4A),
          ],
        ),
      ),
    );
  }
}

class _LiveCard extends StatelessWidget {
  const _LiveCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TifoOnboardingScreen._accent.withOpacity(0.2),
          width: 0.75,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // rgba(0,0,0,0.08)
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: TifoOnboardingScreen._accent,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Text(
              '🏟',
              style: TextStyle(fontSize: 20, height: 1.0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'TIFO is live in Riyadh',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    height: 16.5 / 11,
                    color: TifoOnboardingScreen._textPrimary,
                  ),
                ),
                Text(
                  '130 districts · 4 teams · real locations',
                  style: TextStyle(
                    fontSize: 9,
                    height: 13.5 / 9,
                    color: TifoOnboardingScreen._textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: TifoOnboardingScreen._accentLight,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Description ─────────────────────────────────────────────────────────────

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Compete for Riyadh',
            style: TextStyle(
              fontFamily: 'Orbitron',
              package: 'mapness',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 28 / 20,
              letterSpacing: 0.4,
              color: TifoOnboardingScreen._textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Join your team's army and take control of real districts "
            'across the city. Season 1 has begun.',
            style: TextStyle(
              fontSize: 14,
              height: 22.75 / 14,
              color: TifoOnboardingScreen._textSecondary,
            ),
          ),
          SizedBox(height: 20),
          _FeatureRow(
            emoji: '🗺',
            title: 'Control 130 real districts',
            subtitle: 'Actual Riyadh neighbourhoods — Al Olaya, Hittin, Al Malaz and more',
          ),
          SizedBox(height: 16),
          _FeatureRow(
            emoji: '⚔️',
            title: 'Territory',
            subtitle: 'Attack enemy districts, defend your own in real time',
          ),
          SizedBox(height: 16),
          _FeatureRow(
            emoji: '💎',
            title: 'Earn crystals & rewards',
            subtitle: 'District production, season prizes, rare relics',
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: TifoOnboardingScreen._featureBg,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 20, height: 1.0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 19.5 / 13,
                    color: TifoOnboardingScreen._textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 17.875 / 11,
                    color: TifoOnboardingScreen._textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Bottom CTA ──────────────────────────────────────────────────────────────

class _BottomCta extends StatelessWidget {
  const _BottomCta();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: TifoOnboardingScreen._divider,
            width: 0.75,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      fullscreenDialog: true,
                      // This legacy full-screen intro is the game's own
                      // banner, not one of the play-gate entry points.
                      builder: (_) => const TifoTeamSelectScreen(source: TifoActivationSource.banner),
                    ),
                  );
                },
                child: Container(
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        TifoOnboardingScreen._accent,
                        TifoOnboardingScreen._accentLight,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: TifoOnboardingScreen._accent.withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Join Tifo',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 22.5 / 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(
                  AppLocalizations.of(context).maybeLater,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    height: 19.5 / 13,
                    color: TifoOnboardingScreen._textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
