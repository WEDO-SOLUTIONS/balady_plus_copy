part of 'classification_certificate_verify_bloc.dart';

class ClassificationCertificateVerifyEvents extends Equatable {
  const ClassificationCertificateVerifyEvents();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}


class SelectSearchMethodClassificationCertificateState extends ClassificationCertificateVerifyEvents {
  final SearchMethod typeMethod;

  const SelectSearchMethodClassificationCertificateState({
    required this.typeMethod,
  });

  @override
  List<Object?> get props => [typeMethod];
}

class SelectNormalSearchTypeClassificationCertificateState extends ClassificationCertificateVerifyEvents {
  final NormalSearchType normalSearchType;

  const SelectNormalSearchTypeClassificationCertificateState({
    required this.normalSearchType,
  });

  @override
  List<Object?> get props => [normalSearchType];
}

class SelectClassificationTypeState extends ClassificationCertificateVerifyEvents {
  final ClassificationCertificateLookupModel classificationType;
  const SelectClassificationTypeState({required this.classificationType});

  @override
  List<Object?> get props => [classificationType];
}

class SelectSectorState extends ClassificationCertificateVerifyEvents {
  final ClassificationCertificateLookupModel sector;
  const SelectSectorState({required this.sector});

  @override
  List<Object?> get props => [sector];
}


class UpdateRequestModelAdvancedSearchState extends ClassificationCertificateVerifyEvents {
  final AdvancedSearchRequestModel searchRequestModel;
  const UpdateRequestModelAdvancedSearchState({required this.searchRequestModel});

  @override
  List<Object?> get props => [searchRequestModel];
}

// class GoSearchScreenClassificationCertificateState extends ClassificationCertificateVerifyEvents {
//
//   const GoSearchScreenClassificationCertificateState();
//
//   @override
//   List<Object?> get props => [];
// }


class GetLookupsClassificationCertificateState extends ClassificationCertificateVerifyEvents {

  const GetLookupsClassificationCertificateState();

  @override
  List<Object?> get props => [];
}
