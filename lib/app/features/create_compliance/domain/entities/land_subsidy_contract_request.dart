import 'package:equatable/equatable.dart';

class LandSubsidyContractRequest extends Equatable {
  final String? id;
  final String? type;

  const LandSubsidyContractRequest({this.id, this.type});

  @override
  List<Object?> get props => [id, type];
}
