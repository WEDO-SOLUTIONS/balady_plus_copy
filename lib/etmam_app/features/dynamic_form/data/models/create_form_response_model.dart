import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';

import '../../../../../app/features/new_appointment/presentation/core/models/lookup_list_model.dart';

class CreateFormItemResponseModel extends CreateFormItemResponse {
  CreateFormItemResponseModel({
    super.id,
    super.requestTypeId,
    super.serviceId,
    super.items,
  });

  factory CreateFormItemResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateFormItemResponseModel(
        id: json["id"],
        requestTypeId: json["requestTypeId"],
        serviceId: json["serviceId"],
        items: json["items"] != null
            ? List<FormItems>.from(
                json["items"].map((x) => FormItemsModel.fromJson(x)))
            : [],
      );
}

class FormItemsModel extends FormItems {
  FormItemsModel({
    super.field,
  });

  factory FormItemsModel.fromJson(Map<String, dynamic> json) => FormItemsModel(
        field: json["field"] != null
            ? FormFieldModel.fromJson(json["field"])
            : null,
      );
}

class FormFieldModel extends FormItemField {
  FormFieldModel(
      {super.id,
      super.name,
      super.label,
      super.componentType,
      super.dataTypeInfo,
      super.required,
      super.readOnly,
      super.validations,
      super.dataSourceFields,
      super.value});

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    FormFieldModel item = FormFieldModel(
        id: json["id"],
        name: json["name"] != null ? NameModel.fromJson(json["name"]) : null,
        label: json["label"],
        componentType: json["componentType"],
        dataTypeInfo: json["dataTypeInfo"] != null
            ? DataTypeInfoModel.fromJson(json["dataTypeInfo"])
            : null,
        required: json["required"],
        readOnly: json["readOnly"],
        validations: json["validations"] != null
            ? List<ValidationModel>.from(
                json["validations"].map((x) => ValidationModel.fromJson(x)))
            : null,
        dataSourceFields: json["dataSourceFields"] == null
            ? null
            : List<String>.from(json["dataSourceFields"].map((x) => x)),
        value: json["value"]);

    item.value = item.setValue(json["value"], json["componentType"]);
    return item;
  }

  dynamic setValue(dynamic value, String componentType) {
    switch (componentType) {
      case "lookup":
        return LookUpItem(id: int.tryParse(value["id"]), name: value["name"]);

        // case "text":
        return value;

      // case "decimal":
      //  return DynamicFormFieldDataType.decimal;

      default:
        return value;
    }
  }
}

class DataTypeInfoModel extends DataTypeInfo {
  DataTypeInfoModel({
    super.dataType,
    super.config,
  });

  factory DataTypeInfoModel.fromJson(Map<String, dynamic> json) =>
      DataTypeInfoModel(
        dataType: json["dataType"],
        config: json["config"] == null ? null : Config.fromJson(json["config"]),
      );
}

class ConfigModel extends Config {
  ConfigModel({
    super.precision,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        precision: json["precision"],
      );
}

class NameModel extends Name {
  NameModel({
    super.name,
    super.version,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) => NameModel(
        name: json["name"],
        version: json["version"],
      );
}

class ValidationModel extends Validation {
  ValidationModel({
    super.type,
    super.messageId,
    super.message,
  });

  factory ValidationModel.fromJson(Map<String, dynamic> json) =>
      ValidationModel(
        type: json["type"],
        messageId: json["messageId"],
        message: json["message"],
      );
}
