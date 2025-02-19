import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/deceased_birthdate_gregorian.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_widgets/deceased_birthdate_hijri.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../../data/model/reset_action_enum.dart';

class DeceasedVerificationSection extends StatelessWidget {
  DeceasedVerificationSection({super.key});



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      listener: (context, state) {},
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
                        header: Helpers.translatingWord("deceasedInfo"),
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
                                  'deceased_verification'.tr(),
                                  style: const TextStyle(
                                    color: AppColor.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                            CustomLookUpLongDialog(
                              items: state.nationalIdTypes ?? [],
                            //  isDisbaled:(state.editInfoSection==false),
                             isDisbaled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.NationalityType, null),

                              value: state.selectedNationalIdType,
                              onEmptyList: () async {
                                return context
                                    .read<EkramRequestTransportationBloc>()
                                    .getEkramNationalIdTypesEventHandler();
                              },
                              onChangeType: (LookUpItem? item) {
                                if (item != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(SelectNationalIdTypeEvent(
                                          item: item));
                                }
                              },
                              label: ("ekram_identity_type").tr(),
                              hint: ("ekram_identity_type").tr(),
                            ),

                            CustomTextFieldWidget(
                              isRequired: true,
                              enabled:! state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.NationalityId, null),
                              label: "ekram_decesssed_identity".tr(),
                              isDigitsOnly: state.selectedNationalIdType?.id ==
                                          1 ||
                                      state.selectedNationalIdType?.id == 3 ||
                                      state.selectedNationalIdType?.id == 9 ||
                                      state.selectedNationalIdType?.id == 10
                                  ? true
                                  : false,
                              controller: context
                                  .read<EkramRequestTransportationBloc>().decesssedIdentity,
                              keyboardType: state.selectedNationalIdType?.id ==
                                          1 ||
                                      state.selectedNationalIdType?.id == 3 ||
                                      state.selectedNationalIdType?.id == 9 ||
                                      state.selectedNationalIdType?.id == 10
                                  ? TextInputType.number
                                  : TextInputType.text,
                              onChanged: (String? val) {
                                if (val != null) {
                                  context
                                      .read<EkramRequestTransportationBloc>().decesssedIdentity?.text = val;
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(ChangeIdEvent(deceasedId: val));
                                }
                              },
                              onValidate: context
                                  .read<EkramRequestTransportationBloc>()
                                  .validateNationalId,
                            ),
                             DeceasedBirthdateHijri(isDisabled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.BirthDate, null),),
                             DeceasedBirthdateGregorian(isDisabled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.BirthDate, null),
                             ),
                            state.isDraft !=true? ElevatedButtonWidget.primaryCustomBorder(
                              //     btnPressed: isBtnDisabled
                              //         ? () {}
                              //         : btnPressed,
                              bgColor: state.isDeceasedBtnEnabled == true
                                  ? AppColor.primary900Light
                                  : AppColor.black200,
                              color: state.isDeceasedBtnEnabled == true
                                  ? AppColor.white
                                  : AppColor.black400,
                              onPressed: () async {
                                if (state.isDeceasedBtnEnabled == true) {
                                  context
                                      .read<EkramRequestTransportationBloc>()
                                      .add(const VerifyDeceasedEvent());
                                }
                              },
                              text: "verify".tr(),
                            ):Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons(btnPressed: () {
              context
                  .read<EkramRequestTransportationBloc>()
                  .add(const GoToNextPageEvent());
            })
          ],
        );
      },
    );
  }
}
