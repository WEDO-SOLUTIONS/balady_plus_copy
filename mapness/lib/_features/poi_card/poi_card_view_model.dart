import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PoiCardViewModel {
  final WidgetRef ref;

  PoiCardViewModel({
    required this.ref,
  });

  void onError() => Future(
        () => ref
            .read(mapControlsProvider.notifier)
            .update(MapControlsStateIdle()),
      );

  void onEntranceTap(DirectoryObjectMessage? objectMessage) async {
    final controller = await ref.read(dgisControllerProvider.future);
    if (objectMessage != null) {
      final list =
          objectMessage.entrances.map((e) => e?.id).whereNotNull().toList();
      await controller.setHighlighted(list);
    }
  }

  void share(DirectoryObjectMessage? data) {
    Share.share('balady://poi-map?dgis-object-id=${data?.id?.objectId}');
  }

  Future<void> sendEmail(String value) async {
    await launchUrl(
      Uri(
        scheme: 'mailto',
        path: value,
        queryParameters: {'subject': ''},
      ),
    );
  }

  Future<void> launch(String value) async {
    var url = Uri.parse(value);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }

  Future<void> callPhone({
    DirectoryObjectMessage? data,
  }) async {
    final phoneNumber = data?.getContactsInfoModels().firstWhereOrNull(
          (element) => element.type == ContactsInfoType.phone,
        );
    final value = phoneNumber?.value;
    if (value != null) {
      await launchUrl(Uri(scheme: 'tel', path: value));
    }
  }

  FavouriteItem? getFavouriteOrNull(PoiModel data) {
    final favouritesState = ref.read(favouriteRepositoryProvider);
    if (!favouritesState.hasValue) {
      return null;
    }
    var objectId = data.directoryObjectMessage?.id?.objectId;

    var requireValue = favouritesState.requireValue;

    final isFavourite = [
      ...requireValue.items,
      requireValue.home,
      requireValue.work
    ].whereNotNull().firstWhereOrNull(
      (element) {
        return element.entity?.id == '$objectId';
      },
    );
    return isFavourite;
  }

  bool isFavourite(PoiModel data) {
    final favouritesState = ref.read(favouriteRepositoryProvider);
    if (!favouritesState.hasValue) {
      return false;
    }
    var objectId = data.directoryObjectMessage?.id?.objectId;

    var requireValue = favouritesState.requireValue;
    var isWork = requireValue.work?.id == '$objectId';
    var isHome = requireValue.home?.id == '$objectId';

    final isFavourite = requireValue.items.firstWhereOrNull(
      (element) {
        return element.entity?.id == '$objectId';
      },
    );
    return isFavourite != null || isWork || isHome;
  }

  void removeFromFavourite(FavouriteItem data) {
    ref.read(favouriteRepositoryProvider.notifier).delete(data);
  }

  void addToFavourites(DirectoryObjectMessage data) {
    ref.read(favouriteRepositoryProvider.notifier).addItem(
          FavouriteItem(
            coordinates: Coordinates(
              latitude: data.markerPosition?.latitude ?? 24.712301,
              longitude: data.markerPosition?.longitude ?? 46.674175,
            ),
            id: '${data.id?.objectId ?? 'id'}',
            subtitle: data.subtitle,
            title: data.title,
            entity: FavouriteItemEntity(
              id: '${data.id?.objectId ?? '70030076201324251'}',
              sourceType: EntitySourceType.urbi,
            ),
          ),
        );
  }

  void resetMapControlsState() {
    ref.read(mapControlsProvider.notifier).update(
          MapControlsStateIdle(),
        );
  }
}

