import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart';
import '../../../services_exports.dart'
    show
        ImportantServices,
        IslamicServices,
        NewServices,
        CustomerVoiceServices,
        HonoringTheDeadServices,
        HelpServices,
        HealthCertificatesServices,
        BusinessLicenseServices,
        ServiceEntity;

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ImportantServices importantServices;
  final NewServices newServices;
  final IslamicServices islamicServices;
  final CustomerVoiceServices customerVoiceServices;
  final HonoringTheDeadServices honoringTheDeadServices;
  final HelpServices helpServices;
  //final HealthCertificatesServices healthCertificatesServices;
  final BusinessLicenseServices businessLicenseServices;

  ServicesCubit({
    required this.businessLicenseServices,
    required this.customerVoiceServices,
    // required this.healthCertificatesServices,
    required this.helpServices,
    required this.honoringTheDeadServices,
    required this.importantServices,
    required this.newServices,
    required this.islamicServices,
  }) : super(const ServicesState()) {
    loadServices();
  }

  Future<void> loadServices() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final importantServicesList = await importantServices(NoParams());
    final newServicesList = await newServices(NoParams());
    final islamicServicesList = await islamicServices(NoParams());
    final customerVoiceServicesList = await customerVoiceServices(NoParams());

    final businessLicenseServicesList =
        await businessLicenseServices(NoParams());

    //final healthCertificatesServicesList =
    //    await healthCertificatesServices(NoParams());
    final helpServicesList = await helpServices(NoParams());
    final honoringTheDeadServicesList =
        await honoringTheDeadServices(NoParams());

    emit(state.copyWith(status: BlocStatus.closeLoading));
    emit(state.copyWith(
      status: BlocStatus.success,
      importantServices: importantServicesList.getOrElse(() => []),
      newServices: newServicesList.getOrElse(() => []),
      islamicServices: islamicServicesList.getOrElse(() => []),
      customerVoiceServices: customerVoiceServicesList.getOrElse(() => []),
      businessLicenseServices: businessLicenseServicesList.getOrElse(() => []),
      // healthCertificatesServices:
      //    healthCertificatesServicesList.getOrElse(() => []),
      helpServices: helpServicesList.getOrElse(() => []),
      honoringTheDeadServices: honoringTheDeadServicesList.getOrElse(() => []),
    ));
  }

  Future<void> searchServices(String? searchQuery) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final islamicServicesList = await islamicServices(NoParams());
    final customerVoiceServicesList = await customerVoiceServices(NoParams());

    final businessLicenseServicesList =
        await businessLicenseServices(NoParams());

    //final healthCertificatesServicesList =
    //    await healthCertificatesServices(NoParams());
    final helpServicesList = await helpServices(NoParams());
    final honoringTheDeadServicesList =
        await honoringTheDeadServices(NoParams());

    emit(state.copyWith(status: BlocStatus.closeLoading));
    emit(state.copyWith(
      status: BlocStatus.success,
      businessLicenseServices:
          businessLicenseServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      islamicServices: islamicServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      customerVoiceServices:
          customerVoiceServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      helpServices: helpServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      searchQuery: Nullable(searchQuery),
    ));
  }

  void toggleSearchField() {
    emit(state.copyWith(showSearchField: !state.showSearchField));
  }
}
