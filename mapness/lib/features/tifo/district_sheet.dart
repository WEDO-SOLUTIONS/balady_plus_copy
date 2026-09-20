import 'dart:async';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/balady_analytics/events/tifo_events.dart' show TifoActivationSource;
import 'package:mapness/features/tifo/data/tifo_models.dart';
import 'package:mapness/features/tifo/providers/tifo_session_provider.dart';
import 'package:mapness/features/tifo/tifo_journey.dart';
import 'package:mapness/features/tifo/ui/tifo_theme.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';

/// District details bottom sheet — Figma "district details" (node 696:119272,
/// BRD US-06). Opened by tapping a district polygon in the low-zoom TIFO
/// layer. Header + Current Owner card + Overview stats + per-club claim
/// breakdown, all from `GET /districts/summary`; "Take over the district"
/// zooms the camera into the district at building zoom.
Future<void> showTifoDistrictSheet(
  BuildContext context, {
  required TifoDistrict district,
  TifoDistrictSummary? summary,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: context.themeRead.colors.backgroundSurface1,
  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
  builder: (_) => _DistrictSheet(district: district, summary: summary),
);

class _DistrictSheet extends ConsumerStatefulWidget {
  const _DistrictSheet({required this.district, this.summary});

  final TifoDistrict district;
  final TifoDistrictSummary? summary;

  @override
  ConsumerState<_DistrictSheet> createState() => _DistrictSheetState();
}

class _DistrictSheetState extends ConsumerState<_DistrictSheet> {
  @override
  void initState() {
    super.initState();
    // Club roster is needed for names/colors in the breakdown; the sheet can
    // open before any TIFO screen has loaded the session.
    if (ref.read(tifoSessionProvider).clubs.isEmpty) {
      Future.microtask(() => ref.read(tifoSessionProvider.notifier).load());
    }
  }

  /// Naive centroid of the district's first outer ring — good enough to aim
  /// the camera at.
  ({double lat, double lng})? get _centroid {
    final rings = widget.district.rings;
    if (rings.isEmpty || rings.first.isEmpty) {
      return null;
    }
    var lat = 0.0, lng = 0.0;
    for (final p in rings.first) {
      lat += p.latitude;
      lng += p.longitude;
    }
    final n = rings.first.length;
    return (lat: lat / n, lng: lng / n);
  }

  /// Same play-gate as "Dominate with your team" (BRD FR-03/FR-04): walk
  /// tutorial → login → team select first, same as any other play-intent CTA
  /// — only once the player is play-ready does this actually zoom the camera.
  /// The district sheet stays open through the walk (gate screens are pushed
  /// on the root navigator, above it) and only closes once we're really
  /// about to zoom, so backing out of a gate leaves the player where they
  /// were instead of dropping them back on the map mid-flow.
  Future<void> _takeOver() async {
    final gateCtx = rootNavigatorKey.currentContext;
    if (gateCtx == null) {
      return;
    }
    final ready = await TifoJourney(ref).ensurePlayReady(gateCtx, source: TifoActivationSource.districtSheet);
    if (!ready || !mounted) {
      return;
    }
    final navigator = Navigator.of(context);
    final target = _centroid;
    navigator.pop();
    if (target == null) {
      return;
    }
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      await controller.moveCamera(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: target.lat, longitude: target.lng),
          zoom: 16.5, // buildings mode (LOD threshold is 15 on the rect stream)
          tilt: 0,
          bearing: 0,
        ),
        0.6,
        CameraAnimationTypeMessage.linear,
      );
    } catch (_) {
      // Map is gone — nothing to zoom.
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    final session = ref.watch(tifoSessionProvider);
    final leaderSlug = summary?.leaderClub;
    final leaderClub = leaderSlug == null ? null : session.clubById(leaderSlug);
    final leaderColor = leaderClub != null
        ? Color(leaderClub.colorArgb)
        : Color(summary?.leaderColorArgb ?? kTifoNeutralStrokeArgb);
    final leaderName = summary == null || summary.isNeutral
        ? AppLocalizations.of(context).tifoUnclaimed
        : (leaderClub?.name ?? leaderSlug!);

    // Per-club breakdown, most buildings first. Slugs resolve to roster
    // names/colors once the session loads; until then show the raw slug.
    final breakdown = (summary?.counts.entries.toList() ?? const [])..sort((a, b) => b.value.compareTo(a.value));

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(color: TifoColors.accentContainer, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.colors.neutralContainerDefault,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: TifoColors.accentContainer),
                    ),
                    child: const Icon(Icons.close_rounded, size: 16, color: TifoColors.accentSoft),
                  ),
                ),
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context).tifoDistrictLabel,
                  style: TifoText.h3.copyWith(color: context.colors.foregroundDefault),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  widget.district.name ?? summary?.name ?? widget.district.id,
                  style: TifoText.captionRegular.copyWith(color: TifoColors.accent),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // ── Current Owner ─────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(17.5),
                      decoration: BoxDecoration(
                        color: TifoColors.accentContainer,
                        borderRadius: BorderRadius.circular(TifoRadii.l),
                        border: Border.all(color: TifoColors.accent, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).tifoCurrentOwner,
                            style: TifoText.captionMedium.copyWith(color: TifoColors.accent),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: leaderColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      leaderName,
                                      style: TifoText.bodyLSemi.copyWith(color: TifoColors.accent),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (summary != null && !summary.isNeutral)
                                      Text(
                                        '${AppLocalizations.of(context).tifoSince} '
                                        '${tifoStandingDaysAgo(context, summary.standingDays)}',
                                        style: TifoText.captionRegular.copyWith(color: TifoColors.accent),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${summary?.controlPct ?? 0}%',
                                    style: TifoText.h2.copyWith(color: TifoColors.accent),
                                  ),
                                  Text(
                                    AppLocalizations.of(context).tifoDistrictControl,
                                    style: TifoText.captionRegular.copyWith(color: TifoColors.accent),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ── Overview ──────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(17.5),
                      decoration: BoxDecoration(
                        color: context.colors.backgroundSurface1,
                        borderRadius: BorderRadius.circular(TifoRadii.l),
                        border: Border.all(color: TifoColors.neutralFill, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context).tifoOverview,
                            style: TifoText.captionMedium.copyWith(color: context.colors.foregroundDefault),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.apartment_rounded, size: 40, color: TifoColors.accentSoft),
                              const SizedBox(width: 16),
                              _stat('${summary?.totalBuildings ?? 0}', AppLocalizations.of(context).tifoInThisDistrict),
                              _divider(),
                              _stat('${summary?.claimed ?? 0}', AppLocalizations.of(context).claimed),
                              _divider(),
                              _stat('${summary?.free ?? 0}', AppLocalizations.of(context).tifoFree),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ── Buildings claimed by each team ────────────────────
                    if (breakdown.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(17.5),
                        decoration: BoxDecoration(
                          color: context.colors.backgroundSurface1,
                          borderRadius: BorderRadius.circular(TifoRadii.l),
                          border: Border.all(color: TifoColors.neutralFill, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).tifoBuildingsClaimedByEachTeam,
                              style: TifoText.captionMedium.copyWith(color: context.colors.foregroundDefault),
                            ),
                            for (final entry in breakdown) _clubRow(session, entry.key, entry.value),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TifoPrimaryButton(
                label: AppLocalizations.of(context).tifoTakeOverTheDistrict,
                trailingArrow: true,
                onPressed: () => detach(_takeOver(), tag: 'districtSheet.takeOver'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _clubRow(TifoSessionState session, String slug, int claimed) {
    final club = session.clubById(slug);
    final color = club != null ? Color(club.colorArgb) : TifoColors.neutralFill;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  club?.name ?? slug,
                  style: TifoText.h4.copyWith(color: color),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  AppLocalizations.of(context).tifoInThisDistrict,
                  style: TifoText.captionRegular.copyWith(color: context.colors.foregroundDefault),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$claimed', style: TifoText.bodyL.copyWith(color: context.colors.foregroundDefault)),
              Text(
                AppLocalizations.of(context).claimed,
                style: TifoText.captionRegular.copyWith(color: context.colors.foregroundDefault),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            value,
            style: TifoText.h2.copyWith(color: TifoColors.accentSoft),
            maxLines: 1,
          ),
        ),
        Text(label, style: TifoText.captionRegular.copyWith(color: context.colors.foregroundDefault)),
      ],
    ),
  );

  static Widget _divider() => Container(
    width: 1,
    height: 48,
    margin: const EdgeInsets.symmetric(horizontal: 12),
    color: TifoColors.border,
  );
}
