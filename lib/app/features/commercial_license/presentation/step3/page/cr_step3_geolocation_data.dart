import 'package:flutter/material.dart';
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
                  const CRHeaderDesc(header: "بيانات الموقع الجغرافي"),
                  const SizedBox(height: 12),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "الموقع",
                    marginBottom: 24,
                    onChangeType: (item) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "المنطقه",
                    marginBottom: 24,
                    onChangeType: (item) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "الامانه",
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "الامانه",
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "البلديه",
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "الحي",
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTapWidgetForLongDialog(
                    items: const [],
                    value: null,
                    label: "الشارع",
                    marginBottom: 24,
                    onChangeType: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "رقم المخطط",
                    hintText: "ادخل رقم المخطط",
                    isDigitsOnly: true,
                    keyboardType: TextInputType.number,
                    bottomMargin: 24,
                    onChanged: (value) {},
                  ),
                  CustomTextFieldWidget(
                    label: "رقم قطعه الارض",
                    hintText: "ادخل رقم قطعه الارض",
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
