import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/services/services.dart';
import '../../services_exports.dart' show ServiceEntity;
import '../models/service_model.dart';

abstract class ServicesLocalDataSource {
  Future<List<ServiceEntity>> getIslamicServices();
  Future<List<ServiceEntity>> getBusinessLicenseServices();
  Future<List<ServiceEntity>> getMunicipalServices();
  //Future<List<ServiceEntity>> getHealthCertificatesServices();
  Future<List<ServiceEntity>> getHelpServices();
}

class ServicesLocalDataSourceImplementation implements ServicesLocalDataSource {
  final List<ServiceEntity> _islamicServices = [];
  final List<ServiceEntity> _businessLicenseServices = [];
  final List<ServiceEntity> _helpServices = [];
  final List<ServiceEntity> _municipalServices = [];

  List<ServiceEntity> get _allServices =>
      _islamicServices +
      _businessLicenseServices +
      _helpServices +
      _municipalServices;

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
  Future<List<ServiceEntity>> getHelpServices() async {
    if (_helpServices.isEmpty) {
      await _loadServices();
    }
    return _helpServices;
  }

  Future<void> _loadServices() async {
    final servicesJson = servicesConfig;
    //final servicesJson = json.decode(services) as Map<String, dynamic>;
    final islamicServicesJson =
        servicesJson['islamic_services'] as List<dynamic>;

    final businessLicenseServicesJson =
        servicesJson['business_license_services'] as List<dynamic>;

    final municpalServicesJson =
        servicesJson['municipal_services'] as List<dynamic>;

    final helpServicesJson = servicesJson['help_services'] as List<dynamic>;

    _islamicServices.addAll(islamicServicesJson
        .map(
            (service) => ServiceModel.fromJson(service as Map<String, dynamic>))
        .toList());

    _businessLicenseServices.addAll(
      businessLicenseServicesJson.map(
        (service) => ServiceModel.fromJson(service as Map<String, dynamic>),
      ),
    );

    _municipalServices.addAll(
      municpalServicesJson.map(
        (service) => ServiceModel.fromJson(service as Map<String, dynamic>),
      ),
    );

    _helpServices.addAll(
      helpServicesJson.map(
        (service) => ServiceModel.fromJson(service as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<List<ServiceEntity>> getMunicipalServices() async {
    if (_municipalServices.isEmpty) {
      await _loadServices();
    }
    return _municipalServices;
  }
}
