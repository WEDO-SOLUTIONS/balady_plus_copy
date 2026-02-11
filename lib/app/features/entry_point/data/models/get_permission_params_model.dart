import 'package:equatable/equatable.dart';

class GetPermissionParamsModel extends Equatable {
  final List<Claim> claims;
  const GetPermissionParamsModel({required this.claims});

  Map<String, dynamic> toMap() => {
        "claims": claims.map((e) => {"type": e.type, "value": e.value}).toList()
      };

  @override
  List<Object?> get props => [];
}

class Claim extends Equatable {
  final String? type;
  final String? value;

  const Claim({this.type, this.value});

  @override
  List<Object?> get props => [];
}
