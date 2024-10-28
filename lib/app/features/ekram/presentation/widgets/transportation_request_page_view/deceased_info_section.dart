import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/cards/expandable_card.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget%20copy.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class DeceasedInfoSection extends StatelessWidget {
  const DeceasedInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header:
                            Helpers.translatingWord("cemetry_deceassed_info"),
                      ),
                      ExpandableCard(
                        title: 'deceased_verification'.tr(),
                        children: [],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: DeceasedInfoTextFieldsSection())
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons()
          ],
        );
      },
    );
  }
}

class DeceasedInfoTextFieldsSection extends StatefulWidget {
  const DeceasedInfoTextFieldsSection({super.key});

  @override
  State<DeceasedInfoTextFieldsSection> createState() =>
      _ApplicantInfoTextFieldsSectionState();
}

class _ApplicantInfoTextFieldsSectionState
    extends State<DeceasedInfoTextFieldsSection> {
  //final fullNameTextEditController = TextEditingController();
  //final mobileTextEditController = TextEditingController();
  //final applicantTypeTextEditController = TextEditingController();
//  final relationShipTextEditController = TextEditingController();

  //final fullNameFocusNode = FocusNode();
  // final mobileFocusNode = FocusNode();
  // final applicantTypeFocusNode = FocusNode();
  //final relationShipFocusNode = FocusNode();

  @override
  void dispose() {
    // fullNameTextEditController.clear();
    // fullNameTextEditController.dispose();
    // mobileTextEditController.clear();
    //  mobileTextEditController.dispose();
    //  applicantTypeTextEditController.clear();
    // applicantTypeTextEditController.dispose();
    // applicantTypeTextEditController.clear();
    // relationShipTextEditController.dispose();

    // fullNameFocusNode.dispose();
    // mobileFocusNode.dispose();
    // applicantTypeFocusNode.dispose();
    //   relationShipFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(IconPath.editIcon),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  'deceasedInfo'.tr(),
                  style: const TextStyle(
                    color: AppColor.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            CustomTextFieldWidget(
                label: "ekram_first_name".tr(),
                hintText: "ekram_first_name".tr(),
                onChanged: (String? text) {},
                onValidate: (String? value) {
                  return null;
                }),
            const CustomVerticalSpace(height: 16),
            CustomTextFieldWidget(
                label: "ekram_second_name".tr(),
                hintText: "ekram_second_name".tr(),
                onChanged: (String? text) {},
                onValidate: (String? value) {
                  return null;
                }),
            const CustomVerticalSpace(height: 16),
            CustomTextFieldWidget(
                label: "ekram_third_name".tr(),
                hintText: "ekram_third_name".tr(),
                onChanged: (String? text) {},
                onValidate: (String? value) {
                  return null;
                }),
            const CustomVerticalSpace(height: 16),
            CustomTextFieldWidget(
                label: "ekram_fourth_name".tr(),
                hintText: "ekram_fourth_name".tr(),
                onChanged: (String? text) {},
                onValidate: (String? value) {
                  return null;
                }),
            const CustomVerticalSpace(height: 16),
            CustomLookUpLongDialog(
              items: state.nationalities ?? [],
              onEmptyList: () async {},
              onChangeType: (LookUpItem? item) {
                if (item != null) {}
              },
              label: ("nationality").tr(),
              hint: ("nationality").tr(),
            ),
            const CustomVerticalSpace(height: 20),
            CustomTextWidget(
              ("burialDestination").tr(),
              fontColor: AppColor.blackModern700Light,
              fontSize: 17.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("burial_in_death_city").tr(),
                    value: true,
                    currentSelected: true,
                    onChange: (bool item) {},
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("female").tr(),
                    value: true,
                    currentSelected: false,
                    onChange: (bool item) {},
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
              ],
            ),
            CustomTextWidget(
              ("ekramReligion").tr(),
              fontColor: AppColor.blackModern700Light,
              fontSize: 17.0,
              textAlign: TextAlign.start,
              fontWeight: AppFontWeight.bold,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("muslim").tr(),
                    value: true,
                    currentSelected: true,
                    onChange: (bool item) {},
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomRadioButtonEnd<bool>(
                    title: ("non_muslim").tr(),
                    value: true,
                    currentSelected: false,
                    onChange: (bool item) {},
                    endRadio: false,
                    unSelectedBackgroundColor: Colors.transparent,
                    textSize: 16,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
