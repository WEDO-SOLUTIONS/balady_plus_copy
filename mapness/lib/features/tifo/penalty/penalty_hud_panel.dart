import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

/// "Penalty challenge" info panel (Figma 696:112029): dark translucent card
/// with a gradient hairline on top; three columns — misses remaining (ball =
/// left, red cross = spent), Scored and Score to beat. Fields per BRD V2
/// FD-48…50 — no "Attempted"/"Missed" counters.
///
/// Engine-agnostic twin of the Flame page's private `_PenaltyHudPanel`: it
/// takes plain listenables instead of a `PenaltyGame`, so the Unity-backed
/// [PenaltyApp3D] can draw the same card over its platform view from the
/// per-kick events. The Flame copy is left untouched on purpose (that file
/// belongs to the cycle branch and is re-forked often); fold the two together
/// once Unity replaces Flame.
class PenaltyHudPanel extends StatelessWidget {
  const PenaltyHudPanel({
    required this.goals,
    required this.misses,
    required this.missesAllowed,
    required this.scoreToBeat,
    super.key,
  });

  final ValueListenable<int> goals;
  final ValueListenable<int> misses;
  final int missesAllowed;
  final int scoreToBeat;

  static const Color _title = Color(0xFF4ADE80);
  static const Color _label = Color(0xFF86EFAC);
  static const Color _caption = Color(0xB386EFAC);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: const Color(0xCC0A1424),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x2934D399)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Gradient hairline along the top edge (purple → green in the design).
        Container(
          height: 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF7C3AED), Color(0xFF22C55E)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).tifoPenaltyChallenge,
                style: const TextStyle(color: _title, fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: misses,
                      builder: (_, misses, _) {
                        final remaining = (missesAllowed - misses).clamp(0, missesAllowed);
                        return _HudColumn(
                          label: AppLocalizations.of(context).tifoMissesRemaining,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < remaining; i++)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: TifoBallIcon(size: 16),
                                ),
                              for (var i = 0; i < misses; i++)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: TifoMissMark(),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: goals,
                      builder: (_, goals, _) => _HudColumn(
                        label: AppLocalizations.of(context).tifoScored,
                        child: _HudScore(value: goals),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _HudColumn(
                      label: AppLocalizations.of(context).tifoScoreToBeat,
                      child: _HudScore(value: scoreToBeat),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _HudColumn extends StatelessWidget {
  const _HudColumn({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: const TextStyle(color: PenaltyHudPanel._label, fontSize: 12, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      child,
    ],
  );
}

class _HudScore extends StatelessWidget {
  const _HudScore({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        '$value',
        style: const TextStyle(
          color: PenaltyHudPanel._title,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        AppLocalizations.of(context).tifoGoals,
        style: const TextStyle(color: PenaltyHudPanel._caption, fontSize: 11),
      ),
    ],
  );
}
