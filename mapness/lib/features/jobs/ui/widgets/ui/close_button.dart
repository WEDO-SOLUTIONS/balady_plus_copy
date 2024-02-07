import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloseButton extends StatelessWidget {
  final VoidCallback onTap;
  final BorderRadius? borderRadius;
  const CloseButton({
    required this.onTap,
    super.key,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              // color: Colors.white,
              color: Color(0xffF4F4F5),
            ),
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/svg/ic_search_close.svg',
              semanticsLabel: 'MinApps Screen',
              package: 'mapness',
              colorFilter: ColorFilter.mode(
                const Color(0xff1E2A36).withOpacity(0.7),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
}
