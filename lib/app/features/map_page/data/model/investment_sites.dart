import 'package:dgis_map/library.dart';

import '../data_sources/point_layers_data.dart';

List<InvestmentSites> investmentSitesFromJson(List list) =>
    List<InvestmentSites>.from(list.map((x) => InvestmentSites.fromJson(x)));

class InvestmentSites extends PointLayersData {



  InvestmentSites({
    required id,
    required name,
    required type,
    required description,
    required latLng,
  }) : super(
          id: id,
          name: name,
          description: description,
          type: type,
          latLng: latLng,
        );

  factory InvestmentSites.fromJson(Map<String, dynamic> json) =>
      InvestmentSites(
        id: json['attributes']["OBJECTID"].toString(),
        name: json['attributes']["CONTRACTNAME"] ?? 'name',
        description: json['attributes']["PROJECT_DESC"] ?? 'description',
        type: json['attributes']["INVESTTYPE"]?.toString() ?? 'type',
        latLng: GeoPointMessage(
          latitude: double.parse(json['geometry']["y"].toString()),
          longitude: double.parse(json['geometry']["x"].toString()),
        ),
      );
}
