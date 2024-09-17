part of 'classification_certificate_verify_bloc.dart';

class ClassificationCertificateVerifyState extends Equatable {
  final SearchMethod typeMethod;

  const ClassificationCertificateVerifyState({
    required this.typeMethod,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}

class NormalSearchClassificationCertificateState
    extends ClassificationCertificateVerifyState {
  final List<NormalSearchType> normalSearchTypeList;

  const NormalSearchClassificationCertificateState({
    required super.typeMethod,
    required this.normalSearchTypeList,
  });

  @override
  List<Object?> get props => [super.typeMethod];
}

class AdvancedMethodClassificationCertificateState
    extends ClassificationCertificateVerifyState {
  final AdvancedSearchRequestModel searchRequestModel;

  const AdvancedMethodClassificationCertificateState({
    required super.typeMethod,
    required this.searchRequestModel,
  });

  @override
  List<Object?> get props => [super.typeMethod];
}

class AdvancedMethodNotWorkingClassificationCertificateState
    extends ClassificationCertificateVerifyState {

  const AdvancedMethodNotWorkingClassificationCertificateState({
    required super.typeMethod,
  });

  @override
  List<Object?> get props => [super.typeMethod];
}

class NormalSearchVerifiedByClassificationCertificateState
    extends ClassificationCertificateVerifyState {
  final NormalSearchType normalSearchType;
  final NormalSearchRequestModel searchRequestModel;

  const NormalSearchVerifiedByClassificationCertificateState({
    required this.normalSearchType,
    required this.searchRequestModel,
    required super.typeMethod,
  });

  @override
  List<Object?> get props => [super.typeMethod, normalSearchType];
}
