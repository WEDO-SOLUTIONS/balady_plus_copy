import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';

/// TIFO entry-popup — Figma `onboarding` (file H4DvESBi2qwgfXZ8daWWFG,
/// node 286:20818). The first-touch, stories-style intro shown when a player
/// enters the game: a full-bleed dark hero (city split into two teams' colors
/// + club flags) under a stories progress bar + close, and a single white
/// "Dominate with your team" CTA pinned to the bottom.
///
/// Returns `true` when the CTA is pressed (enter the game), `false`/`null` when
/// dismissed (close / back).
class TifoEntryScreen extends StatelessWidget {
  const TifoEntryScreen({super.key});

  static const Color _bg = Color(0xFF1B1B1B); // static/black

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Stack(
      fit: StackFit.expand,
      children: [
        // Full-bleed hero. The exported art already carries its own darkening,
        // so it sits directly on the black scaffold; cover + top alignment keeps
        // the horizon/flags framed as designed on taller screens.
        Image(
          image: const AssetImage('packages/mapness/assets/tifo/backgrounds/entry_hero.jpg'),
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
            children: [
              _StoriesBar(onClose: () => Navigator.of(context).maybePop(false)),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: _EnterButton(onPressed: () => Navigator.of(context).maybePop(true)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Stories progress track + close button (design `stories-bar`). The track is a
/// single, currently-empty segment — the intro has one frame.
class _StoriesBar extends StatelessWidget {
  const _StoriesBar({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(36),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
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
  const _EnterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(TifoRadii.ml),
    child: InkWell(
      borderRadius: BorderRadius.circular(TifoRadii.ml),
      onTap: onPressed,
      child: SizedBox(
        height: 48,
        child: Center(
          child: Text(
            'Dominate with your team',
            style: TifoText.bodyLSemi.copyWith(color: TifoColors.textStrong, height: 1.5),
          ),
        ),
      ),
    ),
  );
}

/// Pushes the entry-popup as a fullscreen dialog; resolves to the CTA result.
Future<bool> showTifoEntry(BuildContext context) async {
  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute<bool>(
      fullscreenDialog: true,
      builder: (_) => const TifoEntryScreen(),
    ),
  );
  return result ?? false;
}
