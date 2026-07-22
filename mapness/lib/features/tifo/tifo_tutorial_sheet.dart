import 'package:flutter/material.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';

/// TIFO tutorial intro sheet — Figma "Activate Tifo (ball toggle)" frame `01`
/// (node 601:104469): shown over the live map right after the ⚽ toggle turns
/// the layer on. One page: dragger, "TIFO TUTORIAL" header + circular close,
/// page dots and a "Start Tutorial →" CTA that hands off to the guided tour.
///
/// Resolves to `true` when the player wants the tour, `false` when dismissed.
Future<bool> showTifoTutorialSheet(BuildContext context) async {
  final start = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: TifoColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => const _TutorialIntroSheet(),
  );
  return start ?? false;
}

class _TutorialIntroSheet extends StatelessWidget {
  const _TutorialIntroSheet();

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: TifoColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text('TIFO TUTORIAL', style: TifoText.h3.copyWith(letterSpacing: 0.4))),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(color: Color(0xFFF2F4F7), shape: BoxShape.circle),
                  child: const Icon(Icons.close_rounded, size: 18, color: TifoColors.textSoft),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const TifoCoachDots(active: 0),
          const SizedBox(height: 24),
          Text(
            'Turn your daily trips into a city-wide football competition. '
            'Claim the buildings, conquer districts, and help your team dominate Riyadh.',
            style: TifoText.bodyL.copyWith(height: 1.35),
          ),
          const SizedBox(height: 24),
          TifoPrimaryButton(
            label: 'Start Tutorial',
            trailingArrow: true,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ),
  );
}

/// The 4 tutorial progress dots (active one is an elongated green pill).
class TifoCoachDots extends StatelessWidget {
  const TifoCoachDots({required this.active, super.key});

  static const int total = 4;

  final int active;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      for (var i = 0; i < total; i++) ...[
        if (i > 0) const SizedBox(width: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: i == active ? 24 : 7,
          height: 6,
          decoration: BoxDecoration(
            color: i == active ? TifoColors.accent : TifoColors.border,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    ],
  );
}
