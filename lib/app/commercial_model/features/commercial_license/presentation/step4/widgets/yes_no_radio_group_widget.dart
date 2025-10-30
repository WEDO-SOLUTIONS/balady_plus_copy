import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';

class YesNoRadioGroupWidget extends StatelessWidget {
  final String groupName;
  final bool? isMandatory;
  final bool? currentValue;
  final Function(bool?) onChanged;

  const YesNoRadioGroupWidget(
      {Key? key,
      this.currentValue,
      this.isMandatory,
      required this.groupName,
      required this.onChanged})
      : super(key: key);

  @override
  build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextWithOptional(
          label: groupName,
          labelColor: AppColor.blackModern700Light,
          labelSize: 16,
          labelTextAlign: TextAlign.start,
          showOptional: isMandatory,
        ),
        const CustomVerticalSpace(height: GeneralKey.smallPadding),
        // types
        Row(
          children: ["Yes".tr(), "No".tr()]
              .map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                          end: e == "No".tr() ? 0 : 16),
                      child: CustomRadioButtonEnd<RadioItem<String>>(
                        title: e,
                        value: RadioItem<String>(radioValue: e, radioText: e),
                        height: 48,
                        currentSelected: currentValue == null
                            ? null
                            : currentValue == true
                                ? RadioItem<String>(
                                    radioValue: "Yes".tr(),
                                    radioText: "Yes".tr())
                                : RadioItem<String>(
                                    radioValue: "No".tr(),
                                    radioText: "No".tr()),
                        onChange: (RadioItem? item) {
                          onChanged(
                              item?.radioValue == "Yes".tr() ? true : false);
                        },
                        endRadio: false,
                        unSelectedBackgroundColor: Colors.transparent,
                        textSize: 12,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const CustomVerticalSpace(height: 30.0),
      ],
    );
  }
}
