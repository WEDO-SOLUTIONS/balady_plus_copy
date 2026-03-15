import 'dart:ui';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';

enum CustomSearchCategory { events }

extension CustomSearchCategoryData on CustomSearchCategory {
  String displayName() {
    return switch (this) {
      CustomSearchCategory.events => "الفعاليات",
    };
  }

  String iconName() {
    return switch (this) {
      CustomSearchCategory.events => "assets/maps/icons/events_category_icon.svg",
    };
  }

  String markerIconName() {
    return switch (this) {
      CustomSearchCategory.events => "assets/maps/icons/events_pin.svg",
    };
  }

  String cardIconName() {
    return switch (this) {
      CustomSearchCategory.events => "assets/maps/icons/card_icon/ticket.png",
    };
  }

  Color cardIconColor() {
    return switch (this) {
      CustomSearchCategory.events => AppColor.secondary200Light,
    };
  }
}
