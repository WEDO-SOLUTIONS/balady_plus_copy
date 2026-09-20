import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/ui/tifo_message_card.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Two-step onboarding flow (BRD US-04), rebuilt to the Figma light design:
///   STEP 1 — Choose your team (roster data-driven from `GET /clubs`, rendered
///            as solid team-color cards; season-lock banner);
///   STEP 2 — Your Tokens (welcome-bonus acknowledgement).
/// Confirming opens the "Team confirmation" bottom sheet first — the pick is a
/// one-time season commitment, so it does not fire on a single tap — and only
/// on Confirm calls `POST /clubs/select` (grants the welcome bonus) and shows
/// step 2; "Claim the map" pops `true`. On step 1 "Maybe Later"/back pop
/// `false` (browse-only).
///
/// Step 2 has NO way back to step 1 and no "Maybe Later", on purpose: the club
/// pick is a one-time season commitment the server has already honoured by the
/// time step 2 renders (`POST /clubs/select` granted the welcome bonus). Every
/// exit from step 2 therefore reports success — the alternative was offering a
/// choice that cannot be remade, where picking a different team just failed
/// against the server.
class TifoTeamSelectScreen extends ConsumerStatefulWidget {
  const TifoTeamSelectScreen({required this.source, super.key});

  /// Entry point the play-gate walk started from — reported as `tifo_activated`'s `source`.
  /// Must describe the TAP, not this screen — that answers "which door actually converts".
  final TifoActivationSource source;

  @override
  ConsumerState<TifoTeamSelectScreen> createState() => _TifoTeamSelectScreenState();
}

class _TifoTeamSelectScreenState extends ConsumerState<TifoTeamSelectScreen> {
  int _step = 1;
  String? _selectedId;
  bool _isBusy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (ref.read(tifoSessionProvider).clubs.isEmpty) {
      Future.microtask(() => ref.read(tifoSessionProvider.notifier).load());
    }
  }

  void _pop(bool result) => Navigator.of(context).pop(result);

  /// Team confirmation prompt (Figma "Team confirmation"): the season lock is
  /// irreversible until the next season, so `POST /clubs/select` is only sent
  /// after an explicit Confirm. Cancel / close / swipe-away leave the pick
  /// selected but uncommitted, so the player can switch cards and try again.
  Future<void> _promptConfirm() async {
    if (_selectedId == null || _isBusy) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    final confirmed = await showTifoMessageDialog<bool>(
      context,
      card: TifoMessageCard(
        title: l10n.tifoTeamConfirmationTitle,
        body: l10n.tifoTeamConfirmationBody,
        titleIcon: Icons.warning_rounded,
        onClose: () => Navigator.of(context).pop(false),
        // `tifoCancel`, not the app-wide `cancel`: the TIFO copy spells it
        // الغاء, and changing the shared key would touch every other screen.
        secondaryAction: TifoMessageAction(label: l10n.tifoCancel, onPressed: () => Navigator.of(context).pop(false)),
        primaryAction: TifoMessageAction(label: l10n.confirm, onPressed: () => Navigator.of(context).pop(true)),
      ),
    );
    // The sheet is a route: by the time it pops the screen may be gone (back
    // out of the flow while it was open), so re-check before touching state.
    if (!(confirmed ?? false) || !mounted) {
      return;
    }
    await _confirm();
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
      // The moment the user becomes a player (BRD US-04). Once per install —
      // the cap lives in TifoEvents; `/clubs/select` is the server's own
      // one-time gate.
      unawaited(TifoEvents.activated(clubId: clubId, source: widget.source));
      if (mounted) {
        setState(() {
          _isBusy = false;
          _step = 2;
        });
      }
    } catch (e) {
      logger.log('[tifo] club select failed: $e');
      if (mounted) {
        setState(() {
          _isBusy = false;
          // Not `e.toString()`: that put a raw Dart exception on screen, in
          // English, for an Arabic build too. The detail belongs in the log.
          _error = AppLocalizations.of(context).tifoSomethingWentWrongBody;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(tifoSessionProvider.select((s) => s.clubs));

    return Scaffold(
      backgroundColor: context.colors.backgroundSurface1,
      body: Column(
        children: [
          TifoStepHeader(
            step: _step,
            total: 2,
            title: _step == 1 ? AppLocalizations.of(context).chooseYourTeam : AppLocalizations.of(context).yourTokens,
            // Step 2 exits, it does not rewind. The club is committed
            // server-side by then, so going "back" to the team list showed a
            // live-looking choice whose confirm hit `POST /clubs/select` a
            // second time and failed — the player could neither change teams
            // nor understand why.
            onBack: _step != 2 ? () => _pop(_step != 1) : null,
          ),
          Expanded(child: _step == 1 ? _buildTeamList(clubs) : _buildWelcomeBonus()),
          _buildBottom(),
        ],
      ),
    );
  }

  Widget _buildTeamList(List<TifoClubInfo> clubs) {
    if (clubs.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: TifoColors.accent));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        TifoInfoBanner(
          icon: Icons.lock_outline_rounded,
          title: AppLocalizations.of(context).yourTeamWillBeLockedForTheSeason,
          subtitle: AppLocalizations.of(context).youCanChangeTeamsWhenTheNextSeasonBegins,
        ),
        const SizedBox(height: 16),
        for (final club in clubs)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TeamCard(
              club: club,
              selected: _selectedId == club.id,
              onTap: () => setState(() => _selectedId = club.id),
            ),
          ),
        if (_error != null) ...[
          const SizedBox(height: 4),
          Text(_error!, style: const TextStyle(color: Color(0xFFE5484D), fontSize: 13)),
        ],
      ],
    );
  }

  Widget _buildWelcomeBonus() {
    final welcomeBonus = ref.watch(tifoSessionProvider.select((s) => s.profile?.welcomeBonus));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: TifoColors.accentContainer,
              borderRadius: BorderRadius.circular(TifoRadii.ml),
              border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Text('🎁', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).welcomeBonus,
                      style: TifoText.overline.copyWith(color: TifoColors.textSoft),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context).tokensCount(welcomeBonus ?? 15),
                      style: TifoText.h3.copyWith(color: TifoColors.accentSoft),
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

  Widget _buildBottom() => Container(
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: TifoColors.border)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_step == 1)
              TifoPrimaryButton(
                label: AppLocalizations.of(context).confirmTeam,
                busy: _isBusy,
                onPressed: _selectedId != null ? _promptConfirm : null,
              )
            else
              TifoPrimaryButton(label: AppLocalizations.of(context).claimTheMap, onPressed: () => _pop(true)),
            // Only on step 1: there is nothing left to defer once the club is
            // granted, and popping `false` from step 2 told `TifoJourney` the
            // player wasn't play-ready — discarding a completed onboarding.
            if (_step == 1) ...[
              const SizedBox(height: 4),
              TifoGhostButton(
                label: AppLocalizations.of(context).maybeLater,
                onPressed: _isBusy ? null : () => _pop(false),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Full-width solid team-color card; selected → accent ring + white check.
class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.club, required this.selected, required this.onTap});

  final TifoClubInfo club;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(club.colorArgb);
    final ink = tifoInkOn(color);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(TifoRadii.l),
          border: Border.all(
            color: selected ? TifoColors.accent : Colors.transparent,
            width: 3,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                club.name,
                style: TifoText.bodyLSemi.copyWith(color: ink),
              ),
            ),
            if (selected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: TifoColors.accent, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.check_rounded, size: 15, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
