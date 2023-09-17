import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/local_form_validation.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/validate/validate_form_response.dart';
import 'package:formz/formz.dart';

import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../app/features/new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../../core/utils/common_properties.dart';
import '../../../../core/utils/enums/dynamic_forms.dart';

class CreateFormItemResponse {
  String? id;
  String? requestTypeId;
  String? serviceId;
  String? relationId;
  bool? isPrimary;
  String? serviceName;

  List<FormItems>? items;

  CreateFormItemResponse(
      {this.id,
      this.requestTypeId,
      this.serviceId,
      this.items,
      this.relationId,
      this.isPrimary,
      this.serviceName});

  Map<String, dynamic> getFieldsRequest() {
    Map<String, dynamic> fields = {};

    items?.forEach((e) {
      if (e.getComponentType() == DynamicFormComponentType.hidden)
        fields.putIfAbsent(e.field?.id ?? "", () => CommonProperties.cityId);

      if (e.getComponentType() == DynamicFormComponentType.dropDown)
        fields.putIfAbsent(e.field?.id ?? "", () => e.selectedDataItem?.id);

      if (e.getComponentType() == DynamicFormComponentType.text)
        fields.putIfAbsent(e.field?.id ?? "", () => e.value);
    });

    return fields;
  }
}

class FormItems {
  FormItems({
    this.field,
  });

  FormItemField? field;
  dynamic value;
  List<DropDownItem>? dataItems;
  DropDownItem? selectedDataItem;
  ValidationsErrors? errors;
  List<LocalFormValidation>? validations;

  DynamicFormComponentType getComponentType() {
    switch (field?.componentType) {
      case "hidden-field":
        return DynamicFormComponentType.hidden;

      case "drop-down":
        return DynamicFormComponentType.dropDown;

      case "text":
        return DynamicFormComponentType.text;

      default:
        return DynamicFormComponentType.none;
    }
  }

  DynamicFormFieldDataType getFieldDataType() {
    switch (field?.dataTypeInfo?.dataType) {
      case "integer":
        return DynamicFormFieldDataType.integer;

      case "string":
        return DynamicFormFieldDataType.string;

      case "decimal":
        return DynamicFormFieldDataType.decimal;

      default:
        return DynamicFormFieldDataType.none;
    }
  }

  String get fieldLabel => field?.label ?? "";

  bool get fieldRequired => field?.required ?? false;

  bool get fieldReadOnly => field?.readOnly ?? false;
}

class FormItemField {
  FormItemField(
      {this.id,
      this.name,
      this.label,
      this.componentType,
      this.dataTypeInfo,
      this.required,
      this.readOnly,
      this.validations,
      this.dataSourceFields,
      this.value});

  String? id;
  Name? name;
  String? label;
  String? componentType;
  DataTypeInfo? dataTypeInfo;
  bool? required;
  bool? readOnly;
  List<Validation>? validations;
  List<String>? dataSourceFields;
  dynamic value;

  String getValue() {
    if (componentType == "text") return value.toString();
    if (componentType == "lookup") return (value as LookUpItem).name ?? "";
    return "";
  }
}

class DataTypeInfo {
  DataTypeInfo({
    this.dataType,
    this.config,
  });

  String? dataType;
  Config? config;

  factory DataTypeInfo.fromJson(Map<String, dynamic> json) => DataTypeInfo(
        dataType: json["dataType"],
        config: json["config"] == null ? null : Config.fromJson(json["config"]),
      );
}

class Config {
  Config({
    this.precision,
  });

  int? precision;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        precision: json["precision"],
      );
}

class Name {
  Name({
    this.name,
    this.version,
  });

  String? name;
  int? version;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        name: json["name"],
        version: json["version"],
      );
}

class Validation {
  Validation({
    this.type,
    this.messageId,
    this.message,
  });

  String? type;
  String? messageId;
  String? message;

  factory Validation.fromJson(Map<String, dynamic> json) => Validation(
        type: json["type"],
        messageId: json["messageId"],
        message: json["message"],
      );
}
