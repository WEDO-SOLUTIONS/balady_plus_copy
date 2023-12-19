import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart';
import '../../../domain/use_cases/municipal_services.dart';
import '../../../services_exports.dart'
    show
        ImportantServices,
        IslamicServices,
        NewServices,
        CustomerVoiceServices,
        HonoringTheDeadServices,
        HelpServices,
        BusinessLicenseServices,
        ServiceEntity;

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  //final ImportantServices importantServices;
//  final NewServices newServices;
  final IslamicServices islamicServices;
  // final CustomerVoiceServices customerVoiceServices;
  //final HonoringTheDeadServices honoringTheDeadServices;
  final HelpServices helpServices;
  final MunicipalServices municipalServices;
  //final HealthCertificatesServices healthCertificatesServices;
  final BusinessLicenseServices businessLicenseServices;

  ServicesCubit({
    required this.businessLicenseServices,
    //  required this.customerVoiceServices,
    // required this.healthCertificatesServices,
    required this.municipalServices,
    required this.helpServices,
    // required this.honoringTheDeadServices,
    // required this.importantServices,
    // required this.newServices,
    required this.islamicServices,
  }) : super(const ServicesState()) {
    loadServices();
  }

  Future<void> loadServices() async {
    print("load services ");
    emit(state.copyWith(status: BlocStatus.loading));
    final islamicServicesList = await islamicServices(NoParams());

    final businessLicenseServicesList =
        await businessLicenseServices(NoParams());

    final helpServicesList = await helpServices(NoParams());
    final municpalServicesList = await municipalServices(NoParams());

    emit(state.copyWith(status: BlocStatus.closeLoading));
    emit(state.copyWith(
      status: BlocStatus.success,
      importantServices: [],
      newServices: [],
      islamicServices: islamicServicesList.getOrElse(() => []),
      municipalServices: municpalServicesList.getOrElse(() => []),
      customerVoiceServices: [],
      businessLicenseServices: businessLicenseServicesList.getOrElse(() => []),
      helpServices: helpServicesList.getOrElse(() => []),
      honoringTheDeadServices: [],
    ));
  }

  Future<void> searchServices(String? searchQuery) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final islamicServicesList = await islamicServices(NoParams());
    final municpalServicesList = await municipalServices(NoParams());

    final businessLicenseServicesList =
        await businessLicenseServices(NoParams());

    //final healthCertificatesServicesList =
    //    await healthCertificatesServices(NoParams());
    final helpServicesList = await helpServices(NoParams());

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
      municipalServices:
          municpalServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      helpServices: helpServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      searchQuery: Nullable(searchQuery),
    ));
  }

  void checkEkramServices() async {
    print("checkEkramServices");
    emit(state.copyWith(status: BlocStatus.closeLoading));

    final businessLicenseServicesList =
        await businessLicenseServices(NoParams());

    emit(state.copyWith(
      status: BlocStatus.success,
      businessLicenseServices:
          businessLicenseServicesList.getOrElse(() => []).where((service) {
        if (CommonProperties.showEkramDriver) return true;
        if (CommonProperties.showEkramDriver != true && service.id == 316)
          return false;
        return true;
      }).toList(),
    ));
  }

  void toggleSearchField() {
    emit(state.copyWith(showSearchField: !state.showSearchField));
  }
}
