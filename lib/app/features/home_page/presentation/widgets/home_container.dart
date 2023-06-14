import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;

class HomeContainer extends StatelessWidget {
  final Widget child;
  const HomeContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.blueGreen,
            AppColor.darkSeaGreen,
            AppColor.primary900Light
          ],
        ),
      ),
      height: double.infinity,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(36),
              bottomRight: Radius.circular(36),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
