import 'package:flutter/material.dart';

import '../utils_exports.dart';

enum NearByTypes {
  all(title: "all", icon: null, color: AppColor.primary700Light),
  coffee(title: "coffee", icon: "coffee", color: AppColor.dirtBrown),
  hotel(title: "hotel", icon: "hotel", color: AppColor.salmon),
  mosque(title: "mosque", icon: "mosque", color: AppColor.dullOrange),
  restaurant(
      title: "restaurant", icon: "restaurant", color: AppColor.terraCotta);

  const NearByTypes(
      {required this.title, required this.icon, required this.color});
  final String title;
  final String? icon;
  final Color color;
}
