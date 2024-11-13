import 'package:mapness/entities/city_contain/dto/city_rect.dart';
import 'package:mapness/entities/city_contain/dto/location_point.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'city_contain.g.dart';

@riverpod
class CityContain extends _$CityContain {
  @override
  Future<bool> build(CityRect rect, LocationPoint point) async {
    final controller = await ref.read(dgisControllerProvider.future);

    final res = await controller.contains(rect.toGeoRectMessage(), point.toGeoPointMessage());

    return res;
  }
}
