import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart';
import '../../../domain/use_cases/ekram_services.dart';
import '../../../domain/use_cases/municipal_services.dart';
import '../../../services_exports.dart'
    show IslamicServices, HelpServices, BusinessLicenseServices, ServiceEntity;

import 'package:dio/dio.dart' show Response;

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
  final EkramServices ekramServices;

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
    required this.ekramServices,
  }) : super(const ServicesState()) {
    loadServices();
  }

  Future<bool> checkForjoodService() async {
    WebService webService = sl();
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.getJoodShowStatus);
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result['isEnabled'];
    } catch (ex) {
      return true;
    }
  }

  Future<bool> checkForChatBotEnabled() async {
    WebService webService = sl();
    Response? response;
    try {
      response = await webService.dio.get(ApiUrl.chatBotEnabled);
      final data = response.data;
      final result = ResponseBodyModel.fromMap(data).data?.result;
      return result['isEnabled'];
    } catch (ex) {
      return true;
    }
  }

  Future<void> loadServices() async {
    print("load services ");
    emit(state.copyWith(status: BlocStatus.loading));
    final bool checkForJood = await checkForjoodService();
    final bool checkForChatpot = await checkForChatBotEnabled();

    final islamicServicesList = await islamicServices(NoParams());
    final businessLicenseServicesList =
    await businessLicenseServices(NoParams());
    final helpServicesList = await helpServices(NoParams());
    final municpalServicesList = await municipalServices(NoParams());
    final ekramServicesList = await ekramServices(NoParams());

    List<ServiceEntity>? islamicServicesListValue =
    islamicServicesList.getOrElse(() => []);
    List<ServiceEntity>? helpServicesListValue =
    helpServicesList.getOrElse(() => []);

    islamicServicesListValue
        .removeWhere((element) => (element.id == 103 && !checkForJood));

    helpServicesListValue.removeWhere(
          (element) => (element.id == 407 && !checkForChatpot ||
          element.id == 401 && checkForChatpot),
    );

    emit(state.copyWith(status: BlocStatus.closeLoading));
    emit(state.copyWith(
      status: BlocStatus.success,
      importantServices: [],
      newServices: [],
      islamicServices: islamicServicesListValue,
      municipalServices: municpalServicesList.getOrElse(() => []),
      customerVoiceServices: [],
      businessLicenseServices: businessLicenseServicesList.getOrElse(() => []),
      helpServices: helpServicesListValue,
      honoringTheDeadServices: ekramServicesList.getOrElse(() => []),
    ));
  }

  Future<void> searchServices(String? searchQuery) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final islamicServicesList = await islamicServices(NoParams());
    final municpalServicesList = await municipalServices(NoParams());
    final ekramServicesList = await ekramServices(NoParams());
    final businessLicenseServicesList =
    await businessLicenseServices(NoParams());
    //final healthCertificatesServicesList =
    //    await healthCertificatesServices(NoParams());
    final helpServicesList = await helpServices(NoParams());
    final bool checkForJood = await checkForjoodService();
    final bool checkForChatpot = await checkForChatBotEnabled();

    List<ServiceEntity>? islamicServicesListValue =
    islamicServicesList.getOrElse(() => []);
    List<ServiceEntity>? helpServicesListValue =
    helpServicesList.getOrElse(() => []);

    islamicServicesListValue
        .removeWhere((element) => (element.id == 103 && !checkForJood));

    helpServicesListValue.removeWhere(
          (element) => (element.id == 407 && !checkForChatpot ||
          element.id == 401 && checkForChatpot),
    );

    emit(state.copyWith(status: BlocStatus.closeLoading));
    emit(state.copyWith(
      status: BlocStatus.success,
      honoringTheDeadServices:
      ekramServicesList.getOrElse(() => []).where((service) {
        return true;
      }).toList(),
      businessLicenseServices:
      businessLicenseServicesList.getOrElse(() => []).where((service) {
        return service.title
            .tr()
            .toLowerCase()
            .contains(searchQuery!.toLowerCase());
      }).toList(),
      islamicServices: islamicServicesListValue.where((service) {
        return service.title
            .tr()
            .toLowerCase()
            .contains(searchQuery!.toLowerCase());
      }).toList(),
      municipalServices: municpalServicesList.getOrElse(() => []).where((service) {
        return service.title
            .tr()
            .toLowerCase()
            .contains(searchQuery!.toLowerCase());
      }).toList(),
      helpServices: helpServicesListValue.where((service) {
        return service.title
            .tr()
            .toLowerCase()
            .contains(searchQuery!.toLowerCase());
      }).toList(),
      searchQuery: Nullable(searchQuery),
    ));
  }


  void checkEkramServices() async {
    print("checkEkramServices");
    emit(state.copyWith(status: BlocStatus.closeLoading));

    final businessLicenseServicesList = await ekramServices(NoParams());

    emit(state.copyWith(
      status: BlocStatus.success,
      honoringTheDeadServices:
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
