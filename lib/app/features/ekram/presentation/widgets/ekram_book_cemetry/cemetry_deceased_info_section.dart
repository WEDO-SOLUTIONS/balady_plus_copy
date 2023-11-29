import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_check_box_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'cemetry_burial_date_gorgian.dart';
import 'cemetry_burial_date_hijri.dart';
import 'cemetry_is_epidamic_widget.dart';
import 'cemetry_national_id_date_gorgian.dart';
import 'cemetry_national_id_date_hijri.dart';
import 'cemetry_previous_next_buttons.dart';
import 'dead_fetus.dart';
import 'dead_gender.dart';
import 'dead_religion.dart';

import 'deceased_info_widget.dart';

class CemetryDeceasedInfoSection extends StatefulWidget {
  const CemetryDeceasedInfoSection({Key? key}) : super(key: key);

  @override
  State<CemetryDeceasedInfoSection> createState() =>
      _CemetryDeceasedInfoSectionState();
}

class _CemetryDeceasedInfoSectionState
    extends State<CemetryDeceasedInfoSection> {
  final deathLocationTextEditController = TextEditingController();
  final deathLocationShipFocusNode = FocusNode();

  // final otherHospitalTextEditController = TextEditingController();
  //final otherHospitalShipFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //  deathLocationTextEditController.dispose();
    //  deathLocationShipFocusNode.dispose();

    // otherHospitalTextEditController.dispose();
    // otherHospitalShipFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
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
                      DeadFetusWidget(),
                      CustomLookUpLongDialog(
                        items: state.nationalTypes ?? [],
                        value: state.selectedNationalType,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getNationalTypesHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeNationalType(item: item));
                          }
                        },
                        label: Helpers.translatingWord("cemetry_national_type"),
                        hint: Helpers.translatingWord("cemetry_national_type"),
                      ),
                      // if (state.showReligion())

                      /*CustomLookUpLongDialog( 
                        items: state.religions ?? [],
                        value: state.selectedReligion,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getReligionsHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeReligionEvent(item: item));
                          }
                        },
                        label: Helpers.translatingWord("ekramReligion"),
                        hint: Helpers.translatingWord("ekramReligion"),
                      ),*/
                      CustomTextFieldWidget(
                          label: Helpers.translatingWord("cemetry_national_id"),
                          hintText:
                              Helpers.translatingWord("cemetry_national_id"),
                          initialValue: state.deceassedId,
                          // controller: otherHospitalTextEditController,
                          //  focusNode: otherHospitalShipFocusNode,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onChanged: (String? text) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeNationalId(text: text));
                          },
                          onValidate: (String? value) {}),
                      CustomVerticalSpace(
                        height: 16,
                      ),
                      CemetryNationalDobHijri(),
                      CemetryNationalDobGorgian(),

                      ElevatedButtonWidget.verify(
                          text: (state.userInfoResponse != null)
                              ? "done_check".tr()
                              : "verify".tr(),
                          onPressed: () {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(CheckUserInfoEvent());
                          }),

                      if (state.userInfoResponse != null)
                        DeceassedInfoWidget(
                          gender: state.userInfoResponse?.genderDescription,
                          name: state.userInfoResponse?.fullName,
                          religion: state.userInfoResponse?.religionDescription,
                          nationality:
                              state.userInfoResponse?.nationalityDescription,
                        ),

                      CustomVerticalSpace(height: 16),
                      DeadReligionWidget(),
                      CustomVerticalSpace(height: 16),

                      DeadGenderWidget(),

                      CustomLookUpLongDialog(
                        items: state.cities ?? [],
                        value: state.selectedCity,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getCitiesHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeBurialCityEvent(item: item));
                          }
                        },
                        label: Helpers.translatingWord(
                            "cemetry_deceassed_burial_city"),
                        hint: Helpers.translatingWord(
                            "cemetry_deceassed_burial_city"),
                      ),

                      CemetryBurialDateHijri(),
                      CemetryBurialDateGorgian(),

                      CustomHeaderAndDescOnTapWidget(
                          label: Helpers.translatingWord(
                              "cemetry_deceassed_burial_time"),
                          hintText: state.otherTimeName == null
                              ? Helpers.translatingWord(
                                  "cemetry_deceassed_burial_time")
                              : state.otherTimeName ?? "",
                          onTap: () {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeBurialTimeOtherNameEvent());
                          }),
                      CemetryIsEpidamicWidget(),

                      CustomLookUpLongDialog(
                        items: state.cemetryTypeItems ?? [],
                        value: state.selectedCemetryType,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .getCemetryTypeItemsHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeCemetryTypeEvent(item: item));
                          }
                        },
                        label: ("cemetry_type").tr(),
                        hint: ("cemetry_type").tr(),
                      ),
                      CustomLookUpLongDialog(
                        items: state.cemetries ?? [],
                        value: state.selectedCemetry,
                        onEmptyList: () async {
                          return context
                              .read<EkramBookCemetryBloc>()
                              .add(GetCemetriesEvent());
                        },
                        onChangeType: (LookUpItem? item) {
                          if (item != null) {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(ChangeCemetryEvent(item: item));
                          }
                        },
                        label: Helpers.translatingWord("cemetry_name"),
                        hint: Helpers.translatingWord("cemetry_name"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons(
              isBtnDisabled: state.isNextButtonEnabled(),
              onPressed: () {
                context.read<EkramBookCemetryBloc>().add(GoToNextPageEvent());
              },
            )
          ],
        );
      },
    );
  }
}
