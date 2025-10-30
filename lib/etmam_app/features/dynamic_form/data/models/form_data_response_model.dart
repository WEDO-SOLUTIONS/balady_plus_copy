import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/form_data_response.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:equatable/equatable.dart';

class FormDataResponseModel extends FormDataResponse {
  FormDataResponseModel({super.items});

  factory FormDataResponseModel.fromJson(Map<String, dynamic> json) =>
      FormDataResponseModel(
        items: json["items"] != null
            ? List<FormItems>.from(
                json["items"].map((x) => FormItemsModel.fromJson(x)))
            : [],
      );

  @override
  List<Object?> get props => [];
}
