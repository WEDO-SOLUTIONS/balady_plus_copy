import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/tifo/data/tifo_activity_log.dart';
import 'package:mapness/features/tifo/data/tifo_api.dart';
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/tifo_login.dart';
import 'package:mapness/features/tifo/ui/tifo_message_card.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/utils/detach.dart';

/// Club standings, fetched fresh each time the sheet opens.
final tifoLeaderboardProvider = FutureProvider.autoDispose<List<TifoLeaderRow>>(
  (ref) => ref.read(tifoApiProvider).getLeaderboards(),
);

/// Guards [showTifoLeaderboardSheet] against a rapid double-tap on the
/// trophy control stacking two `ModalBottomSheetRoute`s (seen as the
/// Table/Profile tabs rendering twice). Deliberately module-level rather
/// than State on the trophy button: that button mounts inside a
/// conditional list in `MapDashboardControls`, and a rebuild of its
/// siblings can recreate its Element (resetting any State-held flag)
/// between the two taps.
bool _leaderboardSheetOpening = false;

/// Leaderboard + Dashboard bottom-sheet (BRD US-09/US-10), one panel with
/// Table / Profile tabs, opened from the trophy map control.
Future<void> showTifoLeaderboardSheet(BuildContext context) {
  if (_leaderboardSheetOpening) {
    return Future<void>.value();
  }
  _leaderboardSheetOpening = true;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.themeRead.colors.backgroundSurface1,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (_) => const _LeaderboardSheet(),
  ).whenComplete(() => _leaderboardSheetOpening = false);
}

class _LeaderboardSheet extends ConsumerStatefulWidget {
  const _LeaderboardSheet();

  @override
  ConsumerState<_LeaderboardSheet> createState() => _LeaderboardSheetState();
}

class _LeaderboardSheetState extends ConsumerState<_LeaderboardSheet> {
  int _tab = 0; // 0 = Table (leaderboard), 1 = Profile (dashboard)

  /// Guards the standings-load-error dialog against re-firing on every
  /// rebuild while the error state persists (e.g. a sibling tab switch).
  bool _standingsErrorShown = false;

