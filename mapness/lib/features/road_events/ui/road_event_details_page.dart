import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/icon_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart' show LocationFollowType;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/features/road_events/data/road_events_datasource.dart';
import 'package:mapness/features/road_events/data/road_events_dio.dart';
import 'package:mapness/features/road_events/domain/road_event.dart';
import 'package:mapness/features/road_events/helpers/road_event_type_label.dart';
import 'package:mapness/features/road_events/providers/road_event_marker_bitmap.dart';
import 'package:mapness/features/road_events/providers/road_events_markers.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/follow_state.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

import 'widgets/report_road_event_lanes.dart';

/// Shown for taps on a road-event map marker, surfacing the event's `type`
/// and the `lanes` it affects.
@RoutePage()
class RoadEventDetailsPage extends StatefulHookConsumerWidget {
  const RoadEventDetailsPage({
    required this.id,
    required this.location,
    required this.createdAt,
    required this.expiresAt,
    required this.type,
    required this.lanes,
    required this.feedback,
    required this.updatedAt,
    this.hasBarrier = false,
    super.key,
  });

  final String id;
  final RoadEventLocation location;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final RoadEventType? type;
  final Set<RoadEventLane> lanes;
  final RoadEventFeedback feedback;
  final DateTime? updatedAt;
  final bool hasBarrier;

  @override
  ConsumerState<RoadEventDetailsPage> createState() => _RoadEventDetailsPageState();
}

class _RoadEventDetailsPageState extends ConsumerState<RoadEventDetailsPage> {
  bool _isClosing = false;
  bool _isSubmitting = false;
  bool _wasFollowing = false;

