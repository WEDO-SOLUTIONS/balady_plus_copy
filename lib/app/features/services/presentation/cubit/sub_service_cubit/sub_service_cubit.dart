import 'package:balady_plus/app/features/services/domain/entities/services_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sub_service_state.dart';

class ServiceCardsCubit extends Cubit<SubServiceState> {
  final List<Service> listOfServices;
  TextEditingController textFormSearchController = TextEditingController();

  ServiceCardsCubit({required this.listOfServices})
      : super(LoadedSubServiceState(listOfServices: listOfServices));

  void searchServices(String query) {
    if (query.isEmpty) {
      textFormSearchController.text = "";
      emit(LoadedSubServiceState(listOfServices: listOfServices));
    } else {
      final List<Service> filteredServices = listOfServices
          .where(
            (service) => service.title.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
      emit(//
        LoadedSubServiceState(
          listOfServices: filteredServices,
        ),
      );
    }
  }
}
