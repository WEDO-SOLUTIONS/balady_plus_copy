import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/utils/language_detector.dart';

/// Previously called RoadClosurePage.
@RoutePage()
class RoadClosedPage extends StatefulHookConsumerWidget {
  const RoadClosedPage({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.finishTime,
    required this.latitude,
    required this.longitude,
    this.onClose,
    this.hasBarrier = false,
    super.key,
  });

  final DgisObjectId id;
  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? finishTime;
  final double latitude;
  final double longitude;

  final VoidCallback? onClose;
  final bool hasBarrier;
  @override
  ConsumerState<RoadClosedPage> createState() => _RoadClosedPageState();
}

class _RoadClosedPageState extends ConsumerState<RoadClosedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      unawaited(selectEvent());
    });
  }

  Future<void> selectEvent() async {
    final highlight = ref.read(highlightProvider.notifier);
    await highlight.addHighlight(widget.id.toMessage());
  }

  Future<void> removeSelection() async {
    final highlight = ref.read(highlightProvider.notifier);
    await highlight.removeHighlight(widget.id.toMessage());
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = useStatelessBottomsheetController(
      onClose: (controller) {
        unawaited(removeSelection());
        widget.onClose?.call();
      },
      heightModel: BottomSheetHeightModel.fixed(120),
    );
    final currentLang = ref.read(appLanguageProvider).languageCode;

    // TODO(@alexstrnik) switch back to widget.title after SDK fix
    // This is a workaround to fix the title and description that is not localized
    // When it will be fixed, we can switch back to widget.title and widget.description
    final titleLang = LanguageDetector.detectLanguage(widget.title);
    var title = widget.title;
    if (titleLang.localeForMapness != currentLang) {
      title = context.l10n.roadBlocking;
    }

    // final descriptionLang = LanguageDetector.detectLanguage(widget.description);
    // var description = widget.description;
    // if (descriptionLang.localeForMapness != currentLang) {
    //   description = context.l10n.roadBlockingDescription;
    // }
    return Stack(
      children: [
        if (widget.hasBarrier)
          Positioned.fill(
            child: GestureDetector(
              onTap: _onClose,
              child: ColoredBox(
                color: context.color.surfaceOverlayModal,
              ),
            ),
          ),
        StatelessBottomSheet(
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Row(
              children: [
                Icon(
                  EventsOnTheRoute.overlap,
                  size: 36,
                  color: context.colorsV3.errorDefault,
                ),
                const SizedBox(width: Spacing.$3x),
                Expanded(
                  child: Text(
                    title,
                    style: context.textStyleV3.h4SemiBold,
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
              child: Text('${context.l10n.dates}: ${_formatSchedule(
                widget.startTime,
                widget.finishTime,
                currentLang,
                context.l10n,
              )}'),
            ),
          ],
          scrollController: scrollController,
        ),
      ],
    );
  }

  /// Date formats:
  /// 00:00 1 April 2025 — 23:59 10 June 2026 (if different years)
  /// 00:00 1 April — 23:59 10 June (if the same year (current))
  /// 00:00–23:59 10 June (if one month and year)
  String? _formatSchedule(DateTime? from, DateTime? to, String currentLang, AppLocalizations l10n) {
    final tf = DateFormat('HH:mm', currentLang);
    final dmf = DateFormat('d MMMM', currentLang);
    final yf = DateFormat('yyyy', currentLang);
    if (from != null && to != null) {
      final showYear = from.year != to.year;
      final showMonth = from.month != to.month;

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
    await removeSelection();
    widget.onClose?.call();
    context.router.popForced();
  }
}
