import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/core/errors/failures.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/entities/services_page_params.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/sub_services/sub_service_params.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show SubServiceResponse;
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceParams, GetServicesProvidersByService;

part 'sub_services_event.dart';
part 'sub_services_state.dart';

class SubServicesBloc extends Bloc<SubServicesEvent, SubServicesState> {
  // final GetSubService _getSubService;
  final GetServicesProvidersByService _getServicesProvidersByService;

  SubServicesBloc({
    required SubServiceResponse response,
    //required GetSubService getSubService,
    required GetServicesProvidersByService getServicesProvidersByService,
  })  : // _getSubService = getSubService,
        _getServicesProvidersByService = getServicesProvidersByService,
        super(SubServicesState(subServiceResponse: response)) {
    on<SubServicesEvent>((event, emit) {});

    //on<GetSubServiceEvent_>(_getSubServicesHandler);
    on<GetProvidersEvent>(_getProvidersHandler);
  }

  /*Future<void> _getSubServicesHandler(
      GetSubServiceEvent_ e, Emitter emitter) async {
    emitter(state.copyWith(blocStatus: BlocStatus.loading));

    final failureOrSuccess = await _getSubService(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        blocStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        blocStatus: BlocStatus.success,
        errorMessage: "",
      ));
    });
  }*/

  Future<void> _getProvidersHandler(
      GetProvidersEvent e, Emitter emitter) async {
    emitter(state.copyWith(blocStatus: BlocStatus.loading));

    final failureOrSuccess = await _getServicesProvidersByService(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        blocStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        blocStatus: BlocStatus.success,
        errorMessage: "",
      ));

      // Navigate to Providers screen
      NavigationService.pushNamed(
          routeName: EtmamRoutesNames.providersByService,
          args: ServicePageParams(
            response: success.data!.result!,
          ));
    });
  }
}
