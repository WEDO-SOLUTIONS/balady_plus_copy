import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';

/// STEP 1 OF 2 — Choose your team. Roster is data-driven from `GET /clubs`
/// (BRD: the club list is per-season data, not a fixed enum). Confirming calls
/// `POST /clubs/select` (which grants the welcome bonus) and pops `true`;
/// "Maybe Later" / back pops `false` → browse-only.
class TifoTeamSelectScreen extends ConsumerStatefulWidget {
  const TifoTeamSelectScreen({super.key});

  static const Color _bg = Color(0xFF0A0A0A);
  static const Color _cardBg = Color(0xFF141414);
  static const Color _cardBorder = Color(0x12FFFFFF);
  static const Color _textPrimary = Color(0xFFF5F5F5);
  static const Color _textMuted = Color(0xFF9E9E9E);
  static const Color _accent = Color(0xFF1B8354); // flat-green per current design

  @override
  ConsumerState<TifoTeamSelectScreen> createState() => _TifoTeamSelectScreenState();
}

class _TifoTeamSelectScreenState extends ConsumerState<TifoTeamSelectScreen> {
  String? _selectedId;
  bool _isBusy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Ensure the roster is loaded (journey usually pre-loads, but be safe).
    if (ref.read(tifoSessionProvider).clubs.isEmpty) {
      Future.microtask(() => ref.read(tifoSessionProvider.notifier).load());
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(tifoSessionProvider.select((s) => s.clubs));

    return Scaffold(
      backgroundColor: TifoTeamSelectScreen._bg,
      body: Column(
        children: [
          const _StepHeader(stepText: 'STEP 1 OF 2', title: 'Choose your team'),
          const _SeasonLockBanner(),
          Expanded(
            child: clubs.isEmpty
                ? const Center(child: CircularProgressIndicator(color: TifoTeamSelectScreen._accent))
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    children: [
                      for (final club in clubs)
                        _ClubRow(
                          club: club,
                          isSelected: _selectedId == club.id,
                          onTap: () => setState(() => _selectedId = club.id),
                        ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Text(_error!, style: const TextStyle(color: Color(0xFFF04438), fontSize: 13)),
                      ],
                    ],
                  ),
          ),
          _BottomCta(
            enabled: _selectedId != null && !_isBusy,
            isBusy: _isBusy,
            onConfirm: _confirm,
            onMaybeLater: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm() async {
    final clubId = _selectedId;
    if (clubId == null) {
      return;
    }
    setState(() {
      _isBusy = true;
      _error = null;
    });
    try {
      await ref.read(tifoSessionProvider.notifier).selectClub(clubId);
      if (!mounted) {
        return;
      }
      // Step 2 of the BRD flow — the welcome-bonus acknowledgement.
      await _showWelcomeBonus();
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isBusy = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _showWelcomeBonus() {
    final balance = ref.read(tifoSessionProvider).profile?.balance;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: TifoTeamSelectScreen._cardBg,
        title: const Text('Welcome bonus', style: TextStyle(color: TifoTeamSelectScreen._textPrimary)),
        content: Text(
          balance == null
              ? 'Your team is locked in for the season. Tokens have been added to your balance.'
              : 'Your team is locked in for the season. You now have $balance tokens.',
          style: const TextStyle(color: TifoTeamSelectScreen._textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Let's go", style: TextStyle(color: TifoTeamSelectScreen._accent)),
          ),
        ],
      ),
    );
  }
}

// ─── Header (step + 2 progress dots) ─────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.stepText, required this.title});

  final String stepText;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _BackButton(onTap: () => Navigator.of(context).pop(false)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stepText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 9,
                        letterSpacing: 0.8,
                        color: TifoTeamSelectScreen._accent,
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: TifoTeamSelectScreen._textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (var i = 1; i <= 2; i++) ...[
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i == 1 ? TifoTeamSelectScreen._accent : Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  if (i < 2) const SizedBox(width: 6),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonLockBanner extends StatelessWidget {
  const _SeasonLockBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_clock_rounded, size: 18, color: TifoTeamSelectScreen._textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Your team will be locked for the season',
                  style: TextStyle(color: TifoTeamSelectScreen._textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  'You can change teams when the next season begins.',
                  style: TextStyle(color: TifoTeamSelectScreen._textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
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
        child: const Icon(Icons.arrow_back_ios_new, size: 14, color: TifoTeamSelectScreen._textPrimary),
      ),
    );
  }
}

// ─── Club row (data-driven) ──────────────────────────────────────────────────

class _ClubRow extends StatelessWidget {
  const _ClubRow({required this.club, required this.isSelected, required this.onTap});

  final TifoClubInfo club;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(club.colorArgb);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.14) : TifoTeamSelectScreen._cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? color : TifoTeamSelectScreen._cardBorder, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: Text(
                  club.short,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  club.name,
                  style: TextStyle(
                    color: isSelected ? color : TifoTeamSelectScreen._textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom CTA (Confirm + Maybe Later) ──────────────────────────────────────

class _BottomCta extends StatelessWidget {
  const _BottomCta({
    required this.enabled,
    required this.isBusy,
    required this.onConfirm,
    required this.onMaybeLater,
  });

  final bool enabled;
  final bool isBusy;
  final VoidCallback onConfirm;
  final VoidCallback onMaybeLater;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x0FFFFFFF), width: 0.75)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: enabled ? onConfirm : null,
                child: Container(
                  height: 54,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: enabled ? TifoTeamSelectScreen._accent : Colors.white.withOpacity(0.06),
                  ),
                  child: isBusy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'Confirm Team',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: enabled ? Colors.white : TifoTeamSelectScreen._textMuted,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: isBusy ? null : onMaybeLater,
                child: const Text(
                  'Maybe Later',
                  style: TextStyle(color: TifoTeamSelectScreen._textMuted, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
