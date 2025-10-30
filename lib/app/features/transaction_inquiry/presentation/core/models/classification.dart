import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/data/entities/drop_down_item.dart';
import 'error_result.dart';

class SpecializedClassification {
  List<SpecializedClassificationItem>? splClassificationList;
  List<ErrorResult>? errors;

  SpecializedClassification({
    this.splClassificationList,
    this.errors,
  });

  factory SpecializedClassification.fromMap(Map<String, dynamic> map) =>
      SpecializedClassification(
          splClassificationList: map["SplClassificationList"] != null
              ? List<SpecializedClassificationItem>.from(
                  map["SplClassificationList"]
                      .map((x) => SpecializedClassificationItem.fromMap(x)))
              : null,
          errors: map["errors"] != null
              ? List<ErrorResult>.from(
                  map["errors"].map((x) => ErrorResult.fromJson(x)))
              : []);

  List<DropDownItem> getDropDownItems() {
    List<DropDownItem> items = [];

    splClassificationList?.forEach((element) {
      if (element != null) {
        items.add(DropDownItem(id: element.id, name: element.name ?? ""));
      }
    });
    return items;
  }

  SpecializedClassificationItem? getItem(String id) {
    return splClassificationList
        ?.firstWhereOrNull((element) => element.id == id);
  }
}

class SpecializedClassificationItem {
  String? id;
  String? name;
  String? priority;
  String? respTime;

  SpecializedClassificationItem(
      {this.id, this.name, this.priority, this.respTime});

  factory SpecializedClassificationItem.fromMap(Map<String, dynamic> map) =>
      SpecializedClassificationItem(
          id: map["ID"],
          name: map["Name"],
          priority: map["Priority"],
          respTime: map["RespTime"]);

  Map<String, dynamic> toMap() =>
      {"ID": id, "Name": name, "Priority": priority, "RespTime": respTime};
}

class SubMainClassification {
  String? SubClassificationID;
  String? SubClassificationName;
  String? MainClassificationName;
  String? MainClassificationID;
  bool? ParksFlag;
  String? Specialclassflag;
  String? helpingMaterialExists;
  String? pyGUID;

  List<ErrorResult>? errors;
  List<SplBusinessType>? splBusinessType;
  String? attachmentRequired;
  List<ClassificationAttachmentList>? attachmentList;
  List<QuestionList>? questionList;

  SubMainClassification(
      {this.SubClassificationID,
      this.SubClassificationName,
      this.MainClassificationName,
      this.MainClassificationID,
      this.ParksFlag,
      this.Specialclassflag,
      this.splBusinessType,
      this.errors,
      this.attachmentRequired,
      this.attachmentList,
      this.questionList,
      this.helpingMaterialExists,
      this.pyGUID});

  SubMainClassification.fromMap(Map<String, dynamic> map) {
    SubClassificationID = map["SubClassificationID"];
    SubClassificationName = map["SubClassificationName"];
    MainClassificationName = map["MainClassificationName"];
    MainClassificationID = map["MainClassificationID"];
    ParksFlag = map["ParksFlag"];
    Specialclassflag = map["Specialclassflag"];
    pyGUID = map["pyGUID"];
    helpingMaterialExists = map["HelpingMaterialExists"];
    splBusinessType = map["SplBusinessTypeList"] != null
        ? List<SplBusinessType>.from(
            map["SplBusinessTypeList"].map((x) => SplBusinessType.fromMap(x)))
        : [];

    errors = map["errors"] != null
        ? List<ErrorResult>.from(
            map["errors"].map((x) => ErrorResult.fromJson(x)))
        : [];

    attachmentRequired = map["AttachmentRequired"];
    attachmentList = map["AttachmentList"] != null
        ? List<ClassificationAttachmentList>.from(map["AttachmentList"]
            .map((x) => ClassificationAttachmentList.fromMap(x)))
        : [];
    /* questionList = map["QuestionList"] != null
        ? List<QuestionList>.from(
            map["QuestionList"].map((x) => QuestionList.fromJson(x)))
        : [];*/
    questionList = [];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['SubClassificationID'] = SubClassificationID;
    map['SubClassificationName'] = SubClassificationName;
    map['MainClassificationName'] = MainClassificationName;
    map['MainClassificationID'] = MainClassificationID;
    map["ParksFlag"] = ParksFlag;
    map['errors'] = List<ErrorResult>.from(errors!.map((x) => x));
    map['QuestionList'] = map['QuestionList'] != null
        ? List<dynamic>.from(questionList!.map((x) => x.toJson()))
        : null;

    return map;
  }

  bool showHelpingMaterial() {
    return helpingMaterialExists == "true";
  }
}

class ClassificationAttachmentList {
  String? ID;
  bool? pyRequired;
  String? name;

  ClassificationAttachmentList({this.ID, this.name, this.pyRequired});