DirectoryObjectMessage getMockPoiCardData() {
  return DirectoryObjectMessage(
    types: [ObjectTypeItemMessage(type: ObjectTypeMessage.building)],
    title:
        'Mock Building.Mock Building.Mock Building.Mock Building.Mock Building.Mock Building.Mock Building.',
    titleAddition:
        'Additional Mock Title.Additional Mock Title.Additional Mock Title.Additional Mock Title.Additional Mock Title.',
    subtitle:
        'Mock Subtitle.Mock Subtitle.Mock Subtitle.Mock Subtitle.Mock Subtitle.Mock Subtitle.Mock Subtitle.Mock Subtitle.',
    id: DgisObjectIdMessage(objectId: 70030076560519845, entranceId: 0),
    markerPosition: GeoPointWithElevationMessage(
      latitude: 24.715817,
      longitude: 46.671102,
      elevation: 6,
    ),
    address: AddressMessage(
      drilldown: [
        AddressAdmDivMessage(
          type: 'country',
          name: 'المملكة العربية السعودية',
        ),
        AddressAdmDivMessage(
          type: 'region',
          name: 'منطقة الرياض',
        ),
        AddressAdmDivMessage(
          type: 'district_area',
          name: 'الرياض',
        ),
        AddressAdmDivMessage(
          type: 'city',
          name: 'الرياض',
        ),
        AddressAdmDivMessage(
          type: 'region',
          name: 'منطقة الرياض',
        ),
        AddressAdmDivMessage(
          type: 'district',
          name: 'العليا',
        ),
      ],
      components: [
        AddressComponentMessage(
          location: AddressLocationMessage(comment: 'Comment'),
          number: AddressNumberMessage(number: '123'),
          streetAddress:
              AddressStreetMessage(street: 'شارع 94', number: '2239'),
        )
      ],
    ),
    fullAddressName: FormattedAddressMessage(
      drilldownAddress: 'الرياض, العليا',
      streetAddress: 'شارع 94, 2239',
      addressComment: '99 floors',
      postCode: '12345',
    ),
    shortAddressName: FormattedAddressMessage(
      drilldownAddress: 'الرياض, العليا',
      streetAddress: 'شارع 94, 2239',
      addressComment: '99 floors',
      postCode: '12345',
    ),
    attributes: [
      AttributeMessage(tag: 'tag1', value: 'value1'),
      AttributeMessage(tag: 'tag2', value: 'value2'),
    ],
    contextAttributes: [
      AttributeMessage(tag: 'contextTag', value: 'contextValue'),
    ],
    // // timeZoneOffset: -5.0,
    openingHours: fillOpenHours(),
    contactInfos: [
      ContactInfoMessage(
        type: 'phone',
        displayText:
            'Phone Number.Phone Number.Phone Number.Phone Number.Phone Number.Phone Number.',
        value: '+1234567890',
        comment:
            'Primary contact number.Primary contact number.Primary contact number.Primary contact number.Primary contact number.',
      ),
      ContactInfoMessage(
        type: 'website',
        displayText: 'Website',
        value: 'https://example.com',
        comment: 'Company website',
      ),
      ContactInfoMessage(
        type: 'email',
        displayText: 'Email',
        value: 'info@example.com',
        comment: 'General inquiry email',
      ),
      ContactInfoMessage(
        type: 'twitter',
        displayText: 'Twitter',
        value: '@example',
        comment: 'Twitter handle',
      ),
      ContactInfoMessage(
        type: 'phone',
        displayText: 'Mobile Number',
        value: '+1234567890',
        comment: 'Personal mobile number',
      ),
      ContactInfoMessage(
        type: 'instagram',
        displayText: 'Instagram',
        value: '@example',
        comment: 'Instagram handle',
      ),
      ContactInfoMessage(
        type: 'snapchat',
        displayText: 'Snapchat',
        value: '@example',
        comment: 'Snapchat handle',
      ),
      ContactInfoMessage(
        type: 'facebook',
        displayText: 'Facebook',
        value: '@example',
        comment: 'Facebook page',
      ),
      ContactInfoMessage(
        type: 'whatsApp',
        displayText: 'WhatsApp',
        value: '+1234567890',
        comment: 'WhatsApp number',
      ),
      ContactInfoMessage(
        type: 'vkontakte',
        displayText: 'VKontakte',
        value: '@example',
        comment: 'VKontakte handle',
      ),
      ContactInfoMessage(
        type: 'youtube',
        displayText: 'YouTube',
        value: 'youtube.com/example',
        comment: 'YouTube channel',
      ),
      ContactInfoMessage(
        type: 'telegram',
        displayText: 'Telegram',
        value: '@example',
        comment: 'Telegram handle',
      ),
      ContactInfoMessage(
        type: 'unknown',
        displayText: 'Unknown',
        value: 'N/A',
        comment: 'Unknown contact information',
      ),
    ],
    // reviews: ReviewsMessage(
    //   rating: 4.5,
    //   count: 100,
    // ),
    // parkingInfo: ParkingInfoMessage(
    //   type: ParkingTypeMessage.ground,
    //   purpose: ParkingPurposeMessage.car,
    //   access: ParkingAccessMessage.public,
    //   pavingType: ParkingPavingTypeMessage.asphalt,
    //   isPaid: true,
    //   isIncentive: true,
    //   forTrucks: true,
    // ),
    // workStatus: WorkStatusMessage(
    //   isOpen: true,
    //   desc: 'Open for business',
    // ),
    // levelId: 1,
    // buildingLevels: BuildingLevelsMessage(
    //   defaultLevelId: 1,
    //   levels: [
    //     LevelInfoMessage(id: 1, name: "1 floor"),
    //   ],
    // ),
    entrances: [
      EntranceInfoMessage(
          id: DgisObjectIdMessage(
              objectId: 70030076256609771, entranceId: 70030076284457212),
          apartmentRanges: [
            ApartmentRangeMessage(start: "1", end: "9"),
          ],
          geometry: EntranceGeometryMessage(entrancePoints: [
            GeoPointMessage(
              latitude: 24.711564057132794,
              longitude: 46.67427162103001,
            )
          ], entrancePolylines: [
            [
              GeoPointMessage(latitude: 24.711648, longitude: 46.674234),
              GeoPointMessage(latitude: 24.711564, longitude: 46.674272),
            ]
          ])),
    ],

    ///
    //   tradeLicense: TradeLicenseMessage(
    //     type: 'ABC123',
    //     license: 'ABC123',
    //     legalForm: 'ABC123',
    //     endDate: '2024-12-31',
    //   ),
    //   externalIds: ['extId1', 'extId2'],
  );
}

