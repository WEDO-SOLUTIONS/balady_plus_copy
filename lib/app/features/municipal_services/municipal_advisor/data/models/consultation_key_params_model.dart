import 'package:equatable/equatable.dart';

class ConsultationKeyParamsModel extends Equatable {
  final String gender;
  final String mobile;
  final String submitterBirthDate;

  const ConsultationKeyParamsModel({
    required this.gender,
    required this.mobile,
    required this.submitterBirthDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gender': gender,
      'mobile': mobile,
      'submitterBirthDate': submitterBirthDate,
    };
  }

  @override
  List<Object?> get props => [
        gender,
        mobile,
        submitterBirthDate,
      ];
}
