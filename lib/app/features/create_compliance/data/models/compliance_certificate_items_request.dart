import 'package:equatable/equatable.dart';

class ComplianceCertificateItemsRequest {
  int? requestId;
  List<ComplianceCertificateItem>? items;
  ComplianceCertificateItemsRequest({this.requestId, this.items});

  List toRequest() {
    return List<ComplianceCertificateItem>.from(items ?? [])
        .map((e) => e.toMap())
        .toList();
  }
}

class ComplianceCertificateItem extends Equatable {
  final int? itemAnswer;
  final String? itemId;

  const ComplianceCertificateItem({this.itemAnswer, this.itemId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'itemAnswer': itemAnswer, 'itemId': itemId};
  }

  @override
  List<Object?> get props => [];
}