  @override
  void initState() {
    super.initState();
    // Opened straight from the trophy control (no team-select first), so the
    // roster may not be loaded — without it club rows show slugs + grey crests.
    if (ref.read(tifoSessionProvider).clubs.isEmpty) {
      Future.microtask(() => ref.read(tifoSessionProvider.notifier).load());
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: context.colors.foregroundMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: context.colors.neutralContainerDefault,
                    borderRadius: BorderRadius.circular(TifoRadii.ml),
                  ),
                  child: Icon(Icons.close_rounded, size: 18, color: context.colors.neutralOnContainer),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _Tabs(
              tab: _tab,
              onChanged: (t) {
                setState(() => _tab = t);
                // The profile tab's daily-timer tile (`_NextDailyTile`) reads
                // `profile.secondsToNextDaily` off whatever `/me` snapshot is
                // already cached — which can be from well before this sheet
                // opened. Refresh it on every switch to Profile so a signed-in
                // player sees the current countdown, not a stale one.
                if (t == 1 && !ref.read(tifoSessionProvider).isGuest) {
                  detach(
                    ref.read(tifoSessionProvider.notifier).refreshProfile(),
                    tag: 'leaderboardSheet.refreshProfile',
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Flexible(child: _tab == 0 ? _buildTable() : _buildProfile()),
            const SizedBox(height: 12),
            TifoPrimaryButton(
              label: AppLocalizations.of(context).dominateWithYourTeam,
              trailingArrow: true,
              // Play-intent CTA (BRD FR-03/FR-04): walk the gates on top of
              // the sheet — popping first would dispose this ref mid-journey.
              // Close to the map only once the player is play-ready; on cancel
              // stay on the sheet.
              //
              // The order is tutorial → login → team select (see
              // `TifoSessionState.nextStep`), NOT login first as this comment
              // used to claim: BRD V2 puts the tour ahead of the login wall
              // even for a logged-out player.
              onPressed: () async {
                final gateCtx = rootNavigatorKey.currentContext;
                if (gateCtx == null) {
                  return;
                }
                final ready = await TifoJourney(ref).ensurePlayReady(gateCtx);
                if (ready && mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildTable() {
    final rows = ref.watch(tifoLeaderboardProvider);
    final session = ref.watch(tifoSessionProvider);
    return rows.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator(color: TifoColors.accent)),
      ),
      error: (e, _) {
        if (!_standingsErrorShown) {
          _standingsErrorShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pop();
            final ctx = rootNavigatorKey.currentContext;
            if (ctx == null) {
              return;
            }
            final l10n = AppLocalizations.of(ctx);
            detach(
              showTifoMessageDialog<void>(
                ctx,
                card: TifoMessageCard(
                  showIllustration: true,
                  title: l10n.tifoSomethingWentWrongTitle,
                  body: l10n.tifoSomethingWentWrongBody,
                  primaryAction: TifoMessageAction(
                    label: l10n.tifoRetry,
                    // The sheet (and its autoDispose provider) is already
                    // closed by the pop above — reopening it triggers a
                    // fresh fetch rather than reusing the failed one.
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      detach(showTifoLeaderboardSheet(ctx), tag: 'leaderboardSheet.showTifoLeaderboardSheet');
                    },
                  ),
                  onClose: () => Navigator.of(ctx).pop(),
                ),
              ),
              tag: 'leaderboardSheet.pop',
            );
          });
        }
        return const SizedBox.shrink();
      },
      data: (list) => ListView(
        shrinkWrap: true,
        children: [
          TifoInfoBanner(
            icon: Icons.emoji_events_rounded,
            title: AppLocalizations.of(context).battleForControlContinues,
            subtitle: AppLocalizations.of(context).competeWithOtherTeamsToClaimTheCity,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: context.colors.backgroundSurface1,
              borderRadius: BorderRadius.circular(TifoRadii.l),
              border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      const SizedBox(width: 20, child: Text('#', style: TifoText.captionMedium)),
                      Expanded(
                        flex: 4,
                        child: Text(AppLocalizations.of(context).team, style: TifoText.captionMedium),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          AppLocalizations.of(context).districtsClaimed,
                          style: TifoText.captionMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          AppLocalizations.of(context).buildingsClaimed,
                          style: TifoText.captionMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          AppLocalizations.of(context).mapDominance,
                          style: TifoText.captionMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                for (final row in list) _LeaderRowTile(row: row, club: session.clubById(row.clubId)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: TifoColors.accentContainer,
              borderRadius: BorderRadius.circular(TifoRadii.ml),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(color: context.colors.extra01ContainerDefault, shape: BoxShape.circle),
                  child: Icon(Icons.bolt_rounded, size: 16, color: context.colors.extra01Active),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).takeOverMoreBuildingsToDominateTheTable,
                    style: TifoText.captionMedium.copyWith(color: TifoColors.accentSoft, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Profile / dashboard tab — Figma nodes 696:117570 (signed out) and
  /// 696:117414. Trip counts, daily-allowance countdown, all-time earnings and
  /// match stats are not in the profile API yet — those tiles render zeros
  /// until the backend exposes them.
  Widget _buildProfile() {
    final session = ref.watch(tifoSessionProvider);
    final profile = session.profile;
    final club = session.myClub;
    return ListView(
      shrinkWrap: true,
      children: [
        // Guest bearer gets a lazily-created staging profile, so a non-null
        // profile alone doesn't mean "signed in" — check isGuest too. Also
        // gated on hasLoaded: right after a relaunch the session defaults to
        // isGuest=true/profile=null before `load()` has had a chance to run,
        // which flashed this banner at an already-logged-in player. Hide it
        // instead of asserting "signed out" while the real status is still
        // unknown (see `TifoSessionState.hasLoaded`).
        if (session.hasLoaded && (session.isGuest || profile == null))
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: TifoColors.accentContainer,
              borderRadius: BorderRadius.circular(TifoRadii.l),
              border: Border.all(color: TifoColors.accent, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).tifoLogInToViewProfile,
                    style: TifoText.captionMedium.copyWith(color: TifoColors.accent, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: context.colors.neutralContainerDefault,
                  borderRadius: BorderRadius.circular(TifoRadii.ml),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(TifoRadii.ml),
                    // Host login flow (same as the app's Profile tab); the
                    // session reloads on return so the profile fills in.
                    onTap: () async {
                      await openHostLogin();
                      if (mounted) {
                        await ref.read(tifoSessionProvider.notifier).load();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      child: Text(
                        AppLocalizations.of(context).tifoLogIn,
                        style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TifoColors.accentContainer,
              borderRadius: BorderRadius.circular(TifoRadii.l),
              border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: club == null ? TifoColors.neutralFill : Color(club.colorArgb),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    club?.name ?? AppLocalizations.of(context).tifoNoTeamSelected,
                    style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 10),
        // Tile ORDER is fixed left-to-right regardless of locale (only the
        // Row's child order — each tile's own content still mirrors normally
        // for RTL) — pin it via textDirection rather than a Directionality
        // override so the tiles' internals are unaffected.
        IntrinsicHeight(
          child: Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatTile(
                  label: AppLocalizations.of(context).currentTokens,
                  value: '${profile?.balance ?? 0}',
                  chipBg: context.colors.extra01ContainerDefault,
                  icon: Icon(Icons.bolt_rounded, size: 16, color: context.colors.extra01Default),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _NextDailyTile(secondsToNextDaily: profile?.secondsToNextDaily)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _StatTile(
                  label: AppLocalizations.of(context).everyTripYouCompleteEarnsYouTokens,
                  value: '${profile?.tripTokensToday ?? 0}',
                  caption: AppLocalizations.of(context).today,
                  chipBg: context.colors.extra01ContainerDefault,
                  // Design artwork (Marker) — multi-color, so it is drawn as-is
                  // instead of being tinted like the Material-glyph tiles.
                  icon: Assets.imagesSvg.tifoTripMarker.svg(
                    height: 16,
                    width: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  label: AppLocalizations.of(context).tokensEarned,
                  value: '${profile?.allTimeEarned ?? 0}',
                  caption: AppLocalizations.of(context).allTime,
                  chipBg: context.colors.accentContainerDefault,
                  // Design artwork (coins) — multi-color, drawn untinted.
                  icon: Assets.imagesSvg.tifoTokens.svg(width: 16, height: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.colors.backgroundSurface1,
            borderRadius: BorderRadius.circular(TifoRadii.l),
            border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.sports_esports_rounded, size: 18, color: context.colors.foregroundDefault),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).matchesPlayed,
                    style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // US-10: Total / Won / Lose (no Draw) + "Claimed" = buildings
              // currently held. All four come from `/me` (stats block).
              Row(
                children: [
                  _MatchStat(
                    value: '${profile?.gamesTotal ?? 0}',
                    label: AppLocalizations.of(context).total,
                    chipBg: context.colors.neutralContainerDefault,
                    icon: Icons.sports_esports_rounded,
                    iconColor: context.colors.staticSoftBlue,
                  ),
                  _MatchStat(
                    value: '${profile?.gamesWon ?? 0}',
                    label: AppLocalizations.of(context).wins,
                    chipBg: context.colors.warningContainerDefault,
                    icon: Icons.emoji_events_rounded,
                    iconColor: context.colors.warningSoft,
                  ),
                  _MatchStat(
                    value: '${profile?.gamesLost ?? 0}',
                    label: AppLocalizations.of(context).losses,
                    chipBg: context.colors.errorContainerDefault,
                    icon: Icons.cancel_rounded,
                    iconColor: context.colors.errorDefault,
                  ),
                  _MatchStat(
                    value: '${profile?.buildingsOwned ?? 0}',
                    label: AppLocalizations.of(context).claimed,
                    chipBg: context.colors.accentContainerDefault,
                    icon: Icons.apartment_rounded,
                    iconColor: context.colors.accentDefault,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _buildRecentActivity(),
      ],
    );
  }

  /// Local-only feed (BE-233 follow-up: no backend history endpoint exists
  /// yet — see `TifoActivityLogController`), so this can only show events
  /// logged on this device from now on, not a pre-existing server history.
  Widget _buildRecentActivity() {
    final activityAsync = ref.watch(tifoActivityLogProvider);
    final activity = activityAsync.value ?? const <TifoActivityEntry>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context).recentActivity,
                style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault),
              ),
            ),
            if (activity.length > 3)
              InkWell(
                onTap: () => _showAllActivity(activity),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context).viewAll,
                      style: TifoText.captionMedium.copyWith(color: TifoColors.accent, fontSize: 13),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: TifoColors.accent),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        if (activity.isEmpty)
          Text(AppLocalizations.of(context).noData, style: TifoText.captionRegular.copyWith(fontSize: 13))
        else
          for (final entry in activity.take(3)) _ActivityRow(entry: entry),
      ],
    );
  }

  void _showAllActivity(List<TifoActivityEntry> activity) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.themeRead.colors.backgroundSurface1,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(sheetContext).recentActivity,
              style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [for (final entry in activity) _ActivityRow(entry: entry)],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.entry});

  final TifoActivityEntry entry;

  static String _label(BuildContext context, TifoActivityType type) => switch (type) {
    TifoActivityType.win => AppLocalizations.of(context).youWonAPenaltyChallenge,
    TifoActivityType.loss => AppLocalizations.of(context).youLostAPenaltyChallenge,
    TifoActivityType.tripCompleted => AppLocalizations.of(context).tripCompleted,
  };

  /// Chip artwork + its background per activity type. The artwork is built
  /// ready to paint: Material glyphs stay themed, while the trip marker is
  /// design artwork (multi-color) and must be drawn untinted.
  Map<TifoActivityType, (Widget, Color)> _iconByType(BuildContext context) => {
    TifoActivityType.win: (
      Icon(Icons.emoji_events_rounded, size: 15, color: context.colors.warningDefault),
      context.colors.warningContainerDefault,
    ),
    TifoActivityType.loss: (
      Icon(Icons.cancel_rounded, size: 15, color: context.colors.errorDefault),
      context.colors.errorContainerDefault,
    ),
    TifoActivityType.tripCompleted: (
      Assets.imagesSvg.tifoTripMarker.svg(height: 15),
      context.colors.extra01ContainerDefault,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, chipBg) = _iconByType(context)[entry.type]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: chipBg, shape: BoxShape.circle),
            child: Center(child: icon),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _label(context, entry.type),
              style: TifoText.captionMedium.copyWith(color: context.colors.foregroundDefault),
            ),
          ),
          if (entry.tokenDelta != null) ...[
            Text(
              '+${entry.tokenDelta}',
              style: TifoText.captionMedium.copyWith(color: context.colors.foregroundDefault),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.bolt_rounded, size: 12, color: Color(0xFF7C3AED)),
            const SizedBox(width: 6),
          ],
          Text(_relativeTime(context, entry.timestamp), style: TifoText.captionRegular),
        ],
      ),
    );
  }

  static String _relativeTime(BuildContext context, DateTime timestamp) {
    final l10n = AppLocalizations.of(context);
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) {
      return l10n.tifoJustNow;
    }
    if (diff.inHours < 1) {
      return l10n.tifoMinutesAgo(diff.inMinutes);
    }
    if (diff.inDays < 1) {
      return l10n.tifoHoursAgo(diff.inHours);
    }
    return l10n.tifoDaysAgo(diff.inDays);
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.tab, required this.onChanged});

  final int tab;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: _tabButton(AppLocalizations.of(context).table, 0, context)),
      const SizedBox(width: 8),
      Expanded(child: _tabButton(AppLocalizations.of(context).profile, 1, context)),
    ],
  );

  Widget _tabButton(String label, int index, BuildContext context) {
    final active = tab == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(index),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? TifoColors.accent : context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(TifoRadii.ml),
          border: Border.all(color: active ? TifoColors.accent : TifoColors.border),
        ),
        child: Text(
          label,
          style: TifoText.bodyLSemi.copyWith(color: active ? TifoColors.onAccent : context.colors.foregroundDefault),
        ),
      ),
    );
  }
}

