import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart';
import '../../../services_exports.dart'
    show
        ImportantServices,
        MunicipalServices,
        NewServices,
        PublicServices,
        ServiceEntity;

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final ImportantServices importantServices;
  final NewServices newServices;
  final MunicipalServices municipalServices;
  final PublicServices publicServices;

  ServicesCubit({
    required this.importantServices,
    required this.newServices,
    required this.municipalServices,
    required this.publicServices,
  }) : super(const ServicesState()) {
    loadServices();
  }

  Future<void> loadServices() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final importantServicesList = await importantServices(NoParams());
    final newServicesList = await newServices(NoParams());
    final municipalServicesList = await municipalServices(NoParams());
    final publicServicesList = await publicServices(NoParams());
    emit(state.copyWith(status: BlocStatus.closeLoading));
    emit(state.copyWith(
      status: BlocStatus.success,
      importantServices: importantServicesList.getOrElse(() => []),
      newServices: newServicesList.getOrElse(() => []),
      municipalServices: municipalServicesList.getOrElse(() => []),
      publicServices: publicServicesList.getOrElse(() => []),
    ));
  }

  Future<void> searchServices(String? searchQuery) async {
    emit(state.copyWith(status: BlocStatus.loading));
    final municipalServicesList = await municipalServices(NoParams());
    final publicServicesList = await publicServices(NoParams());
    emit(state.copyWith(status: BlocStatus.closeLoading));
    emit(state.copyWith(
      status: BlocStatus.success,
      municipalServices:
          municipalServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      publicServices: publicServicesList.getOrElse(() => []).where((service) {
        return service.title.toLowerCase().contains(searchQuery!.toLowerCase());
      }).toList(),
      searchQuery: Nullable(searchQuery),
    ));
  }

  void toggleSearchField() {
    emit(state.copyWith(showSearchField: !state.showSearchField));
  }
}
