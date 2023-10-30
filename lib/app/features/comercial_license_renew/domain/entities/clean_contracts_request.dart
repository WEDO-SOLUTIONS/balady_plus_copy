import 'package:equatable/equatable.dart';

class CleanContractsRequest extends Equatable {
  final int requestId;

  const CleanContractsRequest({required this.requestId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }

  @override
  List<Object?> get props => [];
}
