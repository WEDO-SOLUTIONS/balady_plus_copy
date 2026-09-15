import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/data/tifo_debug_collider_overlay.dart';
import 'package:mapness/features/tifo/penalty/penalty_game.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/debug_3d_model.dart';
import 'package:mapness/shared/utils/detach.dart';

/// Penalty Challenge entry screen — Figma node 2:2541.
///
/// Shown after the player taps a 3D arena. Lays out the rules (1 token per
/// attempt, +60 pts per goal × 20) and a big purple START button that opens
/// [PenaltyApp]. Scoring a goal pops both this screen and the penalty app
/// and captures [polygonId] for the selected team.
class PenaltyEntryScreen extends ConsumerWidget {
  const PenaltyEntryScreen({required this.polygonId, super.key});

  /// District whose arena the player tapped. Forwarded to
  /// [Debug3DModelController.capturePolygon] on goal.
  final String polygonId;

  static const Color _bgTop = Color(0xFF081B18);
  static const Color _bgMid = Color(0xFF0D221D);
  static const Color _cardBg = Color(0xFF0D221D);
  static const Color _cardBorder = Color(0x308F45FF); // rgba(143,69,255,0.19)
  static const Color _textMuted = Color(0xFF5A9B8E);
  static const Color _textHero = Color(0xFFE8F5F3);
  static const Color _accentToken = Color(0xFFF0C040);
  static const Color _accentReward = Color(0xFF22C55E);
  static const Color _accentInfo = Color(0xFF79DCD0);
  static const Color _ctaStart = Color(0xFF8F45FF);
  static const Color _ctaEnd = Color(0xFFA95CFF);

  // Stadium/game chrome mirrors the physical pitch, not reading order — kept
  // LTR regardless of app locale so it never flips in Arabic.
  @override
  Widget build(BuildContext context, WidgetRef ref) => Directionality(
    textDirection: TextDirection.ltr,
    child: Scaffold(
      backgroundColor: _bgMid,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.7, -1.0),
            end: Alignment(0.7, 1.0),
            stops: [0.08, 0.5, 0.92],
            colors: [_bgTop, _bgMid, _bgTop],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Caption(),
                        const SizedBox(height: 4),
                        _HeroTitle(),
                        const SizedBox(height: 16),
                        const _StadiumImage(),
                        const SizedBox(height: 24),
                        const _StatsCard(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _StartButton(
                  onTap: () => _startPenalty(context, ref),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  /// Minimum goals (out of 5 attempts) required to capture the polygon.
  static const int _goalsToCapture = 3;

  void _startPenalty(BuildContext context, WidgetRef ref) {
    var handled = false;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => PenaltyApp(
          showColliderDebug: ref.read(tifoDebugColliderOverlayProvider),
          locale: ref.read(appLanguageProvider).locale,
          onComplete: (outcome) {
            if (handled) {
              return;
            }
            handled = true;
            final goals = outcome.goals;
            // Brief delay so the user sees the last result message,
            // then unconditionally pop back to the dashboard map.
            Future<void>.delayed(const Duration(seconds: 2), () {
              // Use the global root key — `context` could be unmounted
              // by the time this future fires.
              rootNavigatorKey.currentState?.popUntil((route) => route.isFirst);
              if (goals >= _goalsToCapture) {
                detach(
                  ref.read(debug3dModelProvider.notifier).capturePolygon(polygonId: polygonId),
                  tag: 'penaltyEntryScreen.capturePolygon',
                );
              }
            });
          },
        ),
      ),
    );
  }
}

// ─── Top bar: just a close button ────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.close,
          size: 18,
          color: PenaltyEntryScreen._textHero,
        ),
      ),
    ),
  );
}

class _Caption extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text(
    // Was a hardcoded bilingual caption whose Arabic half read "تحدي التيفو".
    // `tifoPenaltyChallenge` carries the reviewed wording in both locales
    // ("تحدي ركلات الترجيح"), and uppercasing is a no-op on Arabic, so the
    // Figma treatment (9pt, 1.8 letter spacing, all-caps) survives either way.
    AppLocalizations.of(context).tifoPenaltyChallenge.toUpperCase(),
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 9,
      height: 13.5 / 9,
      letterSpacing: 1.8,
      color: PenaltyEntryScreen._textMuted,
    ),
  );
}

