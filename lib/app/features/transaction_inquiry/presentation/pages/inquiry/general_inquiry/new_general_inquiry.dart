import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../core/view_models/inquiry/new_inquiry_view_model.dart';
import 'previous_next_buttons.dart';

class NewGeneralInquiryScreen extends StatefulWidget {
  NewGeneralInquiryScreen({Key? key}) : super(key: key);

  @override
  _NewGeneralInquiryScreen createState() => _NewGeneralInquiryScreen();
}

class _NewGeneralInquiryScreen extends State<NewGeneralInquiryScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 85, right: 30, left: 30, top: 32),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OrderInfoSection(),
                  ]),
            ),
          ),
        ),
        PreviousNextButtons()
      ],
    );
  }
}

class OrderInfoSection extends StatefulWidget {
  OrderInfoSection({Key? key}) : super(key: key);

  @override
  State<OrderInfoSection> createState() => _OrderInfoSectionState();
}

class _OrderInfoSectionState extends State<OrderInfoSection> {
  final FocusNode _specialtyDescFocusNode = FocusNode();

  final FocusNode _descFocusNode = FocusNode();

  final TextEditingController _specialtyDescController =
      TextEditingController();

  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    NewInquiryViewModel model =
        Provider.of<NewInquiryViewModel>(context, listen: true);

    return Column(
      children: <Widget>[
        CustomTapWidgetForLongDialog(
          onChangeType: (DropDownItem? item) {
            if (item != null) {
              model.municipalityType = item;
              setState(() {});
            }
            model.validateForm();
          },
          items: model.municipalities,
          value: model.municipalityType,
          label: ("inquiry_municipality").tr(),
          hint: ("inquiry_municipality").tr(),
        ),
        CustomTapWidgetForLongDialog(
          onChangeType: (DropDownItem? item) {
            if (item != null) {
              model.getMainAndSubClassifications(item);
              // model.validateForm();
            }
          },
          items: model.splClassificationList,
          value: model.splClassificationType,
          label: ("lbl_specialty_classification_hint1").tr(),
          hint: ("lbl_specialty_classification_hint2").tr(),
        ),

        // spl description
        if (model.showSPLDescription())
          CustomTextFieldWidget(
            controller: _specialtyDescController,
            focusNode: _specialtyDescFocusNode,
            label: ("spl_description").tr(),
            hintText: ("spl_description_hint").tr(),
            obsecureText: false,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(_descFocusNode);
            },
            onValidate: (text) {
              if (text.toString().isEmpty) {
                return ('text_field_error').tr();
              }
              return null;
            },
            onChanged: (text) {
              model.splDescription = text;
              model.validateForm();
            },
          ),

        //  incident Desc ,
        CustomTextFieldWidget(
          controller: _descController,
          focusNode: _descFocusNode,
          label: ("description").tr(),
          hintText: ("lbl_inq_desc_hint").tr(),
          obsecureText: false,
          fillColor: Colors.transparent,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          onValidate: (text) {
            if (!CommonFunctions.doesContainsLettrs(text.toString())) {
              return ("description_limit").tr();
            }
            return null;
          },
          onChanged: (text) {
            model.description = text;
            model.validateForm();
          },
        ),
      ],
    );
  }
}
