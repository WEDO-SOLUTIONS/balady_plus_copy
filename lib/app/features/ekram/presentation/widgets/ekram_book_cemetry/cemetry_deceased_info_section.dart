import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'cemetry_national_id_date_gorgian.dart';
import 'cemetry_national_id_date_hijri.dart';
import 'cemetry_previous_next_buttons.dart';
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
                      if (state.showReligion())
                        CustomLookUpLongDialog(
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
                        ),
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

                      CemetryNationalDobHijri(),
                      CemetryNationalDobGorgian(),
                      CustomTextButtonWidget(
                          btnTextColor: AppColor.baladyDarkGreen2,
                          btnTextSize: 14,
                          onPressed: () {
                            context
                                .read<EkramBookCemetryBloc>()
                                .add(CheckUserInfoEvent());
                          },
                          text: Helpers.translatingWord("cemetry_retreive")),

                      if (state.userInfoResponse != null)
                        DeceassedInfoWidget(
                          gender: state.userInfoResponse?.genderDescription,
                          name: state.userInfoResponse?.fullName,
                          religion: state.userInfoResponse?.religionDescription,
                          nationality:
                              state.userInfoResponse?.nationalityDescription,
                        ),

                      /*   CustomLookUpLongDialog(
                        items: state.hospitals ?? [],
                        value: state.selectedHospital,
                        onChangeType: (LookUpItem? item) {
                          context
                              .read<EkramRequestTransportationBloc>()
                              .add(SelectHospitalEvent(item: item));
                        },
                        label: Helpers.translatingWord("ekramHospital"),
                        hint: Helpers.translatingWord("ekramHospital"),
                      ),
                      if (state.selectedHospital?.id == -1)
                        CustomTextFieldWidgetWithValue(
                            label: Helpers.translatingWord("hospital_name"),
                            hintText: Helpers.translatingWord("hospital_name"),
                            initialValue: state.otherHospitalName,
                            // controller: otherHospitalTextEditController,
                            //  focusNode: otherHospitalShipFocusNode,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            onChanged: (String? text) {
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(
                                      ChangeHospitalOtherNameEvent(text: text));
                            },
                            validator: (String? value) {}),
                      CustomTextFieldWidgetWithValue(
                          label: Helpers.translatingWord("deathLocation"),
                          hintText: Helpers.translatingWord("deathLocation"),
                          //  controller: deathLocationTextEditController,
                          //  focusNode: deathLocationShipFocusNode,
                          initialValue: state.deathLocation,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onChanged: (String? text) {
                            context
                                .read<EkramRequestTransportationBloc>()
                                .add(ChangeDeathLocationEvent(text: text));
                          },
                          validator: (String? value) {}),*/
                      // AttachemntWidget()
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons()
          ],
        );
      },
    );
  }
}
