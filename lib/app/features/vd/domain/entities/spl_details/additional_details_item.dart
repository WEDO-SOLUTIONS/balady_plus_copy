import 'package:balady_plus/app/features/vd/vd_exports.dart' show ValueItem;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/keys/general_keys.dart';

class AddetionalDetailsItem extends Equatable {
  AddetionalDetailsItem(
      {this.valuesList,
      this.fieldLength,
      this.fieldName,
      this.fieldType,
      this.mandatory,
      this.key});

  List<ValueItem>? valuesList;
  String? fieldLength;
  String? fieldName;
  String? fieldType;
  String? mandatory;
  String? selectedTextValue;
  ValueItem? selectedDropDownValue;
  List<ValueItem>? selectedMultiSelectValue;
  UniqueKey? key;

  bool isMandatory() {
    return mandatory == "Yes";
  }

  String getFieldName() {
    return fieldName ?? "";
  }

  int? getFieldLength() {
    if (fieldLength != null) return int.tryParse(fieldLength!);
    return null;
  }

  Map<String, dynamic>? requestJson() {
    String selectedFieldValueTitle = getSelectedFieldValueTitle(fieldType);
    dynamic selectedFieldValue = getSelectedFieldValue(fieldType);

    return (selectedFieldValueTitle.isNotEmpty && (selectedFieldValue != null))
        ? {
            "FieldLength": fieldLength,
            "FieldName": fieldName,
            "FieldType": fieldType,
            if (selectedFieldValueTitle.isNotEmpty &&
                (selectedFieldValue != null))
              selectedFieldValueTitle: selectedFieldValue
          }
        : null;
  }

  String getSelectedFieldValueTitle(String? fieldType) {
    switch (fieldType) {
      case GeneralKey.Textbox:
        return "Textinput1";
      case GeneralKey.DropdownList:
        return "Textinput2";
      case GeneralKey.TextArea:
        return "Textinput3";
      case GeneralKey.Radiobutton:
        return "Textinput4";
      case GeneralKey.HijriCalendar:
        return "Textinput6";
      case GeneralKey.GregorianCalendar:
        return "Textinput5";
      case GeneralKey.Numbersfield:
        return "Integerinput1";
      case GeneralKey.MultiSelectDropdown:
        return "MultiselectList";
      default:
        return "";
    }
  }

  dynamic getSelectedFieldValue(String? fieldType) {
    switch (fieldType) {
      case GeneralKey.Textbox:
        return selectedTextValue;
      case GeneralKey.DropdownList:
        return selectedDropDownValue?.addlFeildValue;
      case GeneralKey.TextArea:
        return selectedTextValue;

      case GeneralKey.Radiobutton:
        return selectedDropDownValue?.addlFeildValue;

      case GeneralKey.HijriCalendar:
        return selectedTextValue;

      case GeneralKey.GregorianCalendar:
        return selectedTextValue;

      case GeneralKey.Numbersfield:
        return selectedTextValue;
      case GeneralKey.MultiSelectDropdown:
        return selectedMultiSelectValue
            ?.map((e) => {"AddlFeildValue": e.addlFeildValue})
            .toList();
      default:
        return "";
    }
  }

  @override
  List<Object?> get props => [
        fieldName,
        fieldType,
        valuesList,
        selectedTextValue,
        selectedDropDownValue,
        selectedMultiSelectValue,
        key
      ];
}
