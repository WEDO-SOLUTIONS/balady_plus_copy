import '/app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../../../features/contact/presentation/pages/contact_page.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../utils_exports.dart' show IconPath;

enum BottomNavBar {
  home(
      icon: IconPath.home,
      iconActive: IconPath.homeActive,
      label: "home",
      page: HomePage()),
  profile(
      icon: IconPath.profile,
      iconActive: IconPath.profileActive,
      label: "profile",
      page: ProfilePage()),
  contact(
      icon: IconPath.contact,
      iconActive: IconPath.contactActive,
      label: "contact",
      page: ContactPage());

  const BottomNavBar(
      {required this.icon,
      required this.label,
      required this.iconActive,
      required this.page});

  final String icon;
  final String iconActive;
  final String label;
  final Widget page;
}
