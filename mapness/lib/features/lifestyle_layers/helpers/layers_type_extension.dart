import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/common/image_asset_type.dart';
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
    LayerType.roadEvents => null,
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
    LayerType.traffic || LayerType.three3D || LayerType.roadEvents => GeneralIcons.placeholder,
  };

  (ImageAssetType, String) imageAsset() => switch (this) {
    LayerType.invest => (ImageAssetType.svg, ''),
    LayerType.buildings => (ImageAssetType.svg, ''),
    LayerType.fencing => (ImageAssetType.svg, ''),
    LayerType.favourites => (ImageAssetType.svg, Assets.imagesSvg.layers.favourites.keyName),
    LayerType.metro => (ImageAssetType.svg, Assets.imagesSvg.layers.metro.keyName),
    LayerType.busSubMenu => (ImageAssetType.svg, Assets.imagesSvg.layers.busSubMenu.keyName),
    LayerType.makkahBus => (ImageAssetType.svg, Assets.imagesSvg.layers.makkahBus.keyName),
    LayerType.shuttleBus => (ImageAssetType.svg, Assets.imagesSvg.layers.shuttleBus.keyName),
    LayerType.jeddahBus => (ImageAssetType.image, Assets.images.layers.imgLayerJeddahBus.keyName),
    LayerType.parkingLots => (ImageAssetType.svg, Assets.imagesSvg.layers.parking.keyName),
    LayerType.traffic => (ImageAssetType.svg, Assets.imagesSvg.layers.traffic.keyName),
    LayerType.three3D => (ImageAssetType.svg, Assets.imagesSvg.layers.a3D.keyName),
    LayerType.roadEvents => (ImageAssetType.image, Assets.images.layers.imgLayerRoadEvents.keyName),
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
    LayerType.roadEvents => l10n.roadEvents.toLowerCase().toCapitalized(),
  };
}
