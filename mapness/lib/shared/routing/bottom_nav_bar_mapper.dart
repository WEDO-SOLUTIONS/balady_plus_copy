import 'package:go_router/go_router.dart';

extension BottomNavBarNavigationMapper on StatefulNavigationShell {
  static const _pageTitle = {
    0: 'profile',
    1: 'services',
    2: 'route',
    3: 'explore',
  };

  void mapDeeplinkToBottomNavBar(String deeplink) {
    _pageTitle.map((key, value) {
      if (deeplink.contains(value)) {
        goBranch(key);
      }
      return MapEntry(key, value);
    });
  }
}
