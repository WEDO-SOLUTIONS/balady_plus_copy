import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
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
                        header: Helpers.translatingWord("ekram_main_data"),
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
  ApplicantInfoTextFieldsSection({Key? key}) : super(key: key);

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
            ReadOnlyField(
              title: trans("submitterName"),
              subTitle: state.fullName ?? "",
            ),
            const CustomVerticalSpace(height: 20),
            ReadOnlyField(
              title: trans("driver_card_applicant_mobile"),
              subTitle: state.mobileNumber ?? "",
            ),
            const CustomVerticalSpace(height: 20),
            CustomTextFieldWidget(
                label: trans("ekramRelationShipOptional"),
                hintText: trans("ekramRelationShipOptional"),
                initialValue: state.relation,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onChanged: (String? text) {
                  context
                      .read<EkramRequestTransportationBloc>()
                      .add(ChangeRelationShipEvent(text: text));
                },
                onValidate: (String? value) {}),
            const CustomVerticalSpace(height: 20),
            CustomLookUpLongDialog(
              items: state.cities ?? [],
              value: state.selectedCity,
              onEmptyList: () async {
                return context
                    .read<EkramRequestTransportationBloc>()
                    .getCitiesHandler();
              },
              onChangeType: (LookUpItem? item) {
                if (item != null) {
                  context
                      .read<EkramRequestTransportationBloc>()
                      .add(GetHospitalsEvent(city: item));
                }
              },
              label: Helpers.translatingWord("burialCity"),
              hint: Helpers.translatingWord("burialCity"),
            ),
            ReadOnlyField(
                title: trans("deceasedTransportationStatus"),
                subTitle: trans("transportation_from_hospital")),
            CustomLookUpLongDialog(
              items: state.hospitals ?? [],
              value: state.selectedHospital,
              onChangeType: (LookUpItem? item) {
                context
                    .read<EkramRequestTransportationBloc>()
                    .add(SelectHospitalEvent(item: item));
              },
              onEmptyList: () {
                context
                    .read<EkramRequestTransportationBloc>()
                    .add(GetHospitalsEvent(city: state.selectedCity!));
              },
              label: Helpers.translatingWord("ekramHospital"),
              hint: Helpers.translatingWord("ekramHospital"),
            ),
            if (state.selectedHospital?.id == -1)
              CustomTextFieldWidget(
                  label: Helpers.translatingWord("hospital_name"),
                  hintText: Helpers.translatingWord("hospital_name"),
                  initialValue: state.otherHospitalName,
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  onChanged: (String? text) {
                    context
                        .read<EkramRequestTransportationBloc>()
                        .add(ChangeHospitalOtherNameEvent(text: text));
                  },
                  onValidate: (String? value) {}),
          ],
        );
      },
    );
  }
}
