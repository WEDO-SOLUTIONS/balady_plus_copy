import 'package:dgis_map/library.dart' as sdk;
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';

class LeapPoi extends Equatable {
  final int objectId;
  final sdk.GeoPointMessage center;

  final DateTime eventFrom;
  final DateTime eventTo;

  const LeapPoi({
    required this.objectId,
    required this.center,
    required this.eventFrom,
    required this.eventTo,
  });

  static const _openHour = 12;
  static const _closeHour = 21;

  String title(AppLocalizations l10n) => l10n.leapPoiTitle;

  String subtitle(AppLocalizations l10n) => l10n.leapPoiSubtitle;

  String about(AppLocalizations l10n) => l10n.leapPoiAbout;
  Set<WeekDayMessage> get eventWeekDays {
    final first = DateTime(eventFrom.year, eventFrom.month, eventFrom.day);
    final last = DateTime(eventTo.year, eventTo.month, eventTo.day);
    final lastOffset = last.difference(first).inDays.clamp(0, WeekDayMessage.values.length - 1);

    return {
      for (var offset = 0; offset <= lastOffset; offset++) _weekDayOf(first.add(Duration(days: offset))),
    };
  }

  OpeningHoursMessage get openingHours => OpeningHoursMessage(
    isOpen24x7: false,
    values: eventWeekDays
        .map(
          (weekDay) => WeekTimeIntervalListMessage(
            values: [
              WeekTimeIntervalMessage(
                startTime: WeekTimeMessage(
                  weekDay: weekDay,
                  time: DayTimeMessage(hours: _openHour, minutes: 0),
                ),
                finishTime: WeekTimeMessage(
                  weekDay: weekDay,
                  time: DayTimeMessage(hours: _closeHour, minutes: 0),
                ),
              ),
            ],
          ),
        )
        .toList(),
  );
  WorkStatusMessage workStatus(AppLocalizations l10n) => WorkStatusMessage(
    isOpen: _isOpenNow,
    desc: '${l10n.dates}: ${formatEventDates(l10n)}',
  );
  String formatEventDates(AppLocalizations l10n) {
    final format = DateFormat('d MMMM', l10n.localeName);
    final from = format.format(eventFrom);
    final to = format.format(eventTo);

    return from == to ? from : '$from - $to';
  }

  bool get _isOpenNow {
    final now = saudiTimeNow();

    return eventWeekDays.contains(_weekDayOf(now)) && now.hour >= _openHour && now.hour < _closeHour;
  }

  WeekDayMessage _weekDayOf(DateTime date) => switch (date.weekday) {
    DateTime.monday => WeekDayMessage.monday,
    DateTime.tuesday => WeekDayMessage.tuesday,
    DateTime.wednesday => WeekDayMessage.wednesday,
    DateTime.thursday => WeekDayMessage.thursday,
    DateTime.friday => WeekDayMessage.friday,
    DateTime.saturday => WeekDayMessage.saturday,
    _ => WeekDayMessage.sunday,
  };

  @override
  List<Object?> get props => [objectId, center, eventFrom, eventTo];

