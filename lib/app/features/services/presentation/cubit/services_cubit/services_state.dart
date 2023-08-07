// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'services_cubit.dart';

class ServicesState extends Equatable {
  final BlocStatus status;
  final List<ServiceEntity> islamicServices;
  final List<ServiceEntity> customerVoiceServices;
  final List<ServiceEntity> businessLicenseServices;
  final List<ServiceEntity> healthCertificatesServices;
  final List<ServiceEntity> helpServices;
  final List<ServiceEntity> honoringTheDeadServices;

  final List<ServiceEntity> newServices;
  final List<ServiceEntity> importantServices;
  final String? searchQuery;
  final bool showSearchField;
  final String? errorMessage;

  const ServicesState({
    this.businessLicenseServices = const [],
    this.healthCertificatesServices = const [],
    this.helpServices = const [],
    this.honoringTheDeadServices = const [],
    this.status = BlocStatus.initial,
    this.islamicServices = const [],
    this.customerVoiceServices = const [],
    this.newServices = const [],
    this.importantServices = const [],
    this.searchQuery,
    this.showSearchField = false,
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  @override
  List<Object?> get props {
    return [
      status,
      islamicServices,
      customerVoiceServices,
      newServices,
      importantServices,
      errorMessage,
      showSearchField
    ];
  }

  ServicesState copyWith({
    BlocStatus? status,
    List<ServiceEntity>? islamicServices,
    List<ServiceEntity>? customerVoiceServices,
    List<ServiceEntity>? businessLicenseServices,
    List<ServiceEntity>? healthCertificatesServices,
    List<ServiceEntity>? helpServices,
    List<ServiceEntity>? honoringTheDeadServices,
    List<ServiceEntity>? newServices,
    List<ServiceEntity>? importantServices,
    Nullable<String?>? searchQuery,
    bool? showSearchField,
    String? errorMessage,
  }) {
    return ServicesState(
      status: status ?? this.status,
      islamicServices: islamicServices ?? this.islamicServices,
      customerVoiceServices:
          customerVoiceServices ?? this.customerVoiceServices,
      businessLicenseServices:
          businessLicenseServices ?? this.businessLicenseServices,
      healthCertificatesServices:
          healthCertificatesServices ?? this.healthCertificatesServices,
      helpServices: helpServices ?? this.helpServices,
      honoringTheDeadServices:
          honoringTheDeadServices ?? this.honoringTheDeadServices,
      newServices: newServices ?? this.newServices,
      importantServices: importantServices ?? this.importantServices,
      searchQuery: searchQuery == null ? this.searchQuery : searchQuery.value,
      showSearchField: showSearchField ?? this.showSearchField,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
