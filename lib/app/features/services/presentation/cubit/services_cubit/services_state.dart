part of 'services_cubit.dart';

class ServicesState extends Equatable {
  final BlocStatus status;
  final List<ServiceEntity> publicServices;
  final List<ServiceEntity> municipalServices;
  final List<ServiceEntity> newServices;
  final List<ServiceEntity> importantServices;
  final String? errorMessage;

  const ServicesState({
    this.status = BlocStatus.initial,
    this.publicServices = const [],
    this.municipalServices = const [],
    this.newServices = const [],
    this.importantServices = const [],
    this.errorMessage,
  });

  String get error => errorMessage ?? '';

  ServicesState copyWith({
    BlocStatus? status,
    List<ServiceEntity>? publicServices,
    List<ServiceEntity>? municipalServices,
    List<ServiceEntity>? newServices,
    List<ServiceEntity>? importantServices,
    String? errorMessage,
  }) {
    return ServicesState(
      status: status ?? this.status,
      publicServices: publicServices ?? this.publicServices,
      municipalServices: municipalServices ?? this.municipalServices,
      newServices: newServices ?? this.newServices,
      importantServices: importantServices ?? this.importantServices,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props {
    return [
      status,
      publicServices,
      municipalServices,
      newServices,
      importantServices,
      errorMessage,
    ];
  }
}
