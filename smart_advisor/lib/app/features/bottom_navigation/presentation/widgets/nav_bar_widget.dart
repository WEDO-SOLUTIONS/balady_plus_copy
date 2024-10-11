import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, ReadContext;

import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../bottom_navigation_exports.dart'
    show BottomNavBarCardWidget, BottomNavBarCubit, BottomNavBarStructure;

class BottomNavBarWidget extends StatelessWidget {
  final void Function(int) onSelectedBottomNavBar;
  const BottomNavBarWidget({super.key, required this.onSelectedBottomNavBar});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBarCubit, int>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) => onSelectedBottomNavBar(state),
      // buildWhen: (previous, current) => previous != current,
      builder: (_, state) => BottomNavBarStructure(
        children: BottomNavBar.values
            .map((navBar) => BottomNavBarCardWidget(
                  icon: navBar.icon,
                  iconActive: navBar.iconActive,
                  label: navBar.label,
                  isSelected: state == navBar.index,
                  onSelected: () => context
                      .read<BottomNavBarCubit>()
                      .onChangeBottomNavBar(navBar.index),
                ))
            .toList(),
      ),
    );
  }
}
