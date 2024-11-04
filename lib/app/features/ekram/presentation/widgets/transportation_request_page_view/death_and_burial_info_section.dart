import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget%20copy.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/gorgian_date_widget.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/ekram_book_cemetry/hijri_date_widget.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class DeathAndBurialInfoSection extends StatelessWidget {
  const DeathAndBurialInfoSection({super.key});

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
                  margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      VdHeaderDesc(
                        header: Helpers.translatingWord("deathInfo"),
                      ),
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
                                  'deathData'.tr(),
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            HijriCalendarDateWidget(
                              fieldName:
                                  Helpers.translatingWord("death_date_hijri"),
                              isMandatory: true,
                              onChanged: (String? date) {},
                            ),
                            GorgianCalendarDateWidget(
                              fieldName:
                                  Helpers.translatingWord("death_date_gorgian"),
                              isMandatory: true,
                              onChanged: (String? date) {},
                            ),
                            CustomLookUpLongDialog(
                              items: const [],
                              value: LookUpItem(),
                              isDisbaled: false,
                              onEmptyList: () async {},
                              onChangeType: (LookUpItem? item) {},
                              label: "burialCity".tr(),
                              hint: "",
                            ),
                            CustomLookUpLongDialog(
                              items: const [],
                              value: LookUpItem(),
                              isDisbaled: false,
                              onEmptyList: () async {},
                              onChangeType: (LookUpItem? item) {},
                              label: "ekramHospital".tr(),
                              hint: "",
                            ),
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
                                    unSelectedBackgroundColor:
                                        Colors.transparent,
                                    textSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: CustomRadioButtonEnd<bool>(
                                    title: ("burial_in_other_city").tr(),
                                    value: true,
                                    currentSelected: false,
                                    onChange: (bool item) {},
                                    endRadio: false,
                                    unSelectedBackgroundColor:
                                        Colors.transparent,
                                    textSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            CustomLookUpLongDialog(
                              items: const [],
                              value: LookUpItem(),
                              isDisbaled: false,
                              onEmptyList: () async {},
                              onChangeType: (LookUpItem? item) {},
                              label: "burial_city".tr(),
                              hint: "",
                            ),
                            HijriCalendarDateWidget(
                              fieldName: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_date_hijri"),
                              isMandatory: true,
                              onChanged: (String? date) {},
                            ),
                            GorgianCalendarDateWidget(
                              fieldName: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_date_gorgian"),
                              isMandatory: true,
                              onChanged: (String? date) {},
                            ),
                            CustomLookUpLongDialog(
                              items: [],
                              value: LookUpItem(),
                              onEmptyList: () async {},
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {}
                              },
                              label: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_time"),
                              hint: Helpers.translatingWord(
                                  "cemetry_deceassed_burial_time"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
             EkramPreviousNextButtons(btnPressed: (){

              context.read<EkramRequestTransportationBloc>().add(GoToNextPageEvent());
            },)
          ],
        );
      },
    );
  }
}
