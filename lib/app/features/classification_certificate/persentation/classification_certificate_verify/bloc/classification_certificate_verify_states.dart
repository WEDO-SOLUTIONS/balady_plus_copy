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
  const AdvancedMethodClassificationCertificateState(
      {required super.typeMethod});

  @override
  List<Object?> get props => [super.typeMethod];
}

class NormalSearchVerifiedByClassificationCertificateState
    extends ClassificationCertificateVerifyState {
  final NormalSearchType normalSearchType;
  final Widget verifiedByWidget;

  const NormalSearchVerifiedByClassificationCertificateState({
    required this.normalSearchType,
    required this.verifiedByWidget,
    required super.typeMethod,
  });

  @override
  List<Object?> get props => [super.typeMethod, normalSearchType];
}
