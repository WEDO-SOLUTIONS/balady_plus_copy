import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
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
                        header: Helpers.translatingWord("ekram_step4_title"),
                      ),
                      CustomTextFieldWidget(
                          label: Helpers.translatingWord("deathLocation"),
                          hintText: Helpers.translatingWord("deathLocation"),
                          //  controller: deathLocationTextEditController,
                          //  focusNode: deathLocationShipFocusNode,
                          initialValue: state.deathLocation,
                          showOptional: true,
                          maxLines: 1,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          onChanged: (String? text) {
                            context
                                .read<EkramRequestTransportationBloc>()
                                .add(ChangeDeathLocationEvent(text: text));
                          },
                          onValidate: (String? value) {}),
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
              fontWeight: AppFontWeight.medium,
              fontColor: AppColor.primary900Light,
            ),
            CustomVerticalSpace(height: 16),
            state.letter != null
                ? Row(
                    children: [
                      CustomSvgIconWidget(
                        "assets/icons/customer_pdf.svg",
                        iconHeight: 20,
                        iconWidth: 20,
                        iconColor: AppColor.black,
                      ),
                      CustomHorizontalSpace(width: 8),
                      Flexible(
                        child: GestureDetector(
                          onTap: () async {
                            FileDataItem? file =
                                await CommonFunctions.pickFile(context);
                            if (file != null)
                              context
                                  .read<EkramRequestTransportationBloc>()
                                  .add(AddFileEvent(file));
                          },
                          child: CustomTextWidget(
                            state.letter?.fileName ?? "",
                            fontSize: 16,
                            textAlign: TextAlign.start,
                            fontWeight: AppFontWeight.medium,
                            fontColor: AppColor.black,
                            maxLines: 1,
                          ),
                        ),
                      )
                    ],
                  )
                : EnhancedCustomElevatedButtonWidget(
                    btnPressed: () async {
                      FileDataItem? file =
                          await CommonFunctions.pickFile(context);
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
                    btnTextWeight: AppFontWeight.medium,
                    btnHeight: 56,
                    btnTextColor: AppColor.primary900Light,
                    btnBorderColor: AppColor.primary900Light,
                    btnColor: Colors.transparent,
                  ),
          ],
        );
      },
    );
  }
}