OpeningHoursMessage fillOpenHours() {
  final mondayOpening = WeekTimeIntervalMessage(
    startTime: WeekTimeMessage(
      weekDay: WeekDayMessage.monday,
      time: DayTimeMessage(hours: 6, minutes: 0),
    ),
    finishTime: WeekTimeMessage(
      weekDay: WeekDayMessage.monday,
      time: DayTimeMessage(hours: 23, minutes: 0),
    ),
  );

  final tuesdayOpening = WeekTimeIntervalMessage(
    startTime: WeekTimeMessage(
      weekDay: WeekDayMessage.tuesday,
      time: DayTimeMessage(hours: 6, minutes: 0),
    ),
    finishTime: WeekTimeMessage(
      weekDay: WeekDayMessage.tuesday,
      time: DayTimeMessage(hours: 23, minutes: 0),
    ),
  );

  final wednesdayOpening = WeekTimeIntervalMessage(
    startTime: WeekTimeMessage(
      weekDay: WeekDayMessage.wednesday,
      time: DayTimeMessage(hours: 6, minutes: 0),
    ),
    finishTime: WeekTimeMessage(
      weekDay: WeekDayMessage.wednesday,
      time: DayTimeMessage(hours: 23, minutes: 0),
    ),
  );

  final thursdayOpening = WeekTimeIntervalMessage(
    startTime: WeekTimeMessage(
      weekDay: WeekDayMessage.thursday,
      time: DayTimeMessage(hours: 6, minutes: 0),
    ),
    finishTime: WeekTimeMessage(
      weekDay: WeekDayMessage.thursday,
      time: DayTimeMessage(hours: 23, minutes: 0),
    ),
  );

  final fridayOpening = WeekTimeIntervalMessage(
    startTime: WeekTimeMessage(
      weekDay: WeekDayMessage.friday,
      time: DayTimeMessage(hours: 6, minutes: 0),
    ),
    finishTime: WeekTimeMessage(
      weekDay: WeekDayMessage.friday,
      time: DayTimeMessage(hours: 23, minutes: 0),
    ),
  );

  final saturdayOpening = WeekTimeIntervalMessage(
    startTime: WeekTimeMessage(
      weekDay: WeekDayMessage.saturday,
      time: DayTimeMessage(hours: 8, minutes: 0),
    ),
    finishTime: WeekTimeMessage(
      weekDay: WeekDayMessage.saturday,
      time: DayTimeMessage(hours: 20, minutes: 0),
    ),
  );

  final sundayOpening = WeekTimeIntervalMessage(
    startTime: WeekTimeMessage(
      weekDay: WeekDayMessage.sunday,
      time: DayTimeMessage(hours: 9, minutes: 0),
    ),
    finishTime: WeekTimeMessage(
      weekDay: WeekDayMessage.sunday,
      time: DayTimeMessage(hours: 18, minutes: 0),
    ),
  );

  final openingHours = OpeningHoursMessage(
    values: [
      // WeekTimeIntervalListMessage(values: [
      //   mondayOpening,
      //   tuesdayOpening,
      //   wednesdayOpening,
      //   thursdayOpening,
      //   fridayOpening,
      //   saturdayOpening,
      //   sundayOpening,
      // ]),
      WeekTimeIntervalListMessage(values: [
        mondayOpening,
      ]),
      WeekTimeIntervalListMessage(values: [tuesdayOpening]),
      WeekTimeIntervalListMessage(values: [wednesdayOpening]),
      WeekTimeIntervalListMessage(values: [thursdayOpening]),
      WeekTimeIntervalListMessage(values: [fridayOpening]),
      WeekTimeIntervalListMessage(values: [saturdayOpening]),
      WeekTimeIntervalListMessage(values: [sundayOpening]),
    ],
    isOpen24x7: false,
  );

  return openingHours;
}