class _HeroTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Text(
    'PENALTY KICK',
    style: TextStyle(
      fontFamily: 'Orbitron',
      package: 'mapness',
      fontWeight: FontWeight.w900,
      fontSize: 20,
      height: 28 / 20,
      letterSpacing: 0.4,
      color: PenaltyEntryScreen._textHero,
    ),
  );
}

// ─── Stadium photo card ──────────────────────────────────────────────────────

class _StadiumImage extends StatelessWidget {
  const _StadiumImage();

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: AspectRatio(
      aspectRatio: 356 / 280,
      child: Image.asset(
        'packages/mapness/assets/tifo/images/penalty_preview.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF065F46),
                Color(0xFF134E4A),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            '⚽',
            style: TextStyle(fontSize: 96, height: 1.0),
          ),
        ),
      ),
    ),
  );
}

// ─── Stats card: Cost + Reward + info pill ───────────────────────────────────

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: PenaltyEntryScreen._cardBg,
      border: Border.all(
        color: PenaltyEntryScreen._cardBorder,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF8F45FF).withOpacity(0.08),
          blurRadius: 14,
        ),
      ],
    ),
    child: Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: _StatTile(
                icon: Icons.monetization_on_outlined,
                tintColor: PenaltyEntryScreen._accentToken,
                captionAr: 'التكلفة',
                value: '1',
                unit: 'رمز · token',
                hint: null,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _StatTile(
                icon: Icons.star_outline_rounded,
                tintColor: PenaltyEntryScreen._accentReward,
                captionAr: 'المكافأة',
                value: '+60',
                unit: 'نقطة · pts',
                hint: 'per goal ×20',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoPill(),
      ],
    ),
  );
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.tintColor,
    required this.captionAr,
    required this.value,
    required this.unit,
    required this.hint,
  });

  final IconData icon;
  final Color tintColor;
  final String captionAr;
  final String value;
  final String unit;
  final String? hint;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(17.5),
    decoration: BoxDecoration(
      color: tintColor.withOpacity(0.06),
      border: Border.all(color: tintColor.withOpacity(0.21), width: 1.5),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: tintColor),
            const SizedBox(width: 6),
            Text(
              captionAr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                height: 13.5 / 9,
                letterSpacing: 0.225,
                color: PenaltyEntryScreen._textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Orbitron',
            package: 'mapness',
            fontWeight: FontWeight.w900,
            fontSize: 30,
            height: 36 / 30,
            color: tintColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 10,
            height: 15 / 10,
            color: PenaltyEntryScreen._textMuted,
          ),
        ),
        if (hint != null) ...[
          const SizedBox(height: 2),
          Text(
            hint!,
            style: TextStyle(
              fontSize: 9,
              height: 13.5 / 9,
              color: tintColor.withOpacity(0.5),
            ),
          ),
        ],
      ],
    ),
  );
}

class _InfoPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.04),
      border: Border.all(
        color: PenaltyEntryScreen._accentInfo.withOpacity(0.14),
        width: 0.75,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Row(
      children: [
        Icon(
          Icons.bolt,
          size: 12,
          color: PenaltyEntryScreen._ctaStart,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 10,
                height: 16.25 / 10,
                color: PenaltyEntryScreen._accentInfo,
              ),
              children: [
                TextSpan(
                  text: '1 token = 1 attempt. Each goal = +20 influence.',
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ─── START button ────────────────────────────────────────────────────────────

class _StartButton extends StatelessWidget {
  const _StartButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PenaltyEntryScreen._ctaStart,
            PenaltyEntryScreen._ctaEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: PenaltyEntryScreen._ctaStart.withOpacity(0.29),
            offset: const Offset(0, 8),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚽', style: TextStyle(fontSize: 20, height: 1.0)),
          const SizedBox(width: 8),
          Text(
            AppLocalizations.of(context).startGame,
            style: const TextStyle(
              fontFamily: 'Orbitron',
              package: 'mapness',
              fontWeight: FontWeight.w900,
              fontSize: 16,
              height: 24 / 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        ],
      ),
    ),
  );
}
