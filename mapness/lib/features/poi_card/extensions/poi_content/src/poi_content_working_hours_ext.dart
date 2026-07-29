import 'package:balady_plus/app/core/utils/extensions/str_conversion.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_working_time.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/features/poi_card/extensions/opening_hours_message_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';

extension PoiContentWorkingHoursExt on DirectoryObjectMessage {
  PoiContentWorkTimeModel? getOpeningHours(AppLocalizations l10n) {
    if (openingHours == null) {
      return null;
    }
    final model = _getOpeningHoursModel(l10n);

    final is24x7 = model.isAlwaysOpen == true;
    final isOpenSameTime = model.isDailySameOpenHours == true;
    final days = _createWorkTimeDays(
      model.openingHours,
      l10n,
    );
    if (is24x7 || isOpenSameTime) {
      OpenHours? openHours;
      if (model.openingHours != null && model.openingHours!.isNotEmpty) {
        openHours = model.openingHours?.first;
      }
      if (openHours == null) {
        return null;
      }

      final title = StringBuffer();
      if (isOpenSameTime) {
        title.write(l10n.daily);
      }
      if (is24x7) {
        title
          ..write(' ')
          ..write(l10n.twentyFourSeven);
      } else if (isOpenSameTime) {
        if (!is24x7 && openHours.openHour != null && openHours.closeHour != null) {
          title
            ..write(' ')
            ..write(openHours.openHour)
            ..write(' - ')
            ..write(openHours.closeHour);
        }
      }

      return PoiContentWorkTimeModel(
        workHours: l10n.digits(title.toString()),
        days: !isOpenSameTime ? days : null,
      );
    } else {
      final todayOpeningInfo = model.getTodayOpeningInfo(l10n);
      final isWeekend = todayOpeningInfo?.isWeekend ?? false;

      final title = StringBuffer()..write(l10n.today);

      if (todayOpeningInfo != null && todayOpeningInfo.openHour != null && todayOpeningInfo.closeHour != null) {
        title
          ..write(' ')
          ..write(todayOpeningInfo.openHour)
          ..write(' - ')
          ..write(todayOpeningInfo.closeHour);
      } else if (isWeekend) {
        title
          ..write(' ')
          ..write(l10n.weekend);
      }
      final days = _createWorkTimeDays(
        model.openingHours,
        l10n,
      );
      String? additionalInfo;
      if (workStatus != null && workStatus!.desc.isNotEmpty) {
        additionalInfo = workStatus?.desc;
      }

      return PoiContentWorkTimeModel(
        workHours: l10n.digits(title.toString()),
        days: days,
        additionalInfo: additionalInfo,
      );
    }
  }

  /// Function to get the header for opening hours.
  ContentWorkTimeModel? getOpeningHoursHeader(BuildContext context) {
    /// If there are no opening hours, return null.
    if (openingHours == null) {
      return null;
    }

    /// Get the opening hours model based on the current locale.
    final model = _getOpeningHoursModel(context.l10n);

    /// If there are no opening hours or it's an empty list, return null.
    if (model.openingHours == null || model.openingHours!.isEmpty) {
      return null;
    }

    /// Check if all days are closed (weekends).
    final allDaysClosed = model.openingHours!.every((day) => day.isWeekend);

    /// If all days are closed, return a model indicating that the place is temporarily not working.
    if (allDaysClosed) {
      return _buildWorkTimeModel(
        title: context.l10n.temporarilyClosed,
        workTimeType: WorkTimeType.closed,
        l10n: context.l10n,
      );
    }

    /// Check if the place is open 24/7 and if the opening hours are the same every day.
    final is24x7 = model.isAlwaysOpen == true;
    final isOpenSameTime = model.isDailySameOpenHours == true;

    /// If the opening hours are different for each day, create a list of work days.
    final days = !isOpenSameTime ? _createWorkTimeDays(model.openingHours, context.l10n) : null;

    /// Get the first opening hour for the day.
    final openHours = model.openingHours!.first;

    /// If the place is not 24/7, and it has open and close hours, build a dynamic work time model.
    if (!is24x7 && openHours.openHour != null && openHours.closeHour != null) {
      return _buildDynamicWorkTimeModel(context, model, openHours, days);
    }

    /// If no conditions match, return null.
    return null;
  }

