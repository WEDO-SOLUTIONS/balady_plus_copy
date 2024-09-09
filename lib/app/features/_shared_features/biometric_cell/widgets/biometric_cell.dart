import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';

class BiometricCell extends StatefulWidget {
  const BiometricCell({super.key});

  @override
  State<BiometricCell> createState() => _AuthQuickAccessCellState();
}

class _AuthQuickAccessCellState extends State<BiometricCell> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF5F7FA),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        IconPath.biometric,
                        height: 24,
                        width: 24,
                        colorFilter: const ColorFilter.mode(
                          AppColor.primary900Light,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Text(
                          'biometric'.tr(),
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()!
                              .text
                              .copyWith(color: const Color(0xFF1E2A36)),
                        ),
                      ),
                      const Spacer(),
                      IgnorePointer(
                        child: CupertinoSwitch(
                          onChanged: (bool value) {},
                          value: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
