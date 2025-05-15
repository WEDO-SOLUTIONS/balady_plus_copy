import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/features/road_events/ui/widgets/closed_card.dart';
import 'package:mapness/features/road_events/ui/widgets/closed_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/utils/language_detector.dart';

/// Previously called RoadClosurePage.
@RoutePage()
class RoadClosedPage extends ConsumerStatefulWidget {
  const RoadClosedPage({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.finishTime,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final DgisObjectId id;
  final String title;
  final String description;
  final DateTime? startTime;
  final DateTime? finishTime;
  final double latitude;
  final double longitude;

  @override
  ConsumerState<RoadClosedPage> createState() => _RoadClosedPageState();
}

class _RoadClosedPageState extends ConsumerState<RoadClosedPage> {
  @override
  void initState() {
    super.initState();
    unawaited(selectEvent());
  }

  @override
  void activate() {
    super.activate();
    unawaited(selectEvent());
  }

  @override
  void deactivate() {
    unawaited(removeSelection());
    super.deactivate();
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
    final currentLang = ref.read(appLanguageProvider).languageCode;

    // TODO(@alexstrnik) switch back to widget.title after SDK fix
    // This is a workaround to fix the title and description that is not localized
    // When it will be fixed, we can switch back to widget.title and widget.description
    final titleLang = LanguageDetector.detectLanguage(widget.title);
    var title = widget.title;
    if (titleLang.localeForMapness != currentLang) {
      title = context.l10n.roadBlocking;
    }

    final descriptionLang = LanguageDetector.detectLanguage(widget.description);
    var description = widget.description;
    if (descriptionLang.localeForMapness != currentLang) {
      description = context.l10n.roadBlockingDescription;
    }
    return Column(
      children: [
        const Expanded(child: ClosedControls()),
        ClosedRoadCard(
          title: title,
          description: description,
          workDuration: _formatSchedule(widget.startTime, widget.finishTime, currentLang),
        ),
      ],
    );
  }

  String? _formatSchedule(DateTime? from, DateTime? to, String currentLang) {
    if (from == null) {
      return null;
    }

    final _dateFormat = DateFormat('yyyy/MM/dd', currentLang);

    return '${_dateFormat.format(from)}${to != null ? '– ${_dateFormat.format(to)}' : ''}';
  }
}
