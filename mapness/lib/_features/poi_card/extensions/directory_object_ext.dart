import 'package:balady_uikit/balady_uikit.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/domain/favourites_state.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/extensions/opening_hours_message_ext.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';

extension DirectoryObjectAddr on DirectoryObjectMessage {
  String makeAddress() {
    final region = address?.drilldown.firstWhereOrNull((element) => element?.type == 'region');
    final districtArea = address?.drilldown.firstWhereOrNull((element) => element?.type == 'district_area');
    final district = address?.drilldown.firstWhereOrNull((element) => element?.type == 'district');
    final street =
        address?.components.firstWhereOrNull((element) => element?.streetAddress != null)?.streetAddress?.street;

    return [street, district?.name, districtArea?.name, region?.name].whereNotNull().join(', ');
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
    AppLocalizations l10n,
    VoidCallback onEntrancesTap,
  ) {
    // Brief distance from my location to the object
    final briefDistance = briefInfo?.first.getBriefRouteDistanceDescription(l10n) ?? '';

    // Entrances
    final entrancesCount = entrances.fold(0, (prev, e) => prev + (e?.geometry?.entrancePoints.length ?? 0));
    final entrances_ = PoiContentFullAddressEntrances(
      title: l10n.exits,
      onTap: onEntrancesTap,
      count: entrancesCount,
    );

    // Floor currently is not used
    return PoiContentFullAddress(
      name: address?.buildingName ?? title,
      address: _makeAddress(),
      distance: briefDistance,
      entrances: entrances_,
    );
  }

  /// Generate address from distributed information from [address]
  String _makeAddress() {
    final region = address?.drilldown.firstWhereOrNull((element) => element?.type == 'region');
    final districtArea = address?.drilldown.firstWhereOrNull((element) => element?.type == 'district_area');
    final district = address?.drilldown.firstWhereOrNull((element) => element?.type == 'district');
    final street =
        address?.components.firstWhereOrNull((element) => element?.streetAddress != null)?.streetAddress?.street;

    return [street, district?.name, districtArea?.name, region?.name].whereNotNull().join(', ');
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

    final is24x7 = model.isOpen24x7 == true;
    final isOpenSameTime = model.isDailySameOpenHours == true;
    final days = _createWorkTimeDays(
      model.openingHours,
      l10n,
    );
    if (is24x7 || isOpenSameTime) {
      final openHours = model.openingHours?.first;
      if (openHours == null) {
        return null;
      }
      final title = StringBuffer();
      if (isOpenSameTime) {
        title
          ..write(l10n.daily)
          ..write(' ');
      }
      if (is24x7) {
        title
          ..write(l10n.twentyFourSeven)
          ..write(' ');
      } else if (isOpenSameTime) {
        if (!is24x7 && openHours.openHour != null && openHours.closeHour != null) {
          title
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
      //final isWeekend = todayOpeningInfo?.isWeekend ?? false;

      final title = StringBuffer()
        ..write(l10n.today)
        ..write(' ');
      if (todayOpeningInfo != null) {
        title
          ..write(todayOpeningInfo.openHour)
          ..write(' - ')
          ..write(todayOpeningInfo.closeHour);
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

  OpeningHoursModel _getOpeningHoursModel(AppLocalizations locale) {
    final displayOpenHours = openingHours?.getDisplayOpenHours(locale);
    return OpeningHoursModel(
      isOpen24x7: openingHours?.isOpen24x7,
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
    if (parkingInfo == null) {
      return null;
    }
    final title = '${parkingInfo?.capacity?.total} ${l10n.parkingSpaces}';
    return PoiContentParking(title: title);
  }
}
