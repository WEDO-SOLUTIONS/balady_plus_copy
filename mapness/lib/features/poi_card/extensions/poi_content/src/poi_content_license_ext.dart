import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentLicenseExt on DirectoryObjectMessage {
  PoiContentLicenseModel? getLicense(AppLocalizations l10n) {
    final number = tradeLicense?.license;
    final title = l10n.tinId;
    if (number != null) {
      return PoiContentLicenseModel(number: number, title: title);
    }
    return null;
  }
}