class _LeaderRowTile extends StatelessWidget {
  const _LeaderRowTile({required this.row, required this.club});

  final TifoLeaderRow row;
  final TifoClubInfo? club;

  @override
  Widget build(BuildContext context) {
    final club = this.club;
    final color = club == null ? TifoColors.neutralFill : Color(club.colorArgb);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text('${row.rank}', style: TifoText.bodyLSemi.copyWith(color: context.colors.foregroundDefault)),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    club?.name ?? row.clubId,
                    style: TifoText.bodyMSemi.copyWith(color: context.colors.foregroundDefault),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${row.districts}',
              style: TifoText.bodyMSemi.copyWith(color: context.colors.foregroundDefault),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${row.buildings}',
              style: TifoText.bodyMSemi.copyWith(color: context.colors.foregroundDefault),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${row.ownershipPct}%',
                  style: TifoText.bodyMSemi.copyWith(color: context.colors.foregroundDefault),
                ),
                const SizedBox(height: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: (row.ownershipPct / 100).clamp(0, 1),
                    minHeight: 5,
                    backgroundColor: TifoColors.border,
                    valueColor: const AlwaysStoppedAnimation(TifoColors.accent),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Next daily tokens in" tile — counts down locally from the server's
/// `secondsToNextDaily` (the game day rolls at 00:00 Asia/Riyadh, so the
/// device clock and timezone can't be trusted to compute it).
class _NextDailyTile extends StatefulWidget {
  const _NextDailyTile({required this.secondsToNextDaily});

  final int? secondsToNextDaily;

  @override
  State<_NextDailyTile> createState() => _NextDailyTileState();
}

class _NextDailyTileState extends State<_NextDailyTile> {
  Timer? _ticker;
  late int _left = widget.secondsToNextDaily ?? 0;

  @override
  void initState() {
    super.initState();
    _restart();
  }

  @override
  void didUpdateWidget(_NextDailyTile old) {
    super.didUpdateWidget(old);
    // A profile refresh (daily claim, trip reward) re-seeds the countdown.
    if (old.secondsToNextDaily != widget.secondsToNextDaily) {
      _left = widget.secondsToNextDaily ?? 0;
      _restart();
    }
  }

  void _restart() {
    _ticker?.cancel();
    if (_left <= 0) {
      return;
    }
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _left = _left <= 1 ? 0 : _left - 1);
      if (_left == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _left ~/ 3600;
    final minutes = (_left % 3600) ~/ 60;
    final seconds = _left % 60;
    final two = (int v) => v.toString().padLeft(2, '0');
    return _StatTile(
      label: AppLocalizations.of(context).nextDailyTokensIn,
      value: _left <= 0 ? '--' : '${two(hours)}:${two(minutes)}',
      caption: _left <= 0 ? AppLocalizations.of(context).tifoHhMm : '${two(seconds)}s',
      chipBg: context.colors.warningContainerDefault,
      icon: Icon(Icons.schedule_rounded, size: 16, color: context.colors.warningActive),
    );
  }
}

/// Dashboard stat tile (design 696:117570): caption label on top, icon chip +
/// big value below, green border.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.chipBg,
    required this.icon,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;
  final Color chipBg;

  /// Chip artwork, already sized and colored — a themed [Icon] for the tiles
  /// design left on Material glyphs, or a multi-color SVG for the ones it
  /// gave artwork to (which must NOT be tinted).
  final Widget icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.colors.backgroundSurface1,
      borderRadius: BorderRadius.circular(TifoRadii.l),
      border: Border.all(color: TifoColors.accentMuted.withValues(alpha: 0.5), width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TifoText.captionRegular.copyWith(fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: chipBg, shape: BoxShape.circle),
              child: Center(child: icon),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TifoText.h3.copyWith(color: context.colors.foregroundDefault)),
                  if (caption != null) Text(caption!, style: TifoText.captionRegular),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

/// One column of the "Matches Played" card: colored icon chip, value, label.
class _MatchStat extends StatelessWidget {
  const _MatchStat({
    required this.value,
    required this.label,
    required this.chipBg,
    required this.icon,
    required this.iconColor,
  });

  final String value;
  final String label;
  final Color chipBg;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(height: 6),
        Text(value, style: TifoText.h3.copyWith(color: context.colors.foregroundDefault)),
        Text(label, style: TifoText.captionRegular),
      ],
    ),
  );
}
