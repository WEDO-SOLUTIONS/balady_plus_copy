import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/favourites/favourites_state.dart';
import 'package:mapness/features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/features/poi_card/domain/model/work_time_model.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/features/poi_card/extensions/opening_hours_message_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/entities/coordinates.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

extension DirectoryObjectAddr on DirectoryObjectMessage {
  String makeAddress() {
    final region = address?.drilldown.firstWhereOrNull((element) => element.type == 'region');
    final districtArea = address?.drilldown.firstWhereOrNull((element) => element.type == 'district_area');
    final district = address?.drilldown.firstWhereOrNull((element) => element.type == 'district');
    final street =
        address?.components.firstWhereOrNull((element) => element.streetAddress != null)?.streetAddress?.street;

    return [street, district?.name, districtArea?.name, region?.name].nonNulls.join(', ');
  }

  FavouriteItem mapToFavourite() => FavouriteItem(
        coordinates: Coordinates(
          latitude: markerPosition?.latitude ?? 0,
          longitude: markerPosition?.longitude ?? 0,
        ),
        id: 'overriden',
        subtitle: subtitle,
        title: title,
        entity: FavouriteItemEntity(
          sourceType: EntitySourceType.urbi,
          id: id?.objectId.toString() ?? 'id',
        ),
      );
}

extension DirectoryObjectExt on DirectoryObjectMessage {
  /// Generate favourites data
  PoiContentFavourite? getFavourites(
    AsyncValue<FavouritesState> state,
    AppLocalizations l10n,
    VoidCallback onPressed,
  ) =>
      state.map(
        data: (result) {
          final value = result.value;
          final objectId = id?.objectId;

          // If [objectId] is null in some case we don't want to break the app and return null
          // Generally it should not be null
          if (objectId == null) {
            return null;
          }

          // If current [objectId] is the same as [objectId] of our home we show home card
          final showHome = value.home?.id == objectId.toString();
          if (showHome) {
            return PoiContentFavourite(
              type: PoiContentFavouriteType.home,
              title: l10n.home,
              onTap: onPressed,
            );
          }

          // If current [objectId] is the same as [objectId] of our work we show work card
          final showWork = value.work?.id == objectId.toString();
          if (showWork) {
            return PoiContentFavourite(
              type: PoiContentFavouriteType.work,
              title: l10n.work,
              onTap: onPressed,
            );
          }

          // If current [objectId] is in the list of [objectId]'s of our favourites we show favourites card
          final isFavourite = value.items.firstWhereOrNull((e) => e.entity?.id == objectId.toString());
          if (isFavourite != null) {
            return PoiContentFavourite(
              type: PoiContentFavouriteType.favourites,
              title: l10n.favourites,
              onTap: onPressed,
            );
          }

          // Otherwise return null
          return null;
        },
        error: (_) => null,
        loading: (_) => null,
      );

  /// Generate address content. Address can't be null and we have to return any information about the object
  /// and its address
  PoiContentFullAddress getFullAddress(
    List<BriefRouteInfoMessage>? briefInfo,
    AppLocalizations l10n, [
    VoidCallback? onEntrancesTap,
  ]) {
    // Brief distance from my location to the object
    String briefDistance = '';
    if (briefInfo?.isNotEmpty ?? false) {
      briefDistance = briefInfo!.first.getBriefRouteDistanceDescription(l10n);
    }

    // Entrances
    final entrancesCount = entrances.fold(0, (prev, e) => prev + (e.geometry?.entrancePoints.length ?? 0));
    final entrances_ = onEntrancesTap != null
        ? PoiContentFullAddressEntrances(
            title: l10n.exits,
            onTap: onEntrancesTap,
            count: entrancesCount,
          )
        : null;

    final floors = buildingLevels?.levels.length;

    return PoiContentFullAddress(
      name: address?.buildingName ?? title,
      address: makeAddress(),
      distance: briefDistance,
      entrances: entrances_,
      floor: floors != null ? PoiContentFullAddressFloor(title: l10n.floor, floor: floors) : null,
    );
  }

  /// Generate about content for POI Card
  PoiContentAbout? getAbout(AppLocalizations l10n) {
    if (about.isNotEmpty) {
      return PoiContentAbout(
        aboutTitle: l10n.about,
        text: about,
        showMoreTitle: l10n.showMore,
        showLessTitle: l10n.showLess,
      );
    }
    return null;
  }

  PoiContentWorkTime? getOpeningHours(AppLocalizations l10n) {
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

      return PoiContentWorkTime(
        title: title.toString(),
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

      return PoiContentWorkTime(
        title: title.toString(),
        days: days,
        additionalInfo: additionalInfo,
      );
    }
  }

