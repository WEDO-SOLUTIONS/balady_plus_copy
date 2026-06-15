import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/tifo_flow_provider.dart';
import 'package:mapness/features/tifo/tifo_settings_screen.dart';
import 'package:mapness/features/tifo/tifo_team.dart';

/// STEP 1 of 3 — Choose Your Team. Figma node 1:7137 (idle) / 1:7526 (selected).
class TifoTeamSelectScreen extends ConsumerStatefulWidget {
  const TifoTeamSelectScreen({super.key});

  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _cardBg = Color(0xFF141414);
  static const Color _cardBorder = Color(0x12FFFFFF); // rgba(255,255,255,0.07)
  static const Color _textPrimary = Color(0xFFF5F5F5);
  static const Color _textMuted = Color(0xFF616161);
  static const Color _accent = Color(0xFF16A34A);
  static const Color _accentLight = Color(0xFF22C55E);
  static const Color _accentMenlo = Color(0xFF22C55E);

  @override
  ConsumerState<TifoTeamSelectScreen> createState() =>
      _TifoTeamSelectScreenState();
}

class _TifoTeamSelectScreenState extends ConsumerState<TifoTeamSelectScreen> {
  TifoTeam? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TifoTeamSelectScreen._bg,
      body: Column(
        children: [
          _StepHeader(
            stepText: 'STEP 1 OF 3',
            title: 'Choose Your Team',
            progress: 1,
            onBack: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _TeamsGrid(
                    selected: _selected,
                    onTap: (team) => setState(() => _selected = team),
                  ),
                  if (_selected != null) ...[
                    const SizedBox(height: 16),
                    _SelectedCard(team: _selected!),
                  ],
                ],
              ),
            ),
          ),
          _BottomCta(
            label: 'Confirm Team',
            enabled: _selected != null,
            onTap: () {
              final team = _selected;
              if (team == null) return;
              ref.read(tifoFlowProvider.notifier).setSelectedTeam(team);
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  fullscreenDialog: true,
                  builder: (_) => TifoSettingsScreen(team: team),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Header (back + step + progress dots) ────────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({
    required this.stepText,
    required this.title,
    required this.progress,
    required this.onBack,
  });

  final String stepText;
  final String title;
  final int progress; // 1, 2 or 3
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _BackButton(onTap: onBack),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stepText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 8,
                        height: 12 / 8,
                        letterSpacing: 0.8,
                        color: TifoTeamSelectScreen._accentMenlo,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        height: 24 / 16,
                        color: TifoTeamSelectScreen._textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                for (var i = 1; i <= 3; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i <= progress
                            ? TifoTeamSelectScreen._accentLight
                            : Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  if (i < 3) const SizedBox(width: 6),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.75),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 14,
          color: TifoTeamSelectScreen._textPrimary,
        ),
      ),
    );
  }
}

// ─── Teams grid (2×2) ─────────────────────────────────────────────────────────

class _TeamsGrid extends StatelessWidget {
  const _TeamsGrid({required this.selected, required this.onTap});

  final TifoTeam? selected;
  final ValueChanged<TifoTeam> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 175 / 128,
      children: [
        for (final team in TifoTeam.values)
          _TeamCard(
            team: team,
            isSelected: selected == team,
            onTap: () => onTap(team),
          ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({
    required this.team,
    required this.isSelected,
    required this.onTap,
  });

  final TifoTeam team;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? team.primary.withOpacity(0.14)
              : TifoTeamSelectScreen._cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? team.primary
                : TifoTeamSelectScreen._cardBorder,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(17.5),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: team.primary.withOpacity(0.14),
                    border: Border.all(
                      color: team.primary.withOpacity(0.19),
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '🏟',
                    style: TextStyle(fontSize: 22, height: 1.0),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  team.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 18 / 12,
                    color: isSelected
                        ? team.primary
                        : TifoTeamSelectScreen._textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  team.code,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                    height: 13.5 / 9,
                    color: TifoTeamSelectScreen._textMuted,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: team.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Color(0xFF0A0A0A),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── "SELECTED" card ─────────────────────────────────────────────────────────

class _SelectedCard extends StatelessWidget {
  const _SelectedCard({required this.team});

  final TifoTeam team;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: team.primary.withOpacity(0.14),
        border: Border.all(color: team.primary.withOpacity(0.19), width: 0.75),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SELECTED',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 9,
                    height: 13.5 / 9,
                    letterSpacing: 0.225,
                    color: team.primary,
                  ),
                ),
                Text(
                  team.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    height: 19.5 / 13,
                    color: team.primary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ready to fight for Riyadh?',
                  style: TextStyle(
                    fontSize: 10,
                    height: 15 / 10,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          const Text('🏟', style: TextStyle(fontSize: 30, height: 1.0)),
        ],
      ),
    );
  }
}

// ─── Bottom CTA ───────────────────────────────────────────────────────────────

class _BottomCta extends StatelessWidget {
  const _BottomCta({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x0FFFFFFF), width: 0.75),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: enabled ? onTap : null,
            child: Container(
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: enabled ? null : Colors.white.withOpacity(0.06),
                gradient: enabled
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          TifoTeamSelectScreen._accent,
                          TifoTeamSelectScreen._accentLight,
                        ],
                      )
                    : null,
                boxShadow: enabled
                    ? [
                        BoxShadow(
                          color: TifoTeamSelectScreen._accent.withOpacity(0.28),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  height: 22.5 / 15,
                  color: enabled
                      ? Colors.white
                      : TifoTeamSelectScreen._textMuted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
