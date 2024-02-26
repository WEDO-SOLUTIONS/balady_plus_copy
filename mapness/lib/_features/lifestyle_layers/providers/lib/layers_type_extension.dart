import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

extension LayerTypeExt on LayerType {
  GISMapLayers? getGISLayerType() {
    return switch (this) {
      LayerType.favourites => null,
      LayerType.invest => GISMapLayers.Opportunities,
      LayerType.buildings => GISMapLayers.BSAimtithalBuildingsCertificateL,
      LayerType.fencing => GISMapLayers.BSWhiteParcelS,
      LayerType.joy => null,
    };
  }

  String esriLayerId() {
    return switch (this) {
      LayerType.favourites => '',
      LayerType.invest => '2',
      LayerType.buildings => '7',
      LayerType.fencing => '8',
      LayerType.joy => '',
    };
  }

  String iconPath() {
    return switch (this) {
      LayerType.favourites => 'assets/icons/svg/layers/bookmark.svg',
      LayerType.invest => 'assets/icons/svg/layers/Invest.svg',
      LayerType.buildings => 'assets/icons/svg/layers/buildings.svg',
      LayerType.fencing => 'assets/icons/svg/layers/fence.svg',
      LayerType.joy => 'assets/icons/svg/layers/joy.svg',
    };
  }

  String titleLocale(AppLocalizations l10n) {
    return switch (this) {
      LayerType.favourites => l10n.favourites,
      LayerType.invest => l10n.investmentOpportunities,
      LayerType.buildings => l10n.compilanceBuildings,
      LayerType.fencing => l10n.fencingVacantLands,
      LayerType.joy => l10n.joyParks,
    };
  }
}
