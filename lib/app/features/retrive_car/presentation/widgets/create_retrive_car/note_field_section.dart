import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../blocs/create_retrive_bloc/create_retrive_bloc.dart';

class NotesFieldsSection extends StatefulWidget {
  final String? initialDesc;

  NotesFieldsSection({
    this.initialDesc,
  });

  @override
  State<NotesFieldsSection> createState() => _NotesFieldsSection();
}

class _NotesFieldsSection extends State<NotesFieldsSection> {
  final FocusNode _incidentDescFocusNode = FocusNode();
  final TextEditingController _incidentDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _incidentDescController.text = widget.initialDesc ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRetriveCarBloc, CreateRetriveCarState>(
      builder: (context, state) {
        return Column(
          children: <Widget>[
            //  incident Desc ,
            CustomTextFieldWidget(
              controller: _incidentDescController,
              focusNode: _incidentDescFocusNode,
              label: ("dc_notes").tr(),
              hintText: ("dc_notes").tr(),
              obsecureText: false,
              maxLines: 6,
              fillColor: Colors.transparent,
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
                    .read<CreateRetriveCarBloc>()
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
