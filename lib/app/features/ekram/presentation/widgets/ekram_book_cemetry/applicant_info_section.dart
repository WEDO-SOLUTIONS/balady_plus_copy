import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';
import 'cemetry_previous_next_buttons.dart';

class ApplicantInfoSection extends StatelessWidget {
  const ApplicantInfoSection({Key? key}) : super(key: key);

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
                        header: Helpers.translatingWord("ApplicantInfo"),
                      ),
                      ApplicantInfoTextFieldsSection()
                    ],
                  ),
                ),
              ),
            ),
            CemetryreviousNextButtons(
              isBtnDisabled: !state.isNextButtonEnabled(),
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
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadOnlyField(
              title: trans("ekramFullName"),
              subTitle: state.fullName ?? "",
            ),
            CustomVerticalSpace(height: 20),
            ReadOnlyField(
              title: trans("ekramMobile"),
              subTitle: state.mobileNumber ?? "",
              /*controller: mobileTextEditController,
                focusNode: mobileFocusNode,
                maxLines: 1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                validator: (String? value) {}*/
            ),
            CustomVerticalSpace(height: 20),
            CustomTextFieldWidget(
                label: trans("ekramRelationShip"),
                hintText: trans("ekramRelationShip"),
                // controller: relationShipTextEditController,
                //  focusNode: relationShipFocusNode,
                initialValue: state.relation,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onChanged: (String? text) {
                  context
                      .read<EkramBookCemetryBloc>()
                      .add(ChangeRelationShipEvent(text: text));
                },
                onValidate: (String? value) {}),
          ],
        );
      },
    );
  }
}
