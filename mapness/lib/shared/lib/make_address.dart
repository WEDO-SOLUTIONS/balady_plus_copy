import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';

extension DirectoryObjectAddr on DirectoryObjectMessage {
  String makeAddress() {
    final region = address?.drilldown.firstWhereOrNull((element) => element.type == 'region');
    final districtArea = address?.drilldown.firstWhereOrNull((element) => element.type == 'district_area');
    final district = address?.drilldown.firstWhereOrNull((element) => element.type == 'district');
    final street = address?.components
        .firstWhereOrNull((element) => element.streetAddress != null)
        ?.streetAddress
        ?.street;

    return [street, district?.name, districtArea?.name, region?.name].nonNulls.join(', ');
  }

  String makeFullAddress() {
    final region = address?.drilldown.firstWhereOrNull((element) => element.type == 'region');
    final districtArea = address?.drilldown.firstWhereOrNull((element) => element.type == 'district_area');
    final district = address?.drilldown.firstWhereOrNull((element) => element.type == 'district');

    return [title, district?.name, districtArea?.name, region?.name].nonNulls.join(', ');
  }
}
