import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep3GeolocationData extends StatelessWidget {
  const CRStep3GeolocationData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRHeaderDesc(
                    header: 'step3Title'.tr(),
                  ),
                  const SizedBox(height: 12),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "objection_location".tr(),
                    marginBottom: 24,
                    onChangeType: (item) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "area_spot".tr(),
                    marginBottom: 24,
                    onChangeType: (item) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "trust_policy".tr(),
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "trust_policy".tr(),
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "daem_sub_municiplaity".tr(),
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "sub_street".tr(),
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "street".tr(),
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "geoLocation_number".tr(),
                    hintText: "geolocation_entry_number".tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "ground_number".tr(),
                    hintText: "ground_number_entry".tr(),
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
        ),
        const CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
