import 'package:dgis_map/library.dart';

// ignore: prefer_expression_function_bodies
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
          objectId: 70030076256609771,
          entranceId: 70030076284457212,
        ),
        apartmentRanges: [
          ApartmentRangeMessage(start: '1', end: '9'),
        ],
        geometry: EntranceGeometryMessage(
          entrancePoints: [
            GeoPointMessage(
              latitude: 24.711564057132794,
              longitude: 46.67427162103001,
            )
          ],
          entrancePolylines: [
            [
              GeoPointMessage(latitude: 24.711648, longitude: 46.674234),
              GeoPointMessage(latitude: 24.711564, longitude: 46.674272),
            ]
          ],
        ),
      ),
    ],
    buildingInfo: BuildingInfoMessage(),

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
