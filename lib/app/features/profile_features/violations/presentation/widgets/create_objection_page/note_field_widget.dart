import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/shared_feature_exports.dart';

class NotesFieldsSection extends StatefulWidget {
  final String? initialDesc;
  final Function onChanged;

  NotesFieldsSection({this.initialDesc, required this.onChanged});

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
    return Column(
      children: <Widget>[
        //  incident Desc ,
        CustomTextFieldWidget(
          controller: _incidentDescController,
          focusNode: _incidentDescFocusNode,
          label: ("objection_create_reason").tr(),
          hintText: ("objection_create_reason").tr(),
          obsecureText: false,
          maxLines: 6,
          keyboardType: TextInputType.multiline,
          // errorText: state.incidentDescErrorText,
          onValidate: (String? text) {},
          /*validator: (text) {
                if (!Helpers.doesContainsLettrs(text.toString())) {
                  return Helpers.translatingWord("incident_desc_limit_error");
                }
                return null;
              },*/
          onChanged: (text) {
            widget.onChanged(text);
          },
        ),

        const CustomVerticalSpace(height: 14),
      ],
    );
  }
}