  factory ClassificationAttachmentList.fromMap(Map<String, dynamic> map) =>
      ClassificationAttachmentList(
          ID: map["ID"], pyRequired: map["pyRequired"], name: map["Name"]);
}

class SplBusinessType {
  String? ID;
  String? SCBusinessType;

  SplBusinessType({this.ID, this.SCBusinessType});

  factory SplBusinessType.fromMap(Map<String, dynamic> map) => SplBusinessType(
        ID: map["ID"],
        SCBusinessType: map["SCBusinessType"],
      );
}

class ParkClassification {
  List<ParkClassificationItem>? splClassificationList;
  List<ErrorResult>? errors;

  ParkClassification({
    this.splClassificationList,
    this.errors,
  });

  factory ParkClassification.fromMap(Map<String, dynamic> map) =>
      ParkClassification(
          splClassificationList: map["ParksList"] != null
              ? List<ParkClassificationItem>.from(map["ParksList"]
                  .map((x) => ParkClassificationItem.fromMap(x)))
              : null,
          errors: map["errors"] != null
              ? List<ErrorResult>.from(
                  map["errors"].map((x) => ErrorResult.fromJson(x)))
              : []);
}

class ParkClassificationItem {
  String? id;
  String? name;

  ParkClassificationItem({
    this.id,
    this.name,
  });

  factory ParkClassificationItem.fromMap(Map<String, dynamic> map) =>
      ParkClassificationItem(
        id: map["ID"],
        name: map["Name"],
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "Name": name,
      };
}

class QuestionList {
  QuestionList(
      {this.valueList,
      this.fieldLength,
      this.fieldName,
      this.fieldType,
      this.mandatory,
      this.key});

  List<ValueList>? valueList;
  String? fieldLength;
  String? fieldName;
  String? fieldType;
  String? mandatory;
  String? selectedTextValue;
  ValueList? selectedDropDownValue;
  List<ValueList>? selectedMultiSelectValue;
  UniqueKey? key;

  factory QuestionList.fromJson(Map<String, dynamic> json) {
    QuestionList list = QuestionList(
        valueList: json["ValueList"] != null
            ? List<ValueList>.from(
                json["ValueList"].map((x) => ValueList.fromJson(x)))
            : null,
        fieldLength: json["FieldLength"],
        fieldName: json["FieldName"],
        fieldType: json["FieldType"],
        mandatory: json["Mandatory"],
        key: UniqueKey());

    /*list.valueList = list.valueList?.mapIndexed((index, e) {
      e.id = index.toString();
      return e;
    }).toList();*/

    return list;
  }

  Map<String, dynamic> toJson() => {
        "ValueList": valueList != null
            ? List<dynamic>.from(valueList!.map((x) => x.toJson()))
            : null,
        "FieldLength": fieldLength,
        "FieldName": fieldName,
        "FieldType": fieldType,
        "Mandatory": mandatory,
      };

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
      case Constants.Textbox:
        return "Textinput1";
      case Constants.DropdownList:
        return "Textinput2";
      case Constants.TextArea:
        return "Textinput3";
      case Constants.Radiobutton:
        return "Textinput4";
      case Constants.HijriCalendar:
        return "Textinput6";
      case Constants.GregorianCalendar:
        return "Textinput5";
      case Constants.Numbersfield:
        return "Integerinput1";
      case Constants.MultiSelectDropdown:
        return "MultiselectList";
      default:
        return "";
    }
  }

  dynamic getSelectedFieldValue(String? fieldType) {
    switch (fieldType) {
      case Constants.Textbox:
        return selectedTextValue;
      case Constants.DropdownList:
        return selectedDropDownValue?.addlFeildValue;
      case Constants.TextArea:
        return selectedTextValue;

      case Constants.Radiobutton:
        return selectedDropDownValue?.addlFeildValue;

      case Constants.HijriCalendar:
        return selectedTextValue;

      case Constants.GregorianCalendar:
        return selectedTextValue;

      case Constants.Numbersfield:
        return selectedTextValue;
      case Constants.MultiSelectDropdown:
        return selectedMultiSelectValue
            ?.map((e) => {"AddlFeildValue": e.addlFeildValue})
            .toList();
      default:
        return "";
    }
  }
}

class ValueList {
  ValueList({this.addlFeildValue, this.fieldId, this.id});

  String? addlFeildValue;
  String? fieldId;
  String? id;

  factory ValueList.fromJson(Map<String, dynamic> json) => ValueList(
        addlFeildValue: json["AddlFeildValue"],
        fieldId: json["FieldID"],
      );

  Map<String, dynamic> toJson() => {
        "AddlFeildValue": addlFeildValue,
        "FieldID": fieldId,
      };

  DropDownItem? getDropDownItem() {
    return DropDownItem(id: id, name: addlFeildValue ?? "");
  }
}
