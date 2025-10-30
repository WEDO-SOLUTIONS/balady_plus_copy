import '../../utils/utils_exports.dart' show GeneralKey, IconPath;

Map<String, dynamic> defaultConfiguration = {
  "BottomNavigationBar": [
    {
      "id": 1,
      "labelKey": GeneralKey.bottomNavigationHomeKey,
      "label": "home_bottom_navigation",
      "icon": IconPath.bottomNavigationHomeIcon,
      "activeIcon": IconPath.activeBottomNavigationHomeIcon
    },
    {
      "id": 2,
      "labelKey": GeneralKey.bottomNavigationOrdersKey,
      "label": "orders_bottom_navigation",
      "icon": IconPath.bottomNavigationOrdersIcon,
      "activeIcon": IconPath.activeBottomNavigationOrdersIcon
    },
    // {
    //   "id": 3,
    //   "labelKey": GeneralKey.bottomNavigationFavoriteKey,
    //   "label": "favorite_bottom_navigation",
    //   "icon": IconPath.bottomNavigationFavoriteIcon,
    //   "activeIcon": IconPath.activeBottomNavigationFavoriteIcon
    // },
    {
      "id": 3,
      "labelKey": GeneralKey.bottomNavigationProfileKey,
      "label": "profile_bottom_navigation",
      "icon": IconPath.bottomNavigationProfileIcon,
      "activeIcon": IconPath.activeBottomNavigationProfileIcon
    },
  ],
};
