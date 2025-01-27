import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/_features/profile/domain/user_profile_data.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_my_location_provider.g.dart';

class PoiMyLocationState {
  final String? address;
  final LatLng location;
  final String? title;
  final bool isAuthorized;

  const PoiMyLocationState({
    required this.address,
    required this.location,
    required this.title,
    required this.isAuthorized,
  });
}

@riverpod
class PoiMyLocation extends _$PoiMyLocation {
  @override
  Future<PoiMyLocationState?> build({
    required double latitude,
    required double longitude,
  }) async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    String? address;
    try {
      final data = await dgisController.search(
        '$latitude, $longitude',
        sortingType: SortingTypeMessage.byDistance,
      );
      if (data.firstPage?.items.isNotEmpty == true) {
        address = data.firstPage?.items.first.makeAddress();
        address ??= '$latitude, $longitude';
      }
    } catch (_) {}

    final userData = ref.watch(authProvider).requireValue;

    final language = ref.read(appLanguageProvider);
    final title = userData?.getLocalizedFirstAndLastName(language);
    return PoiMyLocationState(
      address: address,
      location: LatLng(latitude: latitude, longitude: longitude),
      title: title,
      isAuthorized: CommonProperties.isLoggedIn,
    );
  }
}
