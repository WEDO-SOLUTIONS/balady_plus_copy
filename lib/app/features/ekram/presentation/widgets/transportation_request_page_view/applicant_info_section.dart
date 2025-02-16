import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class ApplicantInfoSection extends StatelessWidget {
  const ApplicantInfoSection({super.key});

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
                        header: Helpers.translatingWord("ekram_main_data"),
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
                                  'applicantInfo'.tr(),
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            ReadOnlyField(
                              hieght: 55,
                              title: "health_submitter_name".tr(),
                              subTitle: state.requestDetailsModel?.mainInfo
                                      ?.submitterInfo?.fullName ??
                                  state.fullName!,
                              subTitleColor: AppColor.grey1000.withOpacity(0.5),
                              decoration: BoxDecoration(
                                  color: AppColor.blackModern300Light
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            ReadOnlyField(
                              hieght: 55,
                              title: "driver_card_applicant_mobile".tr(),
                              subTitle: state.requestDetailsModel?.mainInfo
                                      ?.submitterInfo?.mobileNumber ??
                                  state.mobileNumber!,
                              subTitleColor: AppColor.grey1000.withOpacity(0.5),
                              decoration: BoxDecoration(
                                  color: AppColor.blackModern300Light
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            CustomTextFieldWidget(
                                label: "ekramRelationShip".tr(),
                                initialValue: state
                                        .requestDetailsModel
                                        ?.mainInfo
                                        ?.submitterInfo
                                        ?.relationship ??
                                    "",
                                hintText: "ekramRelationShip".tr(),
                                onChanged: (String? text) {
                                  if (text != null) {
                                    context
                                        .read<EkramRequestTransportationBloc>()
                                        .add(SetApplicantInfoEvent(
                                            relation: text));
                                  }
                                },
                                onValidate: (String? value) {
                                  return null;
                                }),
                            CustomLookUpLongDialog(
                              items: const [],
                              value: LookUpItem(
                                  name: 'transportation_from_hospital'.tr(),
                                  id: 3),
                              isDisbaled: true,
                              onChangeType: (LookUpItem? item) {},
                              label: "deceasedTransportationStatus".tr(),
                              hint: "",
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: const Color(0x0e7fa891)),
                              child: const Text(
                                'لحالات النقل من غير المستشفى، يرجى مراجعة الجهات ذات العلاقة:\n\u2022 مراجعة الشرطة للوفاة داخل المنزل.\n\u2022 مراجعة المرور للوفاة بسبب حادث.\n\u2022 مراجعة الدفاع المدني بسبب حادث غير مروري.\n',
                                style: TextStyle(color: Color(0xff155F75)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            InkWell(
              onTap: () async {

                context
                    .read<EkramRequestTransportationBloc>()
                    .add(const saveDeceasedInfoEvent(isDarft: true));
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                margin:const EdgeInsets.all(16) ,
                decoration:  BoxDecoration(color: Colors.transparent, border: Border.all(color: AppColor.borderBlck, width: 1), borderRadius: BorderRadius.circular(6)),
                //:BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    CustomTextWidget(
                      "SaveAsDraft".tr(),
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.borderBlck,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
            EkramPreviousNextButtons(btnPressed: () {
              context
                  .read<EkramRequestTransportationBloc>()
                  .add(const saveDeceasedInfoEvent());
            })
          ],
        );
      },
    );
  }
}
