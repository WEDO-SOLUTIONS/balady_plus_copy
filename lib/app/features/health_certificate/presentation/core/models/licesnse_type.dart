import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class LicenseType extends Equatable {
  final String value;

  const LicenseType({required this.value});

  String get text => value.tr();

  @override
  List<Object?> get props => [value];
}
