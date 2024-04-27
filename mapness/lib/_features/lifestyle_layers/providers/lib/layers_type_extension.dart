import 'package:balady_uikit/core/icons/general_icons.dart';
import 'package:balady_uikit/core/icons/transport_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/lifestyle_layers/data/map_enums.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
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