  RoadEventSheetState get _initialRoadEventState => RoadEventSheetState(
    id: widget.id,
    location: widget.location,
    createdAt: widget.createdAt,
    expiresAt: widget.expiresAt,
    type: widget.type,
    lanes: widget.lanes,
    feedback: widget.feedback,
    updatedAt: widget.updatedAt,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      unawaited(selectEvent(_currentRoadEventState));
    });
    _wasFollowing = ref.read(followStateProvider).type != LocationFollowType.off;
    if (_wasFollowing) {
      ref.read(dgisControllerProvider).value?.stopFollowNavigation();
    }
  }

  @override
  void deactivate() {
    if (_wasFollowing) {
      ref.read(dgisControllerProvider).value?.startFollowNavigation();
    }
    super.deactivate();
  }

  RoadEventSheetState get _currentRoadEventState => ref.read(roadEventsProvider) ?? _initialRoadEventState;

  Future<void> selectEvent(RoadEventSheetState state) async {
    final marker = await roadEventMarker(
      RoadEvent(
        id: state.id,
        type: state.type ?? RoadEventType.danger,
        location: state.location,
        lanes: state.lanes,
        feedback: state.feedback,
      ),
      () {},
      bitmap: ref.read(roadEventMarkerBitmapProvider),
      devicePixelRatio: WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio,
    );
    await ref.read(selectedMarkerProvider.notifier).showMarker(marker, settings: roadEventsMarkersSettings);
  }

  Future<void> removeSelection(RoadEventSheetState state) async {
    await ref.read(selectedMarkerProvider.notifier).clear();
  }

  /// Submits a "still there"/"not anymore" verdict for the currently open road
  /// event via `POST /events/{id}/feedback`.
  Future<void> _performAction(RoadEventActionType type) async {
    if (_isSubmitting) {
      return;
    }
    await ref
        .read(authMethodsProvider.notifier)
        .authAndOpen(
          context,
          callback: () async {
            if (!mounted) {
              return;
            }
            setState(() => _isSubmitting = true);
            try {
              final userLocation = ref.read(locationProvider);
              if (userLocation == null) {
                throw Exception('No user location available for road event feedback');
              }
              final dio = await ref.read(roadEventsDioProvider.future);
              final datasource = RoadEventsDatasource(dio: dio);
              await datasource.submitFeedback(
                eventId: _currentRoadEventState.id,
                type: type,
                location: RoadEventLocation(latitude: userLocation.latitude, longitude: userLocation.longitude),
                source: 'map',
              );
              if (!mounted) {
                return;
              }
              await _onClose();
              if (!mounted) {
                return;
              }
              await context.router.push(RoadEventActionResultRoute(type: type));
              await _onClose();
            } catch (e) {
              if (mounted) {
                ToastOverlay.of(context).show(title: context.l10n.somethingWentWrong);
              }
            } finally {
              if (mounted) {
                setState(() => _isSubmitting = false);
              }
            }
          },
        );
  }

  String _laneLabel(RoadEventLane lane, AppLocalizations l10n) => switch (lane) {
    RoadEventLane.left => l10n.roadEventLaneLeft,
    RoadEventLane.center => l10n.roadEventLaneCenter,
    RoadEventLane.right => l10n.roadEventLaneRight,
  };

  @override
  Widget build(BuildContext context) {
    ref.listen<RoadEventSheetState?>(roadEventsProvider, (previous, next) {
      if (previous == null || next == null || previous == next) {
        return;
      }

      unawaited(() async {
        await removeSelection(previous);
        await selectEvent(next);
      }());
    });

    final scrollController = useToggleSheetController(
      onClose: (controller) {
        unawaited(_onClose());
      },
    );
    final roadEventState = ref.watch(roadEventsProvider) ?? _initialRoadEventState;
    final currentLang = ref.read(appLanguageProvider).languageCode;

    // TODO(claude): schedule/lanesLabel are computed but not yet rendered anywhere below —
    // wire them into the layout (e.g. a "Dates: ..."/"Lanes: ..." row) once the design for
    // this is ready, or drop them (and _formatSchedule/_normalizeBoundary) if not needed.
    final schedule = _formatSchedule(
      roadEventState.createdAt,
      roadEventState.expiresAt,
      currentLang,
      context.l10n,
    );

    final lanesLabel = roadEventState.lanes.isEmpty
        ? null
        : '${context.l10n.roadEventLanesLabel}: '
              '${roadEventState.lanes.map((lane) => _laneLabel(lane, context.l10n)).join(', ')}';

    final type = roadEventState.type ?? RoadEventType.danger;
    final canDisprove = roadEventState.feedback.availableActionTypes.contains(RoadEventActionType.disproof);
    final canConfirm = roadEventState.feedback.availableActionTypes.contains(RoadEventActionType.confirmation);

    return Stack(
      children: [
        if (widget.hasBarrier)
          Positioned.fill(
            child: GestureDetector(
              onTap: _onClose,
              child: ColoredBox(
                color: context.colors.screenOverlayDimming40,
              ),
            ),
          ),
        ToggleSheet(
          dragger: const SheetDragger(),
          backgroundColor: context.colors.backgroundSurface1,
          safeAreaColor: context.colors.backgroundSurface1,
          content: [
            Container(
              padding: const EdgeInsets.only(
                top: Spacing.$3x,
                left: Spacing.$4x,
                right: Spacing.$4x,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: Spacing.$3x,
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: type.color(context.colors),
                          shape: BoxShape.circle,
                        ),
                        child: switch (type.icon()) {
                          ToastIconAsset(:final asset) => SvgPicture.asset(asset),
                          ToastIconData(:final data) => Icon(data, color: context.colors.staticWhite),
                        },
                      ),

                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: Spacing.$1x,
                                children: [
                                  Text(
                                    roadEventState.type?.label(context.l10n) ?? context.l10n.roadEventTypeOther,
                                    style: context.textStyles.h4SemiBold.copyWith(
                                      color: context.colors.foregroundDefault,
                                    ),
                                  ),
                                  if (roadEventState.updatedAt != null)
                                    Text(
                                      context.l10n.roadEventLastUpdateAgo(
                                        DateTime.now().difference(roadEventState.updatedAt!).inMinutes,
                                      ),
                                      style: context.textStyles.bodySmallRegular.copyWith(
                                        color: context.colors.foregroundSoft,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            CustomIconButtonWidget(
                              btnHeight: 36,
                              btnWidth: 36,
                              iconSize: 24,
                              borderRadius: 8.0,
                              backgroundColor: context.colors.neutralContainerDefault,
                              icon: SystemIcons.close,
                              iconColor: context.colors.neutralOnContainer,
                              onPressed: _onClose,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.lanes.isNotEmpty) ...[
                    const SizedBox(height: Spacing.$4x),
                    ReportRoadEventLanes(selectedLanes: widget.lanes),
                  ],
                  const SizedBox(height: Spacing.$3x + Spacing.$1_5x),
                  Row(
                    spacing: Spacing.$2x,
                    children: [
                      Expanded(
                        child: AppButton(
                          buttonState: canDisprove ? ButtonState.defaultState : ButtonState.disabled,
                          onTap: (_isSubmitting || !canDisprove)
                              ? null
                              : () => _performAction(RoadEventActionType.disproof),
                          buttonColorScheme: ButtonColorScheme.accentSecondary,
                          buttonType: ButtonType.secondary,
                          primaryLabel: context.l10n.roadEventNotAnymore,
                          color: canDisprove ? context.colors.neutralOnDarkOnContainer : null,
                          textColor: canDisprove ? context.colors.accentActive : null,
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          buttonState: canConfirm ? ButtonState.defaultState : ButtonState.disabled,
                          onTap: (_isSubmitting || !canConfirm)
                              ? null
                              : () => _performAction(RoadEventActionType.confirmation),
                          buttonColorScheme: ButtonColorScheme.accentSecondary,
                          buttonType: ButtonType.secondary,
                          primaryLabel: context.l10n.roadEventStillThere,
                          color: canConfirm ? context.colors.neutralOnDarkOnContainer : null,
                          textColor: canConfirm ? context.colors.accentActive : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.$3x * 2),
                ],
              ),
            ),
          ],
          scrollController: scrollController,
        ),
      ],
    );
  }

  /// BALADY-21: SDK reports inclusive seconds (HH:59:59) for bounds the data
  /// actually stores as exclusive (HH+1):00:00. Round up so the displayed
  /// minute matches the source data (5:00 PM, not 4:59 PM).
  DateTime _normalizeBoundary(DateTime dt) => dt.second >= 59 ? dt.add(const Duration(seconds: 1)) : dt;

  /// Date formats:
  /// 00:00 1 April 2025 — 23:59 10 June 2026 (if different years)
  /// 00:00 1 April — 23:59 10 June (if the same year (current))
  /// 00:00 1 April – 23:59 10 April (if the same month and year)
  /// 00:00–23:59 10 June (if one day)
  String? _formatSchedule(DateTime? from, DateTime? to, String currentLang, AppLocalizations l10n) {
    final tf = DateFormat('HH:mm', currentLang);
    final dmf = DateFormat('d MMMM', currentLang);
    final yf = DateFormat('yyyy', currentLang);
    if (from != null) from = _normalizeBoundary(from);
    if (to != null) to = _normalizeBoundary(to);
    if (from != null && to != null) {
      final showYear = from.year != to.year;
      final showMonth = from.month != to.month;
      final sameDay = DateUtils.isSameDay(from, to);

      final fromTime = tf.format(from);
      final fromMonth = dmf.format(from);
      final fromYear = yf.format(from);

      final toTime = tf.format(to);
      final toMonth = dmf.format(to);
      final toYear = yf.format(to);

      if (showYear) {
        return '$fromTime $fromMonth $fromYear – $toTime $toMonth $toYear';
      } else {
        if (showMonth) {
          return '$fromTime $fromMonth – $toTime $toMonth';
        } else if (!sameDay) {
          return '$fromTime $fromMonth – $toTime $toMonth';
        } else {
          return '$fromTime–$toTime $fromMonth';
        }
      }
    } else if (from == null && to != null) {
      return '${l10n.unknown} – ${tf.format(to)} ${dmf.format(to)} ${yf.format(to)}';
    } else if (from != null && to == null) {
      return '${tf.format(from)} ${dmf.format(from)} ${yf.format(from)} – ${l10n.unknown}';
    } else {
      return l10n.unknown;
    }
  }

  Future<void> _onClose() async {
    if (_isClosing) {
      return;
    }
    _isClosing = true;
    await removeSelection(_currentRoadEventState);
    if (mounted) {
      context.router.pop();
    }
  }
}
