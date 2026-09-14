import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/language_detector.dart';
import 'package:sheetify/sheetify.dart';

/// Previously called RoadClosurePage.
@RoutePage()
class RoadClosedPage extends StatefulHookConsumerWidget {
  const RoadClosedPage({
    required this.id,
    required this.title,
    required this.startTime,
    required this.finishTime,
    this.hasBarrier = false,
    super.key,
  });

  final DgisObjectId id;
  final String title;
  final DateTime? startTime;
  final DateTime? finishTime;

  final bool hasBarrier;
  @override
  ConsumerState<RoadClosedPage> createState() => _RoadClosedPageState();
}

class _RoadClosedPageState extends ConsumerState<RoadClosedPage> {
  bool _isClosing = false;

  RoadEventSheetState get _initialRoadEventState => RoadEventSheetState(
    id: widget.id,
    title: widget.title,
    objectId: widget.id.objectId,
    startTime: widget.startTime,
    finishTime: widget.finishTime,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      detach(selectEvent(_currentRoadEventState.id), tag: 'roadClosedPage.selectEvent');
    });
  }

  RoadEventSheetState get _currentRoadEventState => ref.read(roadEventsProvider) ?? _initialRoadEventState;

  Future<void> selectEvent(DgisObjectId objectId) async {
    final highlight = ref.read(highlightProvider.notifier);
    await highlight.addHighlight(objectId.toMessage());
  }

  Future<void> removeSelection(DgisObjectId objectId) async {
    final highlight = ref.read(highlightProvider.notifier);
    await highlight.removeHighlight(objectId.toMessage());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RoadEventSheetState?>(roadEventsProvider, (previous, next) {
      if (previous == null || next == null || previous == next) {
        return;
      }

      detach(() async {
        await removeSelection(previous.id);
        await selectEvent(next.id);
      }(), tag: 'roadClosedPage.call');
    });

    final scrollController = useToggleSheetController(
      onClose: (controller) {
        detach(_onClose(), tag: 'roadClosedPage.onClose');
      },
      heightModel: ToggleSheetHeightModel.fixed(120),
    );
    final roadEventState = ref.watch(roadEventsProvider) ?? _initialRoadEventState;
    final currentLang = ref.read(appLanguageProvider).languageCode;

    // TODO(@alexstrnik) switch back to widget.title after SDK fix
    // This is a workaround to fix the title and description that is not localized
    // When it will be fixed, we can switch back to widget.title
    final titleLang = LanguageDetector.detectLanguage(roadEventState.title);
    var title = roadEventState.title;
    if (titleLang.localeForMapness != currentLang) {
      title = context.l10n.roadBlocking;
    }

    final schedule = _formatSchedule(
      roadEventState.startTime,
      roadEventState.finishTime,
      currentLang,
      context.l10n,
    );

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
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Row(
              children: [
                Icon(
                  EventsOnTheRoute.overlap,
                  size: 36,
                  color: context.colors.errorDefault,
                ),
                const SizedBox(width: Spacing.$3x),
                Expanded(
                  child: Text(
                    title,
                    style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                ),
                CustomCloseButton(
                  onClose: _onClose,
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          content: [
            Container(
              padding: const EdgeInsets.only(
                top: Spacing.$3x,
                left: Spacing.$4x,
                right: Spacing.$4x,
              ),
              child: Text(
                '${context.l10n.dates}: $schedule',
                style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
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
    if (from != null) {
      from = _normalizeBoundary(from);
    }
    if (to != null) {
      to = _normalizeBoundary(to);
    }
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
    await removeSelection(_currentRoadEventState.id);
    if (mounted) {
      context.router.pop();
    }
  }
}
