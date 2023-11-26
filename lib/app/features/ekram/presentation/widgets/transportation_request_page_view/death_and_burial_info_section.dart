import 'package:balady_new_app/app/core/core_exports.dart';

import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:balady_new_app/shared/core/utils/common_functions.dart';
import 'package:balady_new_app/shared/features/_shared_feature_/shared/data/entities/file_data_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class DeathAndBurialInfoSection extends StatefulWidget {
  const DeathAndBurialInfoSection({Key? key}) : super(key: key);

  @override
  State<DeathAndBurialInfoSection> createState() =>
      _DeathAndBurialInfoSectionState();
}

class _DeathAndBurialInfoSectionState extends State<DeathAndBurialInfoSection> {
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
                        header: Helpers.translatingWord("deathInfo"),
                      ),
                      CustomLookUpLongDialog(
                        items: state.cities ?? [],
                        value: state.selectedCity,
                        onEmptyList: () async {
                          return context
                              .read<EkramRequestTransportationBloc>()
                              .getCitiesHandler();
                        },
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                          if (item != null) {
                            context
                                .read<EkramRequestTransportationBloc>()
                                .add(GetHospitalsEvent(city: item));
                          }
                        },
                        label: Helpers.translatingWord("burialCity"),
                        hint: Helpers.translatingWord("burialCity"),
                      ),
                      CustomReadOnlyTextWidget(
                          label: trans("transportation_status"),
                          text: trans("transportation_from_hospital")),

                      /*CustomLookUpLongDialog(
                        items: [],
                        value: LookUpItem(),
                        onChangeType: (LookUpItem? item) {
                          print(item?.name);
                        },
                        label: Helpers.translatingWord(
                            "deceasedTransportationStatus"),
                        hint: Helpers.translatingWord(
                            "deceasedTransportationStatus"),
                      ),*/
                      CustomLookUpLongDialog(
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
                          validator: (String? value) {}),
                      // AttachemntWidget()
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

class AttachemntWidget extends StatelessWidget {
  AttachemntWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextWidget(
              Helpers.translatingWord('policeLetterAttached_optinal'),
              fontSize: 16,
              fontWeight: FONT_WEIGHT.medium,
              fontColor: AppColors.baladyDarkGreen2,
            ),
            CustomVerticalSpace(height: 16),
            state.letter != null
                ? Row(
                    children: [
                      CustomSvgIconWidget(
                        "assets/icons/customer_pdf.svg",
                        iconHeight: 20,
                        iconWidth: 20,
                        iconColor: AppColors.black,
                      ),
                      CustomHorizontalSpace(width: 8),
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            FileDataItem? file =
                                await CommonFunctions.pickFile();
                            if (file != null)
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(AddFileEvent(file));
                          },
                          child: CustomTextWidget(
                            state.letter?.fileName ?? "",
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            fontWeight: FONT_WEIGHT.medium,
                            fontColor: AppColors.black,
                            maxLines: 1,
                          ),
                        ),
                      )
                    ],
                  )
                : CustomElevatedButtonWidget(
                    btnPressed: () async {
                      FileDataItem? file = await CommonFunctions.pickFile();
                      if (file != null)
                        context
                            .read<EkramRequestTransportationBloc>()
                            .add(AddFileEvent(file));
                    },
                    btnText: Helpers.translatingWord("attach_file"),
                    icon: Image.asset(
                      Constants.imgPath + "addButton@3x.png",
                      height: 12,
                      width: 12,
                    ),
                    btnTextSize: 16,
                    btnTextWeight: FONT_WEIGHT.medium,
                    btnHeight: 56,
                    btnTextColor: AppColors.darkTurquoise,
                    btnBorderColor: AppColors.darkTurquoise,
                    btnColor: Colors.transparent,
                  ),
          ],
        );
      },
    );
  }
}
