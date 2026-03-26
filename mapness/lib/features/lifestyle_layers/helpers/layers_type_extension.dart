import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension LayerTypeExt on LayerType {
  GISMapLayers? getGISLayerType() => switch (this) {
        LayerType.favourites => null,
        LayerType.metro => null,
        LayerType.makkahBuses => null,
        LayerType.invest => GISMapLayers.opportunities,
        LayerType.buildings => GISMapLayers.bsAimtithalBuildingsCertificateL,
        LayerType.fencing => GISMapLayers.bsWhiteParcelS,
        // LayerType.joy => null,
        LayerType.parkingLots => null,
      };

  IconData iconData() => switch (this) {
        LayerType.favourites => SystemIcons.bookmark,
        LayerType.metro => TransportIcons.metroStation,
        LayerType.invest => GeneralIcons.invest,
        LayerType.buildings => GeneralIcons.buildings,
        LayerType.fencing => GeneralIcons.fence,
        LayerType.makkahBuses => PlacesIcons.qibla,
        // LayerType.joy => GeneralIcons.joy,
        LayerType.parkingLots => TransportIcons.parkingEnable,
      };

  String titleLocale(AppLocalizations l10n) => switch (this) {
        LayerType.favourites => l10n.favourites,
        LayerType.metro => l10n.mapLayerMetro,
        LayerType.invest => l10n.investmentOpportunities,
        LayerType.buildings => l10n.compilanceBuildings,
        LayerType.fencing => l10n.fencingVacantLands,
        LayerType.makkahBuses => 'Makkah Buses',
        // LayerType.joy => l10n.joyParks,
        LayerType.parkingLots => l10n.parkingLots,
      };
}
