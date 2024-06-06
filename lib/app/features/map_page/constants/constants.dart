import 'package:flutter/material.dart';

import '../../../core/dependency_injection/injection_container.dart';
import '../../../core/utils/constants/apis/env_types.dart';

class Constants {
  // GIS API
  static String mainUrl = "${sl<EnvType>().domain}v1/gis-urbi-services/layers";

  // Map Style
  // static String mapStyle = "assets/maps/styles/common-styles.2gis";
  static double markerElevation = 0;

  // Map Icons
  static String icMarker = "assets/maps/icons/ic_marker.svg";
  static String icMarkerInvestmentSites =
      "assets/maps/icons/ic_marker_investment_sites.svg";
  static String icMarkerCemeteries =
      "assets/maps/icons/ic_marker_cemeteries.svg";
  static String icMarkerExcavations =
      "assets/maps/icons/ic_marker_excavations.svg";
  static String icMarkerGardensParks =
      "assets/maps/icons/ic_marker_gardens_parks.svg";
  static String icMarkerGasStations =
      "assets/maps/icons/ic_marker_gas_stations.svg";
  static String icMarkerMosques = "assets/maps/icons/ic_marker_mosques.svg";
  static const String icMarkerRestaurant =
      "assets/maps/icons/ic_marker_restaurant.svg";

  static const String icMarkerEvents =
      "assets/maps/icons/ic_marker_restaurant.svg";

  static const String diggingLayerIcon =
      "assets/maps/icons/gis_layers_icons/digging.svg";

  static const String eventLayerIcon = "assets/maps/icons/ticket.svg";

  static const String diggingSelectedLayerIcon =
      "assets/maps/icons/gis_layers_icons/digging_selected.svg";

  static const String restaurantLayerIcon =
      "assets/maps/icons/gis_layers_icons/resturant.svg";

  static const String landsLayerIcon =
      "assets/maps/icons/gis_layers_icons/lands.svg";
  static const String landsSelectedLayerIcon =
      "assets/maps/icons/gis_layers_icons/lands_selected.svg";

  static const String furasLayerIcon =
      "assets/maps/icons/gis_layers_icons/furas.svg";
  static const String furasSelectedLayerIcon =
      "assets/maps/icons/gis_layers_icons/furas_selected.svg";

  static const String bulidingLayerIcon =
      "assets/maps/icons/gis_layers_icons/buliding.svg";
  static const String bulidingSelectedLayerIcon =
      "assets/maps/icons/gis_layers_icons/buliding_selected.svg";

  static const String layerIcon =
      "assets/maps/icons/gis_layers_icons/layer.svg";

  static const String mapPinIcon =
      "assets/maps/icons/gis_layers_icons/layer.svg";

  static const String imtethalLayerIcon =
      "assets/maps/icons/gis_layers_icons/imtethal.svg";

  static const String imtethalSelectedLayerIcon =
      "assets/maps/icons/gis_layers_icons/imtethal_selected.svg";

  static const String infoCircleIcon = "assets/maps/icons/info_circle.svg";
  static const String closeCircleIcon = "assets/maps/icons/close_circle.svg";

  static const String goToLocation = "assets/maps/icons/go_to_location.svg";
}
