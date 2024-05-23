import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';

class NotesFieldsSection extends StatefulWidget {
  final String? initialDesc;
  final Function onChanged;
  final int index;
  final Function onDelete;
  final bool? hideDelete; 
  final Key? key;

  NotesFieldsSection(
      {this.initialDesc,
      required this.onChanged,
      required this.index, this.hideDelete = false, 
      required this.onDelete, this.key});

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

      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //  incident Desc ,

        Stack(
          children: [
            CustomTextFieldWidget(
              controller: _incidentDescController,
              focusNode: _incidentDescFocusNode,
              label: ("objection_create_reason").tr(),
              hintText: ("objection_create_reason").tr(),
              obsecureText: false,
              fillColor: Colors.transparent,
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
            if (widget.hideDelete != true)
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: IconButton(
                padding: EdgeInsets.only(bottom: 32),
                icon: Icon(
                  Icons.delete,
                  color: AppColor.redBrown,
                ),
                onPressed: () {
                  widget.onDelete();
                },
              ),
            ),
          ],
        ),

        const CustomVerticalSpace(height: 14),
      ],
    );
  }
}
