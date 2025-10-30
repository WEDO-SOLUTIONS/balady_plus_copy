import 'package:balady_plus/app/features/classification_certificate/domain/entity/classification_certificate_list_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/search_request/search_request_model.dart';

class ClassificationCertificateListState extends Equatable {
  const ClassificationCertificateListState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadingListClassificationCertificateState extends ClassificationCertificateListState {
  const LoadingListClassificationCertificateState();
}

class FieldListClassificationCertificateState extends ClassificationCertificateListState {
  final String errorMessage;
  final SearchRequestModel searchRequestModel;
  const FieldListClassificationCertificateState({
    required this.errorMessage,
    required this.searchRequestModel,
  });

  @override
  List<Object?> get props {
    return [errorMessage];
  }
}

class SuccessListClassificationCertificateState extends ClassificationCertificateListState {
  final List<ClassificationCertificateItemEntity> classificationCertificateItem;
  const SuccessListClassificationCertificateState({required this.classificationCertificateItem});
  @override
  List<Object?> get props {
    return [classificationCertificateItem,classificationCertificateItem.length];
  }
}

final class SucceedWithPaginationListClassificationCertificateState extends SuccessListClassificationCertificateState {
  final SearchRequestModel searchRequestModel;

  const SucceedWithPaginationListClassificationCertificateState({
    required this.searchRequestModel,
    required super.classificationCertificateItem,
  });

  @override
  List<Object?> get props => [searchRequestModel, classificationCertificateItem, classificationCertificateItem.length];
}

class NoListClassificationCertificateDebtState extends ClassificationCertificateListState {
  const NoListClassificationCertificateDebtState();
}
