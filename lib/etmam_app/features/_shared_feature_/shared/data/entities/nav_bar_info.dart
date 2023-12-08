import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/widgets.dart' show IconData;

import '../../../../../core/utils/utils_exports.dart' show StringIconChecker;

class NavBarInfo extends Equatable {
  final int? navBarIndex;
  final String? label;
  final Object? icon;
  final bool isSelected;

  const NavBarInfo({
    this.navBarIndex = 0,
    this.label,
    this.icon,
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [navBarIndex, label, icon, isSelected];

  NavBarInfo copyWith({
    int? navBarIndex,
    String? label,
    Object? icon,
    bool? isSelected,
  }) {
    return NavBarInfo(
      navBarIndex: navBarIndex ?? this.navBarIndex,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  bool get isSvgIcon => (icon as String).isSvgIcon;
  bool get isImgIcon => (icon as String).isImgIcon;
  bool get isMaterialIcon => (icon is IconData) && icon != null;

  @override
  String toString() {
    return 'TabInfo(navBarIndex: $navBarIndex, label: $label, icon: $icon, isSelected: $isSelected)';
  }
}
