import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/retry_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, BlocRequestStatus, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart' show CustomTextWidget, ShimmerEffectWidget;

class DropDownWithTitle extends StatelessWidget {
  final String title;
  final String? selectedValue;
  final double? height;
  final VoidCallback onTap;
  final bool showArrow;
  final bool isRequired;
  final BlocRequestStatus? status;
  final BlocStatus? blocStatus;

  final VoidCallback? onRetry;

  const DropDownWithTitle({
    super.key,
    required this.title,
    this.selectedValue,
    this.height,
    required this.onTap,
    this.showArrow = true,
    this.isRequired = false,
    this.status,
    this.blocStatus,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final loading = (status == BlocRequestStatus.submissionGetLoading || blocStatus == BlocStatus.loading);
    final retry = (status == BlocRequestStatus.submissionGetFailure || blocStatus == BlocStatus.failure);

    return InkWell(
      onTap: () {
        if (!loading) onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Row(
                children: [
                  CustomTextWidget(title, textStyle: AppStyle.dropDownTitleTextStyle),
                  isRequired
                      ? CustomTextWidget(
                          '*'.tr(),
                          textStyle: AppStyle.dropDownTitleTextStyle.copyWith(color: Colors.red.shade700),
                        )
                      : const SizedBox(),
                ],
              ),
            const SizedBox(height: 8),
            if (retry)
              RetryWidget(onRetry: onRetry)
            else if (loading)
              const ShimmerEffectWidget(height: 48, borderRadius: 8)
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: height ?? 48,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.blackModern300Light, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextWidget(
                        selectedValue ?? "choose".tr(),
                        textStyle: AppStyle.dropDownValueTextStyle,
                        maxLines: 2,
                      ),
                    ),
                    if (showArrow)
                      SvgPicture.asset(
                        IconPath.arrowDown,
                        colorFilter: ColorFilter.mode(AppColor.blackModern600Light, BlendMode.srcIn),
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
