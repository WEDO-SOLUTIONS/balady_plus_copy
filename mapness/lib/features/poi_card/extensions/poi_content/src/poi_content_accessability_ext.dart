import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentAccessabilityExt on DirectoryObjectMessage {
  PoiContentAccessibilityModel? getAccessibility(AppLocalizations l10n, QrLicenseMessage? licenseInfo) {
    final hasDisabledPersonsInfo = licenseInfo?.serveDisabledPersons == true;
    final hasDeliveryInfo = licenseInfo?.hasDelivery == true;
    if (!hasDeliveryInfo && !hasDisabledPersonsInfo) {
      return null;
    }
    return PoiContentAccessibilityModel(
      deliveryAvailableTitle: hasDeliveryInfo ? l10n.deliveryAvailable : null,
      serveDisablePersonsTitle: hasDisabledPersonsInfo ? l10n.accessibility : null,
    );
  }
}
