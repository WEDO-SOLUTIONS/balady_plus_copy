import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// TIFO entry-popup — Figma `onboarding` (file H4DvESBi2qwgfXZ8daWWFG,
/// node 286:20818). The first-touch, stories-style intro shown when a player
/// enters the game: a full-bleed dark hero (city split into two teams' colors
/// + club flags) under a stories progress bar + close, and a single white
/// "Dominate with your team" CTA pinned to the bottom.
///
/// Returns `true` when the CTA is pressed (enter the game), `false`/`null` when
/// dismissed (close / back).
class TifoEntryScreen extends StatefulWidget {
  const TifoEntryScreen({super.key, this.onEnter});

  /// Work the CTA must finish BEFORE this popup closes — the play-gate's
  /// network prep ([TifoJourney.prepare]). The button shows a spinner while it
  /// runs and the popup keeps covering the app, so the next gate screen is
  /// pushed the instant the popup pops. Without it the player was left on the
  /// map for the length of a `/me` + `/clubs` + `/config` round-trip and could
  /// walk into another tab, where the tutorial then landed on top.
  final Future<void> Function()? onEnter;

  @override
  State<TifoEntryScreen> createState() => _TifoEntryScreenState();
}

class _TifoEntryScreenState extends State<TifoEntryScreen> {
  static const Color _bg = Color(0xFF1B1B1B); // static/black

  /// Hard cap on the spinner: the API's own receive timeout is 20s per call
  /// and the prep makes several, so a stalled backend must not hold the CTA
  /// hostage. On timeout we enter anyway — the gate walk re-checks everything
  /// and is itself guarded against landing on the wrong surface.
  static const Duration _prepTimeout = Duration(seconds: 10);

  bool _busy = false;

  Future<void> _enter() async {
    final onEnter = widget.onEnter;
    if (onEnter == null) {
      await Navigator.of(context).maybePop(true);
      return;
    }
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await onEnter().timeout(_prepTimeout);
    } catch (_) {
      // Prep failures are non-fatal — the gate walk surfaces its own state.
    }
    if (!mounted) {
      return; // closed via X / back while preparing
    }
    setState(() => _busy = false);
    await Navigator.of(context).maybePop(true);
  }

  @override
  Widget build(BuildContext context) {
    // The hero art already bakes in its own localized headline (English
    // "Take over Riyadh…" / Arabic equivalent), so there's no separate
    // Text headline drawn on top — that would double up with the image.
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final heroAsset = isArabic
        ? 'packages/mapness/assets/tifo/backgrounds/entry_hero_ar.jpg'
        : 'packages/mapness/assets/tifo/backgrounds/entry_hero_en.jpg';
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed hero. The exported art already carries its own darkening,
          // so it sits directly on the black scaffold; cover + top alignment keeps
          // the horizon/flags framed as designed on taller screens.
          Image(
            image: AssetImage(heroAsset),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            // Missing asset (e.g. app not fully rebuilt) must not kill the
            // route — fall back to the plain dark scaffold.
            errorBuilder: (_, _, _) => const SizedBox.expand(),
          ),
          // Top scrim so the stories bar / close stay legible over bright art.
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x66000000), Color(0x00000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StoriesBar(onClose: () => Navigator.of(context).maybePop(false)),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: _EnterButton(onPressed: () => unawaited(_enter()), busy: _busy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Close row (design `stories-bar`): the design's stories progress track is an
/// EMPTY container — no visible line — so only the close button renders.
class _StoriesBar extends StatelessWidget {
  const _StoriesBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onClose,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07), // neutral-on-dark/container-default
              borderRadius: BorderRadius.circular(TifoRadii.m),
            ),
            child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

/// White primary CTA (design `accent/on-accent` bg, `static/black` label) — the
/// dark-hero counterpart to [TifoPrimaryButton].
class _EnterButton extends StatelessWidget {
  const _EnterButton({required this.onPressed, this.busy = false});

  final VoidCallback onPressed;

  /// Preparing the game — spinner in place of the label, taps ignored.
  final bool busy;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(TifoRadii.ml),
    child: InkWell(
      borderRadius: BorderRadius.circular(TifoRadii.ml),
      onTap: busy ? null : onPressed,
      child: SizedBox(
        height: 48,
        child: Center(
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: TifoColors.textStrong),
                )
              : Text(
                  AppLocalizations.of(context).dominateWithYourTeam,
                  style: TifoText.bodyLSemi.copyWith(color: TifoColors.textStrong, height: 1.5),
                ),
        ),
      ),
    ),
  );
}

/// Pushes the entry-popup as a fullscreen dialog; resolves to the CTA result.
/// [onEnter] runs on the CTA, under a spinner, before the popup closes — see
/// [TifoEntryScreen.onEnter].
Future<bool> showTifoEntry(BuildContext context, {Future<void> Function()? onEnter}) async {
  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute<bool>(
      fullscreenDialog: true,
      builder: (_) => TifoEntryScreen(onEnter: onEnter),
    ),
  );
  return result ?? false;
}
