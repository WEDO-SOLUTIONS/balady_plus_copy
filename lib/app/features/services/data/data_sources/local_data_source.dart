import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/services/services.dart';
import '../../services_exports.dart' show ServiceEntity;
import '../models/service_model.dart';

abstract class ServicesLocalDataSource {
  Future<List<ServiceEntity>> getPublicServices();
  Future<List<ServiceEntity>> getMunicipalServices();
  Future<List<ServiceEntity>> getNewServices();
  Future<List<ServiceEntity>> getImportantServices();
}

class ServicesLocalDataSourceImplementation implements ServicesLocalDataSource {
  final List<ServiceEntity> _publicServices = [];
  final List<ServiceEntity> _municipalServices = [];

  List<ServiceEntity> get _allServices => _publicServices + _municipalServices;

  @override
  Future<List<ServiceEntity>> getPublicServices() async {
    if (_publicServices.isEmpty) {
      await _loadServices();
    }
    return _publicServices;
  }

  @override
  Future<List<ServiceEntity>> getMunicipalServices() async {
    if (_municipalServices.isEmpty) {
      await _loadServices();
    }
    return _municipalServices;
  }

  @override
  Future<List<ServiceEntity>> getNewServices() async {
    if (_publicServices.isEmpty || _municipalServices.isEmpty) {
      await _loadServices();
    }
    return _allServices.where((service) => service.isNew).toList();
  }

  @override
  Future<List<ServiceEntity>> getImportantServices() async {
    if (_publicServices.isEmpty || _municipalServices.isEmpty) {
      await _loadServices();
    }
    return _allServices.where((service) => service.isImportant).toList();
  }

  Future<void> _loadServices() async {
    final servicesJson = servicesConfig;
    //final servicesJson = json.decode(services) as Map<String, dynamic>;
    final publicServicesJson = servicesJson['public_services'] as List<dynamic>;
    final municipalServicesJson =
        servicesJson['municipal_services'] as List<dynamic>;
    _publicServices.addAll(publicServicesJson
        .map(
            (service) => ServiceModel.fromJson(service as Map<String, dynamic>))
        .toList());
    _municipalServices.addAll(municipalServicesJson
        .map(
            (service) => ServiceModel.fromJson(service as Map<String, dynamic>))
        .toList());
  }
}
