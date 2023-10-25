import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/common/config/package_config.dart';

class CloseHappinessButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CloseHappinessButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xffE7ECF3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          'assets/icons/svg/ic_close.svg',
          height: 16,
          width: 16,
          package: PackageConfig.packageName,
        ),
      ),
    );
  }
}
