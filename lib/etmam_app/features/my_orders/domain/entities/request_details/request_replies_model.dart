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

  String? financialAttachmentId;
  String? technicalAttachmentId;
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
      this.isAccepted,
      this.financialAttachmentId,
      this.technicalAttachmentId});

  @override
  List<Object?> get props => [requestId, relationId, requestNumber];
}
