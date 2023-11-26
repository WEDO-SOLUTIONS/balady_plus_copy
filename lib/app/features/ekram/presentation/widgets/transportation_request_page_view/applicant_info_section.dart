import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';

class ApplicantInfoSection extends StatelessWidget {
  const ApplicantInfoSection({Key? key}) : super(key: key);

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
                        header: Helpers.translatingWord("ApplicantInfo"),
                      ),
                      ApplicantInfoTextFieldsSection()
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

class ApplicantInfoTextFieldsSection extends StatefulWidget {
  const ApplicantInfoTextFieldsSection({Key? key}) : super(key: key);

  @override
  State<ApplicantInfoTextFieldsSection> createState() =>
      _ApplicantInfoTextFieldsSectionState();
}

class _ApplicantInfoTextFieldsSectionState
    extends State<ApplicantInfoTextFieldsSection> {
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
            CustomReadOnlyTextWidget(
              label: trans("ekramFullName"),
              text: state.fullName ?? "",
              /* controller: fullNameTextEditController,
                focusNode: fullNameFocusNode,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (String? value) {}*/
            ),
            CustomVerticalSpace(height: 20),
            CustomReadOnlyTextWidget(
              label: trans("ekramMobile"),
              text: state.mobileNumber ?? "",
              /*controller: mobileTextEditController,
                focusNode: mobileFocusNode,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (String? value) {}*/
            ),
            CustomVerticalSpace(height: 20),
            CustomReadOnlyTextWidget(
              label: trans("ekramApplicantType"),
              text: state.requestType ?? "",

              /*controller: applicantTypeTextEditController,
                focusNode: applicantTypeFocusNode,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (String? value) {}*/
            ),
            CustomVerticalSpace(height: 20),
            CustomTextFieldWidgetWithValue(
                label: trans("ekramRelationShipOptional"),
                hintText: trans("ekramRelationShipOptional"),
                // controller: relationShipTextEditController,
                //  focusNode: relationShipFocusNode,
                initialValue: state.relation,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onChanged: (String? text) {
                  context
                      .read<EkramRequestTransportationBloc>()
                      .add(ChangeRelationShipEvent(text: text));
                },
                validator: (String? value) {}),
          ],
        );
      },
    );
  }
}
