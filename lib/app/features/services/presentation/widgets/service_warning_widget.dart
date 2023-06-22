import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart';

class ServiceWarningWidget extends StatefulWidget {
  final String warning;

  const ServiceWarningWidget({
    super.key,
    required this.warning,
  });

  @override
  State<ServiceWarningWidget> createState() => _ServiceWarningWidgetState();
}

class _ServiceWarningWidgetState extends State<ServiceWarningWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _isExpanded ? 300 : 160,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.dark5,
            offset: Offset(0, -4),
            blurRadius: 32,
          )
        ],
        color: AppColor.white,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: const DrawLineWidget(
                    lineWidth: 70.0,
                    lineHeight: 6.0,
                    lineColor: AppColor.gray,
                    radius: 46.0,
                  ),
                ),
                if (_isExpanded) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const DrawIconBasedTypeWidget(
                        icon: IconPath.warnings,
                        iconSize: 22,
                      ),
                      const SizedBox(width: 8),
                      CustomTextWidget(
                        'warnings'.tr(),
                        textStyle: AppStyle.serviceCardWarningTitleTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomAutoSizeTextWidget(
                    widget.warning,
                    textStyle: AppStyle.serviceCardDescriptionTextStyle,
                    maxLines: 4,
                  ),
                ],
                const Spacer(),
                ElevatedButtonWidget.startService(
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
