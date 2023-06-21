import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, ShimmerEffectWidget;

class DropDownWithTitle extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final VoidCallback onTap;
  final bool loading;
  final Widget? retryWidget;

  const DropDownWithTitle({
    super.key,
    required this.title,
    this.selectedValue,
    required this.onTap,
    this.loading = false,
    this.retryWidget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!loading) onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              title,
              textStyle: AppStyle.dropDownTitleTextStle,
            ),
            const SizedBox(height: 8),
            if (retryWidget != null)
              retryWidget!
            else if (loading)
              const ShimmerEffectWidget(
                height: 48,
                borderRadius: 8,
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.blackModern300Light,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomTextWidget(
                      selectedValue ?? "choose".tr(),
                      textStyle: AppStyle.dropDownValueTextStle,
                    ),
                    const Spacer(),
                    SvgPicture.asset(
                      IconPath.arrowDown,
                      colorFilter: const ColorFilter.mode(
                        AppColor.blackModern600Light,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
