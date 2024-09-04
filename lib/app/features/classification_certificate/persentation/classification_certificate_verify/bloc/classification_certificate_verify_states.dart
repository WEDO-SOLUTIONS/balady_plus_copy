part of 'classification_certificate_verify_bloc.dart';

class ClassificationCertificateVerifyState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

enum SearchMethod {
  search(title: "search_name"),
  advancedSearch(title: "advanced_search");

  const SearchMethod({required this.title});

  final String title;
}

class ClassificationCertificateSearchMethodState
    extends ClassificationCertificateVerifyState {
  final SearchMethod typeMethod;

  ClassificationCertificateSearchMethodState({
    required this.typeMethod,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [typeMethod];
}
