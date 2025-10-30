import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';

class VdFieldsSection extends StatefulWidget {
  final String? initialDesc;

  VdFieldsSection({
    this.initialDesc,
  });

  @override
  State<VdFieldsSection> createState() => _VdFieldsSection();
}

class _VdFieldsSection extends State<VdFieldsSection> {
  final FocusNode _incidentDescFocusNode = FocusNode();
  final TextEditingController _incidentDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _incidentDescController.text = widget.initialDesc ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDCBloc, CreateDCState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            //  incident Desc ,
            CustomTextFieldWidget(
              controller: _incidentDescController,
              focusNode: _incidentDescFocusNode,
              label: ("lbl_description_for_the_report_hint1").tr(),
              hintText: ("lbl_description_for_the_report_hint2").tr(),
              obsecureText: false,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              errorText: state.incidentDescErrorText,
              onValidate: (String? text) {},
              /*validator: (text) {
                if (!Helpers.doesContainsLettrs(text.toString())) {
                  return Helpers.translatingWord("incident_desc_limit_error");
                }
                return null;
              },*/
              onChanged: (text) {
                context
                    .read<CreateDCBloc>()
                    .add(ChangeIssueDescEvent(text: text));
              },
            ),

            const CustomVerticalSpace(height: 14),
          ],
        );
      },
    );
  }
}
