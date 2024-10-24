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

////////////////////////////////////////////////////////////
class AdvancedSearchState extends ClassificationCertificateVerifyState {
  final AdvancedSearchRequestModel searchRequestModel;
  final List<ClassificationCertificateLookupModel> classificationType;
  final List<ClassificationCertificateLookupModel> degrees;
  final List<CityLookupsModel> cities;
  final TextEditingController phoneNumberTextEditingController;

  const AdvancedSearchState({
    required super.typeMethod,
    required this.phoneNumberTextEditingController,
    required this.searchRequestModel,
    required this.classificationType,
    required this.degrees,
    required this.cities,
  });

  AdvancedSearchState copyWith({
    AdvancedSearchRequestModel? searchRequestModel,
    List<ClassificationCertificateLookupModel>? classificationType,
    List<ClassificationCertificateLookupModel>? degrees,
    List<CityLookupsModel>? cities,
    TextEditingController? phoneNumberTextEditingController,
  }) =>
      AdvancedSearchState(
        typeMethod: super.typeMethod,
        searchRequestModel: searchRequestModel ?? this.searchRequestModel,
        classificationType: classificationType ?? this.classificationType,
        degrees: degrees ?? this.degrees,
        cities: cities ?? this.cities,
        phoneNumberTextEditingController: phoneNumberTextEditingController ??
            this.phoneNumberTextEditingController,
      );

  @override
  List<Object?> get props => [
        super.typeMethod,
        cities,
        classificationType,
        degrees,
        searchRequestModel,
      ];
}

class AdvancedSearchByClassificationTypeState extends AdvancedSearchState {
  final List<ClassificationCertificateLookupModel> services;
  final List<ClassificationCertificateLookupModel> sectors;

  const AdvancedSearchByClassificationTypeState({
    required this.sectors,
    required this.services,
    required super.searchRequestModel,
    required super.typeMethod,
    required super.classificationType,
    required super.degrees,
    required super.cities,
    required super.phoneNumberTextEditingController,
  });

  @override
  AdvancedSearchByClassificationTypeState copyWith({
    AdvancedSearchRequestModel? searchRequestModel,
    List<ClassificationCertificateLookupModel>? classificationType,
    List<ClassificationCertificateLookupModel>? degrees,
    List<ClassificationCertificateLookupModel>? services,
    List<ClassificationCertificateLookupModel>? sectors,
    List<CityLookupsModel>? cities,
    TextEditingController? phoneNumberTextEditingController,
  }) =>
      AdvancedSearchByClassificationTypeState(
        sectors: degrees ?? this.sectors,
        services: services ?? this.services,
        typeMethod: super.typeMethod,
        searchRequestModel: searchRequestModel ?? super.searchRequestModel,
        classificationType: classificationType ?? super.classificationType,
        cities: cities ?? super.cities,
        degrees: degrees ?? super.degrees,
        phoneNumberTextEditingController: phoneNumberTextEditingController ?? super.phoneNumberTextEditingController,
      );

  @override
  List<Object?> get props => [
        typeMethod,
        cities,
        classificationType,
        degrees,
        searchRequestModel,
        sectors,
        services,
      ];
}

class AdvancedMethodBySectorsState
    extends AdvancedSearchByClassificationTypeState {
  final List<ActivityLookupsModel> activity;

  const AdvancedMethodBySectorsState({
    required this.activity,
    required super.sectors,
    required super.services,
    required super.typeMethod,
    required super.searchRequestModel,
    required super.classificationType,
    required super.degrees,
    required super.cities,
    required super.phoneNumberTextEditingController,
  });

  @override
  AdvancedMethodBySectorsState copyWith({
    AdvancedSearchRequestModel? searchRequestModel,
    List<ActivityLookupsModel>? activity,
    List<ClassificationCertificateLookupModel>? classificationType,
    List<ClassificationCertificateLookupModel>? degrees,
    List<ClassificationCertificateLookupModel>? services,
    List<ClassificationCertificateLookupModel>? sectors,
    List<CityLookupsModel>? cities,
    TextEditingController? phoneNumberTextEditingController,
  }) =>
      AdvancedMethodBySectorsState(
        searchRequestModel: searchRequestModel ?? super.searchRequestModel,
        activity: activity ?? this.activity,
        sectors: degrees ?? super.sectors,
        services: services ?? super.services,
        typeMethod: super.typeMethod,
        classificationType: classificationType ?? super.classificationType,
        cities: cities ?? super.cities,
        degrees: degrees ?? super.degrees,
        phoneNumberTextEditingController: phoneNumberTextEditingController ?? super.phoneNumberTextEditingController,
      );

  @override
  List<Object?> get props => [
        typeMethod,
        cities,
        classificationType,
        degrees,
        searchRequestModel,
        sectors,
        services,
        activity,
      ];
}

////////////////////////////////////////////////////////////
class AdvancedMethodNotWorkingState
    extends ClassificationCertificateVerifyState {
  const AdvancedMethodNotWorkingState({
    required super.typeMethod,
  });

  @override
  List<Object?> get props => [super.typeMethod];
}

class AdvancedSearchLoadingState extends ClassificationCertificateVerifyState {
  const AdvancedSearchLoadingState({required super.typeMethod});

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
