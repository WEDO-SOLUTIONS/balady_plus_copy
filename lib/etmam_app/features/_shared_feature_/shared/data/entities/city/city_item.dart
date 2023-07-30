import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/city/city_item_model.dart';

class CityItem extends Equatable {
  String? id;
  String? name;
  String? imageUrl;

  CityItem({this.id, this.name, this.imageUrl});

  @override
  List<Object?> get props => [id];
}

extension CityItemModelFromEntity on CityItem {
  CityItemModel get toModel =>
      CityItemModel(id: id, name: name, imageUrl: imageUrl);
}
