import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_parking.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/lib/ar_functions.dart';

extension DirectoryObjectAddr on DirectoryObjectMessage {
  PoiContentParkingModel? getParking(AppLocalizations l10n) {
    if (this.parkingInfo == null) {
      return null;
    }
    final parkingInfo = this.parkingInfo!;
    final capacity = parkingInfo.capacity?.total;
    if (capacity == null) {
      return null;
    }
    final isPaid = parkingInfo.isPaid;
    final capacityInt = int.tryParse(capacity) ?? 0;
    final title = isPaid ? l10n.parkingPaid : l10n.parkingFree;
    final subtitle = '$capacity ${lots(capacityInt, l10n)}';
    return PoiContentParkingModel(
      title: title,
      subtitle: subtitle,
      isPaid: isPaid,
    );
  }
}
