import 'package:dgis_map/library.dart';

class ActiveNavigationState {
  final bool isActive;
  final RouteSearchOptionsMessage? navType;

  const ActiveNavigationState({
    required this.isActive,
    this.navType,
  });

  static const inactive = ActiveNavigationState(isActive: false);
}

class ActiveNavigationHelper {
  static Future<ActiveNavigationState> getState(DgisMapController? controller) async {
    if (controller == null) {
      return ActiveNavigationState.inactive;
    }

    final navState = await controller.getCurrentNavigationState();
    final isActive = navState.state == NavigationState.navigation && navState.routeSearchOptions != null;

    return ActiveNavigationState(
      isActive: isActive,
      navType: isActive ? navState.routeSearchOptions : null,
    );
  }
}
