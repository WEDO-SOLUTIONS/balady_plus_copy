import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        CustomAutoSizeTextWidget,
        CustomTextWidget,
        DrawIconBasedTypeWidget,
        DrawLineWidget,
        ElevatedButtonWidget;

class ServiceWarningWidget extends StatefulWidget {
  final String warning;
  final Function? onPress;
  final bool expandedWarning;

  const ServiceWarningWidget({super.key, required this.warning, this.onPress, this.expandedWarning = false});

  @override
  State<ServiceWarningWidget> createState() => _ServiceWarningWidgetState();
}

class _ServiceWarningWidgetState extends State<ServiceWarningWidget> {

  bool expandedWarning = false;

  @override
  void initState() {
    super.initState();
    expandedWarning = widget.expandedWarning;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.expandedWarning ? 320 : 160,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      expandedWarning = !expandedWarning;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: DrawLineWidget(
                      lineWidth: 70.0,
                      lineHeight: 6.0,
                      lineColor: AppColor.gray,
                      radius: 46.0,
                    ),
                  ),
                ),
                if (widget.expandedWarning) ...[
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
                        textStyle:
                        AppStyle.serviceCardWarningTitleTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: CustomAutoSizeTextWidget(
                        widget.warning,
                        textStyle: AppStyle.serviceCardDescriptionTextStyle,
                        maxLines: 20,
                      ),
                    ),
                  ),
                ],
                if (!widget.expandedWarning) const Spacer(),
                ElevatedButtonWidget.startService(
                  onPressed: () => widget.onPress != null ? widget.onPress!() : () {},
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
