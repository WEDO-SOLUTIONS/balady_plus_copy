import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/services/services.dart';
import '../../services_exports.dart' show ServiceEntity;
import '../models/service_model.dart';

abstract class ServicesLocalDataSource {
  Future<List<ServiceEntity>> getCustomerVoiceServices();
  Future<List<ServiceEntity>> getIslamicServices();
  Future<List<ServiceEntity>> getBusinessLicenseServices();
  Future<List<ServiceEntity>> getHonoringTheDeadServices();
  Future<List<ServiceEntity>> getHealthCertificatesServices();
  Future<List<ServiceEntity>> getHelpServices();

  Future<List<ServiceEntity>> getNewServices();
  Future<List<ServiceEntity>> getImportantServices();
}

class ServicesLocalDataSourceImplementation implements ServicesLocalDataSource {
  final List<ServiceEntity> _customerVoiceServices = [];
  final List<ServiceEntity> _islamicServices = [];
  final List<ServiceEntity> _businessLicenseServices = [];
  final List<ServiceEntity> _honoringTheDeadServices = [];
  final List<ServiceEntity> _healthCertificatesServices = [];
  final List<ServiceEntity> _helpServices = [];

  List<ServiceEntity> get _allServices =>
      _customerVoiceServices + _islamicServices;

  @override
  Future<List<ServiceEntity>> getCustomerVoiceServices() async {
    if (_customerVoiceServices.isEmpty) {
      await _loadServices();
    }
    return _customerVoiceServices;
  }

  @override
  Future<List<ServiceEntity>> getIslamicServices() async {
    if (_islamicServices.isEmpty) {
      await _loadServices();
    }
    return _islamicServices;
  }

  @override
  Future<List<ServiceEntity>> getBusinessLicenseServices() async {
    if (_businessLicenseServices.isEmpty) {
      await _loadServices();
    }
    return _businessLicenseServices;
  }

  @override
  Future<List<ServiceEntity>> getHealthCertificatesServices() async {
    if (_healthCertificatesServices.isEmpty) {
      await _loadServices();
    }
    return _healthCertificatesServices;
  }

  @override
  Future<List<ServiceEntity>> getHelpServices() async {
    if (_helpServices.isEmpty) {
      await _loadServices();
    }
    return _helpServices;
  }

  @override
  Future<List<ServiceEntity>> getHonoringTheDeadServices() async {
    // if (_honoringTheDeadServices.isEmpty) {
    //   await _loadServices();
    //  }
    //  return _honoringTheDeadServices;
    return [];
  }

  @override
  Future<List<ServiceEntity>> getNewServices() async {
    if (_customerVoiceServices.isEmpty || _islamicServices.isEmpty) {
      await _loadServices();
    }
    return _allServices.where((service) => service.isNew).toList();
  }

  @override
  Future<List<ServiceEntity>> getImportantServices() async {
    if (_customerVoiceServices.isEmpty || _islamicServices.isEmpty) {
      await _loadServices();
    }
    return _allServices.where((service) => service.isImportant).toList();
  }

  Future<void> _loadServices() async {
    final servicesJson = servicesConfig;
    //final servicesJson = json.decode(services) as Map<String, dynamic>;
    final islamicServicesJson =
        servicesJson['islamic_services'] as List<dynamic>;
    final customerVoiceServicesJson =
        servicesJson['customer_voice_services'] as List<dynamic>;
    final businessLicenseServicesJson =
        servicesJson['business_license_services'] as List<dynamic>;
    /*final honoringTheDeadServicesJson =
        servicesJson['honoring_the_dead_services'] as List<dynamic>;*/
    final healthCertificatesServicesJson =
        servicesJson['health_certificates_services'] as List<dynamic>;
    final helpServicesJson = servicesJson['help_services'] as List<dynamic>;
    _customerVoiceServices.addAll(customerVoiceServicesJson
        .map(
            (service) => ServiceModel.fromJson(service as Map<String, dynamic>))
        .toList());
    _islamicServices.addAll(islamicServicesJson
        .map(
            (service) => ServiceModel.fromJson(service as Map<String, dynamic>))
        .toList());

    _businessLicenseServices.addAll(
      businessLicenseServicesJson.map(
        (service) => ServiceModel.fromJson(service as Map<String, dynamic>),
      ),
    );
    /* _honoringTheDeadServices.addAll(
      honoringTheDeadServicesJson.map(
        (service) => ServiceModel.fromJson(service as Map<String, dynamic>),
      ),
    );*/

    _healthCertificatesServices.addAll(
      healthCertificatesServicesJson.map(
        (service) => ServiceModel.fromJson(service as Map<String, dynamic>),
      ),
    );

    _helpServices.addAll(
      helpServicesJson.map(
        (service) => ServiceModel.fromJson(service as Map<String, dynamic>),
      ),
    );
  }
}
