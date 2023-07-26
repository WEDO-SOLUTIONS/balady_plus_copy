import 'package:equatable/equatable.dart';

class CRMRequestsParamsModel extends Equatable {
  final String id;
  final String mobileNumber;

  const CRMRequestsParamsModel({required this.id, required this.mobileNumber});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mobileNumber': mobileNumber,
    };
  }

  @override
  List<Object?> get props => [
        id,
        mobileNumber,
      ];
}
