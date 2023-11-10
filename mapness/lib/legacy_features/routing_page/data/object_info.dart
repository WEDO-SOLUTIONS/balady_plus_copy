import 'package:dgis_map/library.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:mapness/legacy_features/routing_page/data/directory_object_ext.dart';

class ObjectInfo {
  /// @nodoc
  ObjectInfo({
    required this.title,
    required this.description,
    required this.reviews,
    required this.addressRegion,
    required this.addressDistrict,
    required this.isOpen24x7,
    required this.type,
    this.hoursFrom,
    this.hoursTo,
    this.workingHoursDetails,
    this.streetAddress,
    this.objectId,
  });

  /// @nodoc
  factory ObjectInfo.fromMessage(DirectoryObjectMessage message,
      [int? distance]) {
    final region = message.address?.drilldown
        .whereType<AddressAdmDivMessage>()
        .toList()
        .firstWhereOrNull((element) => element.type == "region")
        ?.name;
    final district = message.address?.drilldown
        .whereType<AddressAdmDivMessage>()
        .firstWhereOrNull((element) => element.type == "district")
        ?.name;

    final today = DateTime.now().weekday - 1;
    final todayInfo = message.openingHours?.values[today];
    final startTime = todayInfo?.values.firstOrNull?.startTime.time;
    final finishTime = todayInfo?.values.firstOrNull?.finishTime.time;

    String? startString;
    String? finishString;
    if (startTime != null && finishTime != null) {
      final now = DateTime.now();

      final start = DateTime(
          now.year, now.month, now.day, startTime.hours, startTime.minutes);
      startString = DateFormat.Hm().format(start);

      final finish = DateTime(
          now.year, now.month, now.day, finishTime.hours, finishTime.minutes);
      finishString = DateFormat.Hm().format(finish);
    }

    return ObjectInfo(
      title: message.title,
      description: message.subtitle,
      reviews: message.reviews,
      streetAddress: message.makeAddress(),
      addressRegion: region,
      addressDistrict: district,
      hoursFrom: startString,
      hoursTo: finishString,
      workingHoursDetails: message.workStatus?.desc,
      isOpen24x7: message.openingHours?.isOpen24x7 ?? false,
      objectId: message.id,
      type: message.types[0]!.type,
    );
  }

  final String title;
  final String description;
  final ReviewsMessage? reviews;
  final String? streetAddress;
  final String? addressRegion;
  final String? addressDistrict;
  final String? hoursFrom;
  final String? hoursTo;
  final String? workingHoursDetails;
  final bool isOpen24x7;
  final DgisObjectIdMessage? objectId;
  final ObjectTypeMessage type;
}
