import 'package:balady_plus/etmam_app/features/favorite/presentation/pages/favorite_page.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:balady_plus/etmam_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart' show SizedBox;

import '../../../../../core/utils/utils_exports.dart' show GeneralKey;

class BottomNavigationBarMapping {
  static mapStringKeyToScreen(String key, {dynamic arguments}) {
    switch (key) {
      case GeneralKey.bottomNavigationHomeKey:
        return const EtmamHomePage();
      case GeneralKey.bottomNavigationOrdersKey:
        return const OrdersPage();
      case GeneralKey.bottomNavigationFavoriteKey:
        return const FavoritePage();
      case GeneralKey.bottomNavigationProfileKey:
        return const ProfilePage();
      default:
        return const SizedBox();
    }
  }
}
