import 'package:balady_plus/etmam_app/features/dynamic_form/dynamic_forms_exports.dart';
import 'package:equatable/equatable.dart';

class FormDataResponse extends Equatable {
  final String? formId;
  final List<FormItems>? items;

  FormDataResponse({this.items, this.formId});

  @override
  List<Object?> get props => [];
}
