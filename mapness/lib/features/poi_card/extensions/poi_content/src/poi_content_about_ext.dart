import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension PoiContentAboutExt on DirectoryObjectMessage {
  /// Generate about content for POI Card
  PoiContentAboutModel? getAbout(AppLocalizations l10n, {String? customAbout}) {
    final String? about;
    if (customAbout != null && customAbout.isNotEmpty) {
      about = customAbout;
    } else if (this.about.isNotEmpty) {
      about = this.about;
    } else {
      about = null;
    }

    if (about != null) {
      return PoiContentAboutModel(
        aboutTitle: l10n.about,
        text: about,
        showMoreTitle: l10n.showMore,
        showLessTitle: l10n.showLess,
      );
    }
    return null;
  }
}
