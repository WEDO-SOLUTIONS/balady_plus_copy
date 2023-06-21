import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;
import '../../shared_feature_exports.dart' show CustomTextWidget;

class RetryWidget extends StatelessWidget {
  final double height;
  final VoidCallback onRetry;

  const RetryWidget({
    super.key,
    required this.onRetry,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: InkWell(
          onTap: onRetry,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.refresh,
                size: 28,
                color: AppColor.primary900Light,
              ),
              const SizedBox(height: 10),
              CustomTextWidget(
                "retry".tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
