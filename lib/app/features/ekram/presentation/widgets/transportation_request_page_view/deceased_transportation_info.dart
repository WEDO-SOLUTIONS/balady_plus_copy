import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/widgets/card_desc_widget.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget%20copy.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:smart_advisor/app/core/utils/constants/app_config.dart';

class DeceasedTransportationInfo extends StatelessWidget {
  const DeceasedTransportationInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin:
                          const EdgeInsets.only(top: 24, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(IconPath.editIcon),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'transferInfo'.tr(),
                                      style: const TextStyle(
                                        color: AppColor.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                CustomTextWidget(
                                  trans(
                                      "is_deaceased_requrie_special_transfer"),
                                  fontColor: AppColor.blackModern700Light,
                                  fontSize: 16.0,
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                  fontWeight: AppFontWeight.bold,
                                ),
                                CustomVerticalSpace(height: 10),
                                CustomRadioButtonEnd<bool>(
                                  title: trans("yes"),
                                  value: true,
                                  currentSelected: true,
                                  onChange: (bool item) {
                                    // context
                                    //     .read<EkramAddDeceasedBloc>()
                                    //     .add(ChangeIsNeedSpecialTransferEvent(isNeeded: true));
                                  },
                                  endRadio: false,
                                  unSelectedBackgroundColor: Colors.transparent,
                                  textSize: 16,
                                ),
                                CustomVerticalSpace(height: 10),
                                CustomRadioButtonEnd<bool>(
                                  title: trans("no"),
                                  value: true,
                                  currentSelected: false,
                                  onChange: (bool item) {
                                    // context
                                    //     .read<EkramAddDeceasedBloc>()
                                    //     .add(ChangeIsNeedSpecialTransferEvent(isNeeded: false));
                                  },
                                  endRadio: false,
                                  unSelectedBackgroundColor: Colors.transparent,
                                  textSize: 16,
                                ),
                                CustomLookUpLongDialog(
                                  items: [],
                                  value: null,
                                  onChangeType: (LookUpItem? item) {},
                                  onEmptyList: () async {},
                                  label: ("reasonForSpecialTransfer").tr(),
                                  hint: ("reasonForSpecialTransfer").tr(),
                                ),
                                CustomTextFieldWidget(
                                    bottomMargin: 30,
                                    label: "deathLocation".tr(),
                                    onChanged: (String? text) {},
                                    onValidate: (String? value) {
                                      return null;
                                    }),
                                CustomLookUpLongDialog(
                                  items: const [],
                                  value: LookUpItem(),
                                  isDisbaled: false,
                                  onEmptyList: () async {},
                                  onChangeType: (LookUpItem? item) {},
                                  label: "cemetry_type".tr(),
                                  hint: "",
                                ),
                                CustomLookUpLongDialog(
                                  items: const [],
                                  value: LookUpItem(),
                                  isDisbaled: false,
                                  onEmptyList: () async {},
                                  onChangeType: (LookUpItem? item) {},
                                  label: "cemeteryName".tr(),
                                  hint: "",
                                ),
                                CustomLookUpLongDialog(
                                  items: const [],
                                  value: LookUpItem(),
                                  isDisbaled: false,
                                  onEmptyList: () async {},
                                  onChangeType: (LookUpItem? item) {},
                                  label: "ekram_orgnization_name".tr(),
                                  hint: "",
                                ),
                                CustomLookUpLongDialog(
                                  items: const [],
                                  value: LookUpItem(),
                                  isDisbaled: false,
                                  onEmptyList: () async {},
                                  onChangeType: (LookUpItem? item) {},
                                  label: "ekram_laundry".tr(),
                                  hint: "",
                                ),
                                CustomLookUpLongDialog(
                                  items: const [],
                                  value: LookUpItem(),
                                  isDisbaled: false,
                                  onEmptyList: () async {},
                                  onChangeType: (LookUpItem? item) {},
                                  label: "the_mosque".tr(),
                                  hint: "",
                                ),
                                CustomTextFieldWidget(
                                    bottomMargin: 30,
                                    label: "ekram_permit_no".tr(),
                                    onChanged: (String? text) {},
                                    onValidate: (String? value) {
                                      return null;
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.sizeOf(context).height / 3,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Column(
                  children: [
                    CardDescWidget(
                      icon: IconPath.saveIcon,
                      title: 'pledges'.tr(),
                      description: 'pledges_submit_commercial_description'.tr(),
                      widget: InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (bool? value) {},
                            ),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                'acknowledge_pledge'.tr(),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const EkramPreviousNextButtons()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
