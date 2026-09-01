import 'package:dgis_map/library.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_full_address.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/lib/make_address.dart';

extension PoiContentFullAddressExt on DirectoryObjectMessage {
  /// Generate address content. Address can't be null and we have to return any information about the object
  /// and its address
  PoiContentFullAddressModel getFullAddress(
    List<BriefRouteInfoMessage>? briefInfo,
    AppLocalizations l10n, {
    void Function()? onEntrancesTap,
    String? assetLogoPath,
    String? addressOverride,
  }) {
    // Entrances
    final entrancesCount = entrances.fold(0, (prev, e) => prev + (e.geometry?.entrancePoints.length ?? 0));
    final entrances_ = onEntrancesTap != null
        ? PoiContentEntrancesModel(title: l10n.exits, onTap: onEntrancesTap, count: entrancesCount)
        : null;

    final floors = buildingLevels?.levels.length;

    return PoiContentFullAddressModel(
      title: l10n.address,
      fullAddress: addressOverride ?? makeAddress(),
      entrances: entrances_,
      types: types,
      floors: floors != null ? PoiContentFloorModel(title: l10n.floor, floors: floors) : null,
      assetLogoUrl: assetLogoPath,
    );
  }
}
