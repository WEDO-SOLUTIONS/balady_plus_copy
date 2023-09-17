import 'package:equatable/equatable.dart';

class RequestRepliesModel extends Equatable {
  final String? relationId;
  final String? requestId;
  final String? subServiceName;
  final String? subServiceId;
  final String? requestNumber;
  final int? createdOffersCount;
  final int? submittedOffersCount;
  final int? processedOffersCount;
  bool? isAccepted;

  RequestRepliesModel(
      {this.relationId,
      this.requestId,
      this.requestNumber,
      this.subServiceId,
      this.subServiceName,
      this.processedOffersCount,
      this.submittedOffersCount,
      this.createdOffersCount,
      this.isAccepted});

  @override
  List<Object?> get props => [requestId, relationId, requestNumber];
}
