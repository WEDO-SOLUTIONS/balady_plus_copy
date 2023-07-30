import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';

class OtherInfoSectionWidget extends StatelessWidget {
  final String? city;
  final String? cancelPurpose;

  const OtherInfoSectionWidget({Key? key, this.city, this.cancelPurpose})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitleWidget(
          title: trans('order_other_info'),
          primaryIcon: PrimaryIcons.providerOtherInfoIcon,
        ),
        EtmamCustomReadOnlyTextWidget(
            label: trans('order_city'), text: city ?? ""),
        if (cancelPurpose != null && cancelPurpose!.isNotEmpty) ...[
          const CustomVerticalSpace(height: 16),
          EtmamCustomReadOnlyTextWidget(
              label: trans('order_cancel_purpose'), text: cancelPurpose ?? ""),
        ],
        CustomVerticalSpace(height: 30)
      ],
    );
  }
}
