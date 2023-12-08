import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';

import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        GetServicesProvidersByService,
        RelationItem,
        RelationResponse,
        ServiceItems,
        ServiceParams;
import 'package:balady_plus/etmam_app/features/submit_request/data/models/relation/provider_relation_page_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/domain/entities/submit/submit_params.dart';
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';

part 'relation_event.dart';
part 'relation_state.dart';

class RelationBloc extends Bloc<RelationEvent, RelationState> {
  final GetServicesProvidersByService _getServicesProvidersByService;

  RelationBloc(
      {RelationResponse? relationResponse,
      RelationPageParam? args,
      required GetServicesProvidersByService getServicesProvidersByService})
      : _getServicesProvidersByService = getServicesProvidersByService,
        super(RelationState(
            relationRespone: relationResponse,
            subRelations: relationResponse?.subRelations,
            subServiceId: args?.subServiceId,
            subServiceName: args?.subServiceName,
            serviceProviderId: args?.serviceProviderId,
            serviceProviderName: args?.serviceProviderName)) {
    on<RelationEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SelectRelationEvent>(_getRelationsHandler);
    on<GetProvidersByService>(_getProvidersHandler);
    on<DeleteRelationItem>(_deleteRelationsHandler);
  }

  Future<void> _getRelationsHandler(
      SelectRelationEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<RelationItem>? items = state.subRelations;
    items?[e.index].isChecked = !(items[e.index].isChecked ?? false);
    emitter(state.copyWith(status: BlocStatus.success, subRelations: items));
  }

  Future<void> _deleteRelationsHandler(
      DeleteRelationItem e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<RelationItem>? items = state.subRelations;
    items = items?.map((element) {
      if (element.id == e.id) {
        element.isChecked = false;
        element.selectedServiceProvider = null;
      }
      return element;
    }).toList();
    emitter(state.copyWith(status: BlocStatus.success, subRelations: items));
  }

  Future<void> _getProvidersHandler(
      GetProvidersByService e, Emitter emitter) async {
    /* List<RelationItem>? items = state.subRelations;
    if (items?[e.index].reletedServicesProviders != null) {
      NavigationService.pushNamed(
          routeName: RouteName.serviceTypesList,
          args: items?[e.index].reletedServicesProviders);

      return;
    }*/
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getServicesProvidersByService(e.params);

    await failureOrSuccess.fold((failure) async {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      // items?[e.index].reletedServicesProviders = success.data?.result;

      // Navigate to Providers screen
      List<RelationItem>? items = state.subRelations;

      final value = await NavigationService.navigatorKey.currentState
          ?.pushNamed(EtmamRoutesNames.serviceTypesList,
              arguments: ProviderRelationPageParams(
                  serviceProviders: success.data!.result!,
                  selectedProviderId:
                      items?[e.index].selectedServiceProvider?.id));

      if (value != null) {
        items?[e.index].selectedServiceProvider = value as ServiceItems;
        emitter(
            state.copyWith(status: BlocStatus.success, subRelations: items));
      } else {
        emitter(state.copyWith(
          status: BlocStatus.success,
        ));
      }

      //  NavigationService.pushNamed(
      //     routeName: RouteName.providersByService, args: success.data!.result!);
    });
  }
}