  DirectoryObjectMessage toDirectoryObjectMessage(AppLocalizations l10n) {
    final name = title(l10n);

    return DirectoryObjectMessage(
      types: [],
      title: name,
      titleAddition: '',
      subtitle: subtitle(l10n),
      about: about(l10n),
      id: DgisObjectIdMessage(objectId: objectId, entranceId: 0),
      markerPosition: GeoPointWithElevationMessage(
        latitude: center.latitude,
        longitude: center.longitude,
        elevation: 0,
      ),
      attributes: [],
      contextAttributes: [],
      openingHours: openingHours,
      contactInfos: [
        ContactInfoMessage(type: 'phone', displayText: '+966 11 211 2222', value: '+966112112222'),
        ContactInfoMessage(
          type: 'website',
          displayText: 'leap',
          value: 'https://onegiantleap.com/?utm_source=t.co&utm_medium=referral&utm_campaign=Unspecified',
        ),
        ContactInfoMessage(type: 'facebook', displayText: 'leap', value: 'https://www.facebook.com/LEAPandInnovate/'),
        ContactInfoMessage(
          type: 'instagram',
          displayText: 'leapandinnovate',
          value: 'https://www.instagram.com/leapandinnovate?igsh=MTBkMGZkaXFsa3QyNw==',
        ),
        ContactInfoMessage(
          type: 'youtube',
          displayText: 'leapandinnovate',
          value: 'https://youtube.com/@leapandinnovate?si=zuqx33umTepDVJxW',
        ),
        ContactInfoMessage(
          type: 'tiktok',
          displayText: 'leapandinnovate',
          value: 'https://www.tiktok.com/@leapandinnovate?_r=1&_t=ZS-98cuJUFEevd',
        ),
        ContactInfoMessage(
          type: 'twitter',
          displayText: 'leapandinnovate',
          value: 'https://x.com/leapandinnovate?s=21',
        ),
        ContactInfoMessage(
          type: 'linkedin',
          displayText: 'leapandinnovate',
          value: 'https://www.linkedin.com/company/leapandinnovate/',
        ),
      ],
      workStatus: workStatus(l10n),
      entrances: [],
      buildingInfo: BuildingInfoMessage(buildingName: name, purposeName: name, purposeCode: 501),
      rubricIds: [],
      group: [],
      routeInfos: [],
      platformIds: [],
    );
  }

  DirectoryObjectMessage mergeDirectoryObjectMessage(AppLocalizations l10n, DirectoryObjectMessage? other) {
    final leapDirectoryObject = toDirectoryObjectMessage(l10n);

    return DirectoryObjectMessage(
      types: other?.types ?? leapDirectoryObject.types,
      title: leapDirectoryObject.title,
      titleAddition: other?.titleAddition ?? leapDirectoryObject.titleAddition,
      subtitle: leapDirectoryObject.subtitle,
      about: leapDirectoryObject.about,
      description: other?.description ?? leapDirectoryObject.description,
      id: other?.id ?? leapDirectoryObject.id,
      markerPosition: other?.markerPosition ?? leapDirectoryObject.markerPosition,
      address: other?.address ?? leapDirectoryObject.address,
      fullAddressName: other?.fullAddressName ?? leapDirectoryObject.fullAddressName,
      shortAddressName: other?.shortAddressName ?? leapDirectoryObject.shortAddressName,
      attributes: other?.attributes ?? leapDirectoryObject.attributes,
      contextAttributes: other?.contextAttributes ?? leapDirectoryObject.contextAttributes,
      timeZoneOffset: other?.timeZoneOffset ?? leapDirectoryObject.timeZoneOffset,
      openingHours: leapDirectoryObject.openingHours,
      contactInfos: (other?.contactInfos != null && other!.contactInfos.isNotEmpty)
          ? other.contactInfos
          : leapDirectoryObject.contactInfos,
      reviews: other?.reviews ?? leapDirectoryObject.reviews,
      parkingInfo: other?.parkingInfo ?? leapDirectoryObject.parkingInfo,
      workStatus: leapDirectoryObject.workStatus,
      levelId: other?.levelId ?? leapDirectoryObject.levelId,
      buildingLevels: other?.buildingLevels ?? leapDirectoryObject.buildingLevels,
      entrances: other?.entrances ?? leapDirectoryObject.entrances,
      tradeLicense: other?.tradeLicense ?? leapDirectoryObject.tradeLicense,
      buildingInfo: other?.buildingInfo ?? leapDirectoryObject.buildingInfo,
      rubricIds: other?.rubricIds ?? leapDirectoryObject.rubricIds,
      orgInfo: other?.orgInfo ?? leapDirectoryObject.orgInfo,
      group: other?.group ?? leapDirectoryObject.group,
      routeInfos: other?.routeInfos ?? leapDirectoryObject.routeInfos,
      platformIds: other?.platformIds ?? leapDirectoryObject.platformIds,
    );
  }
}
