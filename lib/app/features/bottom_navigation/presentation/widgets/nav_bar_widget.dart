import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, ReadContext;

import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../bottom_navigation_exports.dart';

class BottomNavBarWidget extends StatelessWidget {
  final void Function(int?, int) onSelectedBottomNavBar;
  const BottomNavBarWidget({super.key, required this.onSelectedBottomNavBar});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomNavBarCubit, BottomNavBarState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) => onSelectedBottomNavBar(state.previous?.index, state.current.index),
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) => BottomNavBarStructure(
        children: BottomNavBar.arrangedValues
            .map((navBar) => BottomNavBarCardWidget(
                  icon: navBar.icon,
                  label: navBar.label,
                  isSelected: state.current.index == navBar.index,
                  onSelected: () => context.read<BottomNavBarCubit>().onChangeBottomNavBar(navBar.index),
                ))
            .toList(),
      ),
    );
  }
}
