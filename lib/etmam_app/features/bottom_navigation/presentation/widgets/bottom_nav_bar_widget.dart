import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer, ReadContext;
import '../../../../core/utils/utils_exports.dart'
    show AppColor, BottomNavBar, ContextConversion;
import '../../bottom_navigation_exports.dart'
    show BottomNavBarCubit, BottomNavBarCardWidget;

class BottomNavBarWidget extends StatelessWidget {
  final void Function(int) onSelectedBottomNavBar;
  const BottomNavBarWidget({Key? key, required this.onSelectedBottomNavBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    return BlocConsumer<BottomNavBarCubit, BottomNavBar>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) => onSelectedBottomNavBar(state.index),
      // buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        return Container(
          width: width,
          height: 100.0,
          padding: EdgeInsets.only(bottom: context.bottomPadding * 0.5),
          decoration: const BoxDecoration(
            color: AppColor.white,
            border: Border(
              top: BorderSide(color: AppColor.blue, width: 0.5),
            ),
          ),
          child: Row(
            children: BottomNavBar.values
                .map((navBar) => Container(
                      width: width / BottomNavBar.values.length,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: BottomNavBarCardWidget(
                        icon: navBar.icon,
                        label: navBar.label,
                        isSelected: state.index == navBar.index,
                        onSelected: () => context
                            .read<BottomNavBarCubit>()
                            .onChangeBottomNavBar(navBar.index),
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}
