import 'package:balady_uikit/core/icons/general_icons.dart';
import 'package:balady_uikit/core/icons/transport_icons_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/_features/parking/domain/parking.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension LayerTypeExt on LayerType {
  GISMapLayers? getGISLayerType() => switch (this) {
        LayerType.favourites => null,
        LayerType.invest => GISMapLayers.Opportunities,
        LayerType.buildings => GISMapLayers.BSAimtithalBuildingsCertificateL,
        LayerType.fencing => GISMapLayers.BSWhiteParcelS,
        LayerType.joy => null,
        LayerType.parking => null,
      };

  IconData iconData() => switch (this) {
        LayerType.favourites => GeneralIcons.bookmark,
        LayerType.invest => GeneralIcons.invest,
        LayerType.buildings => GeneralIcons.buildings,
        LayerType.fencing => GeneralIcons.fence,
        LayerType.joy => GeneralIcons.joy,
        LayerType.parking => TransportIcons.parkingV2,
      };

  String titleLocale(AppLocalizations l10n) => switch (this) {
        LayerType.favourites => l10n.favourites,
        LayerType.invest => l10n.investmentOpportunities,
        LayerType.buildings => l10n.compilanceBuildings,
        LayerType.fencing => l10n.fencingVacantLands,
        LayerType.joy => l10n.joyParks,
        LayerType.parking => l10n.parking,
      };
}

extension ParkingLotExt on ParkingLotFilter {
  String subTitleLocale(AppLocalizations l10n) => switch (this) {
        ParkingLotFilter.all => l10n.parkingLotFilterAll,
        ParkingLotFilter.free => l10n.parkingLotFilterFree,
        ParkingLotFilter.paid => l10n.parkingLotFilterPaid,
        ParkingLotFilter.forTaxi => l10n.parkingLotFilterForTaxi,
        ParkingLotFilter.forDisabledPersons =>
          l10n.parkingLotFilterForDisabledPersons,
        ParkingLotFilter.forElectricVehicles =>
          l10n.parkingLotFilterForElectricVehicles,
      };
}
