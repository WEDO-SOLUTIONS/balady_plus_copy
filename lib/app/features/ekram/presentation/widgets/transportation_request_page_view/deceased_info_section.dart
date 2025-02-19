import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget%20copy.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../data/model/request_details_response_model/deceased_info.dart';
import '../../../data/model/reset_action_enum.dart';

// class DeceasedInfoSection extends StatefulWidget  {
//   const DeceasedInfoSection({Key? key}) : super(key: key);
//
//   @override
//   State<DeceasedInfoSection> createState() =>
//       _DeceasedInfoSectionState();
// }

class DeceasedInfoSection extends StatelessWidget {
  const DeceasedInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      listener: (context, state) {
        CommonFunctions.showError(state.cemeteryReservationMsg != null
            ? state.cemeteryReservationMsg!
            : '');
      },
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
                    children: [
                      const SizedBox(
                        height: 20,
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
                                    'deceasedInfo'.tr(),
                                    style: const TextStyle(
                                      color: AppColor.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                    state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Name, null)== false
                                  ? CustomTextFieldWidget(
                                      isRequired: true,
                                      enabled: true,
                                      label: "ekram_first_name".tr(),
                                      hintText: "ekram_first_name".tr(),
                                      textFieldHeight: 55,
                                      initialValue: state.requestDetailsModel
                                              ?.deceasedInfo?.firstName ??
                                          "",
                                      onChanged: (String? text) {
                                        if (text != null) {
                                          //firstName?.text = text;
                                          context
                                              .read<
                                                  EkramRequestTransportationBloc>()
                                              .add(ChangeDeceasedUserInfoEvent(
                                                  item: DeceasedInfo(
                                                      firstName: text)));
                                        }
                                      },
                                      onValidate: (String? value) {
                                        return null;
                                      })
                                  : ReadOnlyField(
                                      hieght: 55,
                                      title: "ekram_first_name".tr(),
                                      subTitle: state.requestDetailsModel
                                              ?.deceasedInfo?.firstName ??
                                          "",
                                      subTitleColor:
                                          AppColor.grey1000.withOpacity(0.5),
                                      decoration: BoxDecoration(
                                          color: AppColor.blackModern300Light
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                              const CustomVerticalSpace(height: 16),
                              state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Name, null)== false
                                  ? CustomTextFieldWidget(
                                      label: "ekram_second_name".tr(),
                                      hintText: "ekram_second_name".tr(),
                                      textFieldHeight: 55,
                                      initialValue: state.requestDetailsModel
                                              ?.deceasedInfo?.secondName ??
                                          "",
                                      onChanged: (String? text) {
                                        if (text != null) {
                                          context
                                              .read<
                                                  EkramRequestTransportationBloc>()
                                              .add(ChangeDeceasedUserInfoEvent(
                                                  item: DeceasedInfo(
                                                      secondName: text)));
                                        }
                                      },
                                      onValidate: (String? value) {
                                        return null;
                                      })
                                  : ReadOnlyField(
                                      hieght: 55,
                                      title: "ekram_second_name".tr(),
                                      subTitle: state.requestDetailsModel
                                              ?.deceasedInfo?.secondName ??
                                          "",
                                      subTitleColor:
                                          AppColor.grey1000.withOpacity(0.5),
                                      decoration: BoxDecoration(
                                          color: AppColor.blackModern300Light
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                              const CustomVerticalSpace(height: 16),
                              state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Name, null)== false
                                  ? CustomTextFieldWidget(
                                      label: "ekram_third_name".tr(),
                                      textFieldHeight: 55,
                                      hintText: "ekram_third_name".tr(),
                                      initialValue: state.requestDetailsModel
                                              ?.deceasedInfo?.thirdName ??
                                          "",
                                      onChanged: (String? text) {
                                        if (text != null) {
                                          context
                                              .read<
                                                  EkramRequestTransportationBloc>()
                                              .add(ChangeDeceasedUserInfoEvent(
                                                  item: DeceasedInfo(
                                                      thirdName: text)));
                                        }
                                      },
                                      onValidate: (String? value) {
                                        return null;
                                      })
                                  : ReadOnlyField(
                                      hieght: 55,
                                      title: "ekram_third_name".tr(),
                                      subTitle: state.requestDetailsModel
                                              ?.deceasedInfo?.thirdName ??
                                          "",
                                      subTitleColor:
                                          AppColor.grey1000.withOpacity(0.5),
                                      decoration: BoxDecoration(
                                          color: AppColor.blackModern300Light
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                              const CustomVerticalSpace(height: 16),
                              state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Name, null)== false
                                  ? CustomTextFieldWidget(
                                      isRequired: true,
                                      label: "ekram_fourth_name".tr(),
                                      initialValue: state.requestDetailsModel
                                              ?.deceasedInfo?.fourthName ??
                                          "",
                                      textFieldHeight: 55,
                                      hintText: "ekram_fourth_name".tr(),
                                      onChanged: (String? text) {
                                        if (text != null) {
                                          context
                                              .read<
                                                  EkramRequestTransportationBloc>()
                                              .add(ChangeDeceasedUserInfoEvent(
                                                  item: DeceasedInfo(
                                                      fourthName: text)));
                                        }
                                      },
                                      onValidate: (String? value) {
                                        return null;
                                      })
                                  : ReadOnlyField(
                                      hieght: 55,
                                      title: "ekram_fourth_name".tr(),
                                      subTitle: state.requestDetailsModel
                                              ?.deceasedInfo?.fourthName ??
                                          "",
                                      subTitleColor:
                                          AppColor.grey1000.withOpacity(0.5),
                                      decoration: BoxDecoration(
                                          color: AppColor.blackModern300Light
                                              .withOpacity(0.4),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                              const CustomVerticalSpace(height: 16),
                              CustomLookUpLongDialog(
                                  items: state.nationalities ?? [],
                                  value: state.getNationalityById(
                                      state.requestDetailsModel?.deceasedInfo
                                          ?.nationalityId,
                                      state.requestDetailsModel?.deceasedInfo
                                          ?.nationalityName),
                                  onEmptyList: () async {
                                    return context
                                        .read<EkramRequestTransportationBloc>()
                                        .getNationalitiesHandler(
                                            state.selectedNationalIdType?.id);
                                  },
                                  onChangeType: (LookUpItem? item) {
                                    if (item != null) {
                                      context
                                          .read<
                                              EkramRequestTransportationBloc>()
                                          .add(ChangeDeceasedUserInfoEvent(
                                              item: DeceasedInfo(
                                                  nationalityId: item.id)));
                                    }
                                  },
                                  label: ("nationality").tr(),
                                  hint: ("nationality").tr(),
                                  isDisbaled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Nationality, null)),
                              LabelTextWithOptional(
                                label: 'sex'.tr(),
                                labelColor: AppColor.blackModern700Light,
                                labelSize: 17.0,
                                labelTextAlign: TextAlign.start,
                                showOptional: false,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomRadioButtonEnd<bool>(
                                      title: ("male").tr(),
                                      value: true,
                                      currentSelected: (state
                                              .requestDetailsModel
                                              ?.deceasedInfo
                                              ?.gender ==
                                          "MALE"),
                                      onChange: (bool item) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangeDeceasedUserInfoEvent(
                                                item: DeceasedInfo(
                                                    gender: "MALE")));
                                      },
                                      endRadio: false,
                                      unSelectedBackgroundColor:
                                          Colors.transparent,
                                      textSize: 16,

                                      isDisabled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Gender, null),


        ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CustomRadioButtonEnd<bool>(
                                      title: ("female").tr(),
                                      value: true,
                                      currentSelected: state.requestDetailsModel
                                              ?.deceasedInfo?.gender ==
                                          "FEMALE",
                                      onChange: (bool item) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangeDeceasedUserInfoEvent(
                                                item: DeceasedInfo(
                                                    gender: "FEMALE")));
                                      },
                                      endRadio: false,
                                      unSelectedBackgroundColor:
                                          Colors.transparent,
                                      textSize: 16,
                                      isDisabled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Gender, null),

                                    ),
                                  ),
                                ],
                              ),
                              LabelTextWithOptional(
                                label: 'ekramReligion'.tr(),
                                labelColor: AppColor.blackModern700Light,
                                labelSize: 17.0,
                                labelTextAlign: TextAlign.start,
                                showOptional: false,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomRadioButtonEnd<bool>(
                                      title: ("muslim").tr(),
                                      value: true,
                                      currentSelected: (state
                                                  .requestDetailsModel
                                                  ?.deceasedInfo
                                                  ?.isMuslim ==
                                              null ||
                                          state.requestDetailsModel
                                                  ?.deceasedInfo?.isMuslim ==
                                              true),
                                      onChange: (bool item) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangeDeceasedUserInfoEvent(
                                                item: DeceasedInfo(
                                                    isMuslim: true)));
                                      },
                                      endRadio: false,
                                      unSelectedBackgroundColor:
                                          Colors.transparent,
                                      textSize: 16,
                                      isDisabled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Religon, null),

                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CustomRadioButtonEnd<bool>(
                                      title: ("non_muslim").tr(),
                                      value: true,
                                      currentSelected: (state
                                              .requestDetailsModel
                                              ?.deceasedInfo
                                              ?.isMuslim ==
                                          false),
                                      onChange: (bool item) {
                                        context
                                            .read<
                                                EkramRequestTransportationBloc>()
                                            .add(ChangeDeceasedUserInfoEvent(
                                                item: DeceasedInfo(
                                                    isMuslim: false)));
                                      },
                                      endRadio: false,
                                      unSelectedBackgroundColor:
                                          Colors.transparent,
                                      textSize: 16,
                                      isDisabled: state.isFieldDisabled(state.requestDetailsModel?.deceasedInfo?.deceasedDataSource , EditFiledActionEnum.Religon, null),

                                    ),
                                  ),
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
            EkramPreviousNextButtons(
              btnPressed: () {
                if (state.validateDeceasedInfoSection(true) == true) {
                  context
                      .read<EkramRequestTransportationBloc>()
                      .add(const GoToNextPageEvent());
                }
              },
            )
          ],
        );
      },
    );
  }
}

// class DeceasedInfoTextFieldsSection extends StatefulWidget {
//    DeceasedInfoTextFieldsSection({super.key});
//
//   @override
//   State<DeceasedInfoTextFieldsSection> createState() =>
//       _ApplicantInfoTextFieldsSectionState();
// }
//
// class _ApplicantInfoTextFieldsSectionState
//     extends State<DeceasedInfoTextFieldsSection> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<EkramRequestTransportationBloc,
//         EkramRequestTransportationState>(
//       listener: (context, state) {
//       },
//       builder: (context, state) {
//         return ;
//       },
//     );
//   }
// }