  /// Function to get the header for opening hours.
  WorkTimeModel? getOpeningHoursHeader(BuildContext context) {
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
        color: context.colorsV2.errorDefault,
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
  WorkTimeModel? _buildDynamicWorkTimeModel(
    BuildContext context,
    OpeningHoursModel model,
    OpenHours openHours,
    List<PoiContentWorkTimeDay>? days,
  ) {
    /// Get the current date and time
    final currentDateTime = DateTime.now();

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
        title: '${context.l10n.closedUntill} ${openHours.openHour}',
        color: context.colorsV2.errorDefault,
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
        return _buildWorkTimeModel(
          title: '${context.l10n.closesIn.trim()} $remainingMinutes ${context.l10n.minutes}',
          color: context.colorsV2.extra01Default,
          days: days,
        );
      } else {
        return _buildWorkTimeModel(
          title: '${context.l10n.openUntil} ${openHours.closeHour}',
          color: context.colorsV2.accentDefault,
          days: days,
        );
      }
    }
  }

  /// Builds the model for the next opening time when the current time is outside of working hours.
  WorkTimeModel? _buildNextOpeningTimeModel(
    BuildContext context,
    OpeningHoursModel model,
    List<PoiContentWorkTimeDay>? days,
  ) {
    /// Get the next day with working hours, skipping weekends.
    final nextOpen = model.openingHours?.skip(1).firstWhere(
          (day) => !day.isWeekend,
          orElse: () => model.openingHours!.first,
        );

    if (nextOpen == null) {
      return null;
    }

    final nextOpenTime = nextOpen.openHour;
    if (nextOpen.isWeekend) {
      /// Get the next weekday and return the model indicating when the place will open.
      final nextWeekday = DateTime.now().add(const Duration(days: 1)).weekDayName(context.l10n);
      return _buildWorkTimeModel(
        title: '${context.l10n.closedUntill} ${nextWeekday.toCapitalized()} $nextOpenTime',
        color: context.colorsV2.errorDefault,
        days: days,
      );
    }

    /// If there is no next opening time, return a model indicating the place is temporarily not working.
    return _buildWorkTimeModel(
      title: '${context.l10n.closedUntill} $nextOpenTime',
      color: context.colorsV2.errorDefault,
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
  WorkTimeModel _buildWorkTimeModel({
    required String title,
    required Color color,
    List<PoiContentWorkTimeDay>? days,
  }) =>
      WorkTimeModel(
        color: color,
        poiContentWorkTime: PoiContentWorkTime(
          title: title,
          days: days,
        ),
      );

  OpeningHoursModel _getOpeningHoursModel(AppLocalizations locale) {
    final displayOpenHours = openingHours?.getDisplayOpenHours(locale);
    return OpeningHoursModel(
      isAlwaysOpen: openingHours?.isOpen24x7,
      openingHours: displayOpenHours,
      isDailySameOpenHours: openingHours?.defineIsDailySameOpenHours(locale),
    );
  }

  List<PoiContentWorkTimeDay>? _createWorkTimeDays(List<OpenHours>? openingHours, AppLocalizations l10n) =>
      openingHours?.map(
        (e) {
          final weekDay = e.weekDay;
          return PoiContentWorkTimeDay(
            dayTitle: weekDay,
            workHours: e.isWeekend ? l10n.weekend : '${e.openHour!} - ${e.closeHour!}',
          );
        },
      ).toList();

  /// Contacts
  PoiContentContacts? getContacts(
    void Function(String) onPhoneTap,
    void Function(PoiContentSocialMediaType, String) onSocialMediaTap,
    AppLocalizations locale,
  ) {
    if (contactInfos.isEmpty) {
      return null;
    }
    final phone = contactInfos.nonNulls.firstWhereOrNull(
      (e) => ContactsInfoTypeExt.fromString(e.type) == ContactsInfoType.phone,
    );
    final list_ = contactInfos.nonNulls
        .map((e) {
          final type = ContactsInfoTypeExt.fromString(e.type);
          final v = type.socialMediaType;
          if (v != null) {
            return PoiContentSocialMedia(type: v, link: e.value);
          }
        })
        .nonNulls
        .toList();

    return PoiContentContacts(
      phone: phone?.displayText,
      onPhoneTap: phone?.value != null ? () => onPhoneTap(phone!.value) : null,
      socialMediaList: list_,
      onSocialMediaTap: onSocialMediaTap,
    );
  }

  /// License number
  PoiContentLicense? getLicense(AppLocalizations l10n) {
    final title = tradeLicense?.license;
    final subtitle = l10n.tinId;
    if (title != null) {
      return PoiContentLicense(title: title, subtitle: subtitle);
    }
    return null;
  }

  /// Accessibility
  PoiContentAccessibilityInfo? getAccessibility(AppLocalizations l10n, QrLicenseMessage? licenseInfo) {
    final hasDisabledPersonsInfo = licenseInfo?.serveDisabledPersons == true;
    final hasDeliveryInfo = licenseInfo?.hasDelivery == true;
    if (!hasDeliveryInfo && !hasDisabledPersonsInfo) {
      return null;
    }
    return PoiContentAccessibilityInfo(
      deliveryAvailableTitle: hasDeliveryInfo ? l10n.deliveryAvailable : null,
      serveDisablePersonsTitle: hasDisabledPersonsInfo ? l10n.accessibility : null,
    );
  }

  /// Parking
  PoiContentParking? getParking(AppLocalizations l10n) {
    final parkingInfo_ = parkingInfo;
    if (parkingInfo_ == null) {
      return null;
    }
    final capacity = parkingInfo_.capacity?.total;
    if (capacity == null) {
      return null;
    }
    final title = '$capacity ${l10n.parkingSpaces}';
    return PoiContentParking(title: title);
  }
}
