import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/src/core.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/lifestyle_layers/models/map_enums.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension LayerTypeExt on LayerType {
  GISMapLayers? getGISLayerType() => switch (this) {
    LayerType.busSubMenu => null,
    LayerType.makkahBus => null,
    LayerType.shuttleBus => null,
    LayerType.jeddahBus => null,
    LayerType.invest => GISMapLayers.opportunities,
    LayerType.buildings => GISMapLayers.bsAimtithalBuildingsCertificateL,
    LayerType.fencing => GISMapLayers.bsWhiteParcelS,
    // LayerType.joy => null,
    LayerType.favourites ||
    LayerType.metro ||
    LayerType.parkingLots ||
    LayerType.traffic ||
    LayerType.three3D ||
    LayerType.defaultMap ||
    LayerType
        .satellite // || LayerType.roadEvents
        => null,
  };

  IconData iconData() => switch (this) {
    LayerType.favourites => SystemIcons.bookmark,
    LayerType.metro => TransportIcons.metroStation,
    LayerType.invest => GeneralIcons.invest,
    LayerType.buildings => GeneralIcons.buildings,
    LayerType.fencing => GeneralIcons.fence,
    LayerType.busSubMenu => PlacesIcons.qibla,
    LayerType.makkahBus => PlacesIcons.qibla,
    LayerType.shuttleBus => PlacesIcons.qibla,
    LayerType.jeddahBus => PlacesIcons.qibla,
    LayerType.parkingLots => TransportIcons.parkingEnable,
    LayerType.traffic ||
    LayerType.three3D ||
    LayerType.defaultMap ||
    LayerType
        .satellite // || LayerType.roadEvents
        => GeneralIcons.placeholder,
  };

  String imageAsset() => switch (this) {
    LayerType.invest => '',
    LayerType.buildings => '',
    LayerType.fencing => '',
    LayerType.favourites => Assets.imagesSvg.layers.favourites.keyName,
    LayerType.metro => Assets.imagesSvg.layers.metro.keyName,
    LayerType.busSubMenu => Assets.imagesSvg.layers.busSubMenu.keyName,
    LayerType.makkahBus => Assets.imagesSvg.layers.makkahBus.keyName,
    LayerType.shuttleBus => Assets.imagesSvg.layers.shuttleBus.keyName,
    LayerType.jeddahBus => Assets.imagesSvg.layers.jeddahBus.keyName,
    LayerType.parkingLots => Assets.imagesSvg.layers.parking.keyName,
    LayerType.traffic => Assets.imagesSvg.layers.traffic.keyName,
    LayerType.three3D => Assets.imagesSvg.layers.a3D.keyName,
    // Raster thumbnails — LayerSwitcherCard switches to Image.asset based on
    // file extension. Files registered via assets/images/layers/ in pubspec.
    LayerType.defaultMap => 'assets/images/layers/default.png',
    LayerType.satellite => 'assets/images/layers/satellite.png',
    // LayerType.roadEvents => Assets.imagesSvg.layers.roadEvents.keyName,
  };

  String titleLocale(AppLocalizations l10n) => switch (this) {
    LayerType.favourites => l10n.favourites,
    LayerType.metro => l10n.mapLayerMetro,
    LayerType.invest => l10n.investmentOpportunities,
    LayerType.buildings => l10n.compilanceBuildings,
    LayerType.fencing => l10n.fencingVacantLands,
    LayerType.busSubMenu => l10n.bus,
    LayerType.makkahBus => l10n.makkahBus,
    LayerType.shuttleBus => l10n.shuttleBus,
    LayerType.jeddahBus => l10n.jeddahBus,
    LayerType.parkingLots => l10n.layersParking,
    LayerType.traffic => l10n.layersTraffic,
    LayerType.three3D => l10n.threeDee,
    // TODO(satellite): switch to l10n keys once added to Localazy.
    LayerType.defaultMap => 'Default',
    LayerType.satellite => 'Satellite',
    //LayerType.roadEvents => l10n.roadEvents.toLowerCase().toCapitalized(),
  };
}