  /// Builds the dynamic work time model based on the current time and opening hours.
  ContentWorkTimeModel? _buildDynamicWorkTimeModel(
    BuildContext context,
    OpeningHoursModel model,
    OpenHours openHours,
    List<PoiContentWorkTimeDayModel>? days,
  ) {
    /// Get the current date and time
    final currentDateTime = saudiTimeNow();

    /// Parse the opening and closing hours into DateTime objects.
    final openTime = _parseTime(currentDateTime, openHours.openHour!);
    var closeTime = _parseTime(currentDateTime, openHours.closeHour!);

    /// Handle case when closing time is after midnight (next day)
    if (closeTime.isBefore(openTime)) {
      closeTime = closeTime.add(const Duration(days: 1));
    }

    /// If the current time is before opening time, return a model indicating the place is closed until opening.
    if (currentDateTime.isBefore(openTime)) {
      return _buildWorkTimeModel(
        title: '${context.l10n.closedUntil} ${openHours.openHour}',
        workTimeType: WorkTimeType.closed,
        l10n: context.l10n,
        days: days,
      );
    }
    /// If the current time is after closing time, return the next opening time model.
    else if (currentDateTime.isAfter(closeTime)) {
      return _buildNextOpeningTimeModel(context, model, days);
    }
    /// If the current time is between open and close time, return a model with the remaining time until closing.
    else {
      final remainingMinutes = closeTime.difference(currentDateTime).inMinutes;
      if (remainingMinutes <= 45) {
        var title = '';
        if (remainingMinutes > 1) {
          title = '${context.l10n.closesIn.trim()} $remainingMinutes ${context.l10n.minutesShort}';
        } else {
          title = context.l10n.closed;
        }
        return _buildWorkTimeModel(
          title: title,
          workTimeType: WorkTimeType.almostClosed,
          l10n: context.l10n,
          days: days,
        );
      } else {
        return _buildWorkTimeModel(
          title: '${context.l10n.openUntil} ${openHours.closeHour}',
          workTimeType: WorkTimeType.open,
          l10n: context.l10n,
          days: days,
        );
      }
    }
  }

  /// Builds the model for the next opening time when the current time is outside of working hours.
  ContentWorkTimeModel? _buildNextOpeningTimeModel(
    BuildContext context,
    OpeningHoursModel model,
    List<PoiContentWorkTimeDayModel>? days,
  ) {
    /// Get the next day with working hours, skipping weekends.
    final nextOpen = model.openingHours
        ?.skip(1)
        .firstWhere(
          (day) => !day.isWeekend,
          orElse: () => model.openingHours!.first,
        );

    if (nextOpen == null) {
      return null;
    }

    final nextOpenTime = nextOpen.openHour;
    if (nextOpen.isWeekend) {
      /// Get the next weekday and return the model indicating when the place will open.
      final nextWeekday = saudiTimeNow().add(const Duration(days: 1)).weekDayName(context.l10n);
      return _buildWorkTimeModel(
        title: '${context.l10n.closedUntil} ${nextWeekday.toCapitalized()} $nextOpenTime',
        workTimeType: WorkTimeType.closed,
        l10n: context.l10n,
        days: days,
      );
    }

    /// If there is no next opening time, return a model indicating the place is temporarily not working.
    return _buildWorkTimeModel(
      title: '${context.l10n.closedUntil} $nextOpenTime',
      workTimeType: WorkTimeType.closed,
      l10n: context.l10n,
      days: days,
    );
  }

  /// Parses a time string into a DateTime object using the current date.
  DateTime _parseTime(DateTime currentDateTime, String time) {
    final parts = time.split(':');
    return DateTime(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Builds the work time model with the given parameters.
  ContentWorkTimeModel _buildWorkTimeModel({
    required String title,
    required WorkTimeType workTimeType,
    required AppLocalizations l10n,
    List<PoiContentWorkTimeDayModel>? days,
  }) => ContentWorkTimeModel(
    workTimeType: workTimeType,
    poiContentWorkTime: PoiContentWorkTimeModel(workHours: l10n.digits(title), days: days),
  );

  OpeningHoursModel _getOpeningHoursModel(AppLocalizations locale) {
    final displayOpenHours = openingHours?.getDisplayOpenHours(locale);
    return OpeningHoursModel(
      isAlwaysOpen: openingHours?.isOpen24x7,
      openingHours: displayOpenHours,
      isDailySameOpenHours: openingHours?.defineIsDailySameOpenHours(locale),
    );
  }

  List<PoiContentWorkTimeDayModel>? _createWorkTimeDays(List<OpenHours>? openingHours, AppLocalizations l10n) =>
      openingHours?.map(
        (e) {
          final weekDay = e.weekDay;
          return PoiContentWorkTimeDayModel(
            dayTitle: weekDay,
            workHours: e.isWeekend ? l10n.weekend : l10n.digits('${e.openHour!}–${e.closeHour!}'),
          );
        },
      ).toList();
}

extension PoiContentExt on OpeningHoursModel {
  OpenHours? getTodayOpeningInfo(AppLocalizations locale) {
    final todayName = saudiTimeNow().weekDayName(locale);

    return openingHours?.firstWhereOrNull(
      (e) => e.weekDay.toLowerCase() == todayName.toLowerCase(),
    );
  }
}
