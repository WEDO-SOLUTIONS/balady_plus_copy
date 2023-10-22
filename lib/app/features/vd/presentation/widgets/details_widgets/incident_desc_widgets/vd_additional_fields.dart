import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';

import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        AddetionalDetailsItem,
        CreateVDBloc,
        CreateVDState,
        ValueItem,
        VdHeaderDesc,
        ChangeSelectedTextValueEvent,
        ChangeSelectedDropDownValueEvent,
        ChangeSelectedMultiSelectValueEvent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';

class VDAdditionalFieldsSection extends StatefulWidget {
  const VDAdditionalFieldsSection({Key? key}) : super(key: key);

  @override
  State<VDAdditionalFieldsSection> createState() =>
      _VDAdditionalFieldsSection();
}

class _VDAdditionalFieldsSection extends State<VDAdditionalFieldsSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateVDBloc, CreateVDState>(
      builder: (context, state) {
        List<AddetionalDetailsItem> quetionList =
            state.splDetailsResponse?.questionList ?? [];
        return quetionList.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomVerticalSpace(height: 14),
                  VdHeaderDesc(
                    header: ("inc_addetional_fields").tr(),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: quetionList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        return getAddetionalWidget(
                            fieldType: quetionList[index].fieldType ?? "",
                            fieldName: quetionList[index].getFieldName(),
                            selectedTextValue:
                                quetionList[index].selectedTextValue,
                            selectedDropDownValue:
                                quetionList[index].selectedDropDownValue,
                            selectedMultiSelectValue:
                                quetionList[index].selectedMultiSelectValue,
                            isMandatory: quetionList[index].isMandatory(),
                            onChangeText: (String? text) {
                              context.read<CreateVDBloc>().add(
                                  ChangeSelectedTextValueEvent(
                                      index: index, text: text));
                            },
                            onChangeDropDown: (ValueItem? item) {
                              context.read<CreateVDBloc>().add(
                                  ChangeSelectedDropDownValueEvent(
                                      index: index, item: item));
                            },
                            onChangeMultiDropDown: (List<ValueItem>? items) {
                              context.read<CreateVDBloc>().add(
                                  ChangeSelectedMultiSelectValueEvent(
                                      index: index, items: items));
                            },
                            fieldLength: quetionList[index].getFieldLength(),
                            valueList: quetionList[index].valuesList,
                            key: quetionList[index].key);
                      })
                ],
              )
            : Container();
      },
    );
  }

  Widget getAddetionalWidget(
      {required String fieldType,
      required String fieldName,
      String? selectedTextValue,
      ValueItem? selectedDropDownValue,
      List<ValueItem>? selectedMultiSelectValue,
      required bool isMandatory,
      required Function(String? text) onChangeText,
      required Function(ValueItem? data) onChangeDropDown,
      required Function(List<ValueItem>? data) onChangeMultiDropDown,
      List<ValueItem>? valueList,
      int? fieldLength,
      Key? key}) {
    switch (fieldType) {
      case GeneralKey.Textbox:
        return TextBoxAddetionalField(
          fieldName: fieldName,
          currentVlaue: selectedTextValue ?? "",
          isMandatory: isMandatory,
          onChanged: (String? text) => onChangeText(text),
          fieldLength: fieldLength,
          isTextArea: false,
          key: key,
        );
      case GeneralKey.DropdownList:
        return DropDownListAddetionalField(
          fieldName: fieldName,
          currentItem: selectedDropDownValue,
          items: valueList ?? [],
          isMandatory: isMandatory,
          onChanged: (ValueItem? item) => onChangeDropDown(item),
          key: key,
        );
      case GeneralKey.TextArea:
        return TextBoxAddetionalField(
          fieldName: fieldName,
          currentVlaue: selectedTextValue ?? "",
          isMandatory: isMandatory,
          onChanged: (String? text) => onChangeText(text),
          fieldLength: fieldLength,
          isTextArea: true,
          key: key,
        );
      case GeneralKey.Radiobutton:
        return RadioButtonAddetionalField(
          fieldName: fieldName,
          currentItem: selectedDropDownValue,
          items: valueList ?? [],
          isMandatory: isMandatory,
          onChanged: (ValueItem? item) => onChangeDropDown(item),
          key: key,
        );
      case GeneralKey.HijriCalendar:
        return HijriCalendarAddetionalField(
          fieldName: fieldName,
          currentVlaue: selectedTextValue,
          isMandatory: isMandatory,
          onChanged: (String? text) => onChangeText(text),
          fieldLength: fieldLength,
          key: key,
        );
      case GeneralKey.GregorianCalendar:
        return GorgianCalendarAddetionalField(
          fieldName: fieldName,
          currentVlaue: selectedTextValue,
          isMandatory: isMandatory,
          onChanged: (String? text) => onChangeText(text),
          fieldLength: fieldLength,
          key: key,
        );
      case GeneralKey.Numbersfield:
        return TextBoxAddetionalField(
          fieldName: fieldName,
          currentVlaue: selectedTextValue ?? "",
          isMandatory: isMandatory,
          onChanged: (String? text) => onChangeText(text),
          fieldLength: fieldLength,
          keyboardType: TextInputType.number,
          inputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          isTextArea: false,
          key: key,
        );
      case GeneralKey.MultiSelectDropdown:
        return MultiSelectionAddetionalField(
          fieldName: fieldName,
          currentItems: selectedMultiSelectValue,
          items: valueList ?? [],
          isMandatory: isMandatory,
          onChanged: (List<ValueItem>? items) => onChangeMultiDropDown(items),
          key: key,
        );
      default:
        return Container();
    }
  }
}
