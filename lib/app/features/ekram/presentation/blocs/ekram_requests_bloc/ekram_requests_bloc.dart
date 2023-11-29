import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_requests_params.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_deceased_driver_request_details.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_deceased_transport_request_details.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_locations.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_status.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/dialogs/filter_dialog.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/cemetry_requests/cemetry_request_item.dart';
import '../../../domain/use_cases/get_cemetry_request_details.dart';
import '../../../domain/use_cases/get_cemetry_requests.dart';

part 'ekram_requests_event.dart';

part 'ekram_requests_state.dart';

class EkramRequestsBloc extends Bloc<EkramRequestsEvent, EkramRequestsState> {
  final GetDeceasedTransportRequests _getDeceasedTransportRequests;
  final GetDeceasedTransportRequestDetails _getDeceasedTransportRequestDetails;
  final GetDeceasedDriverRequestDetails _getDeceasedDriverRequestDetails;
  final GetLookUp _getLookUp;
  final GetStatus _getStatus;
  final GetLocations _getLocations;
  final GetCemetryRequests _getCemetryRequests;
  final GetCemetryRequestDetails _getCemetryRequestDetails;

  EkramRequestsBloc(
      {required GetDeceasedTransportRequests getDeceasedTransportRequests,
      required GetDeceasedTransportRequestDetails
          getDeceasedTransportRequestDetails,
      required GetDeceasedDriverRequestDetails getDeceasedDriverRequestDetails,
      required bool isDriver,
      required GetLookUp getLookUp,
      required GetStatus getStatus,
      required GetLocations getLocations})
      : _getDeceasedTransportRequests = getDeceasedTransportRequests,
        _getDeceasedTransportRequestDetails =
            getDeceasedTransportRequestDetails,
        _getDeceasedDriverRequestDetails = getDeceasedDriverRequestDetails,
        _getLookUp = getLookUp,
        _getStatus = getStatus,
        _getLocations = getLocations,
        _getCemetryRequests = GetCemetryRequests(repository: sl()),
        _getCemetryRequestDetails = GetCemetryRequestDetails(repository: sl()),
        super(EkramRequestsState(isDriver: isDriver)) {
    on<EkramRequestsEvent>((event, emit) {
      emit(state);
    });
    on<GetDeceasedTransportRequestsEvent>(_getDeceasedTransportRequestsHandler);

    on<GetDeceasedTransportRequestDetailsEvent>(
        _getDeceasedTransportRequestDetailsHandler);

    on<GetCemetryRequestsEvent>(_getCemetryRequestsHandler);

    on<GetCemetryRequestDetailsEvent>(_getCemetryRequestDetailsHandler);

    on<GetMoreDeceasedTransportRequestsEvent>(_loadMoreHandler);
    on<GetMoreCemetryRequestsEvent>(_loadMoreCemetryRequestsHandler);
    on<ShowFilterEvent>(_showFilterHandler);
    //add(GetDeceasedTransportRequestsEvent(isDriver: isDriver));
    // add(GetCemetryRequestsEvent());
  }

  Future<void> _loadMoreHandler(
      GetMoreDeceasedTransportRequestsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess = await _getDeceasedTransportRequests(
        GetRequestsParams(
            isDriver: e.isDriver, page: state.currentPage + 1, size: 10));

    failureOrSuccess.fold((failure) {
      String? errorCode = (failure as ServerFailure).errorCode;
      BlocStatus status = BlocStatus.failure;
      if (errorCode == "2") {
        status = BlocStatus.success;
      }

      emitter(state.copyWith(
        status: status,
        errorMessage: status == BlocStatus.failure
            ? (failure as ServerFailure).errorMessage
            : "",
      ));
    }, (success) {
      List<TransportRequestItem>? newDeceasedRequestItems =
          success.data?.result?.items;
      List<TransportRequestItem>? oldDeceasedRequestItems =
          state.deceasedRequestItems;
      if (newDeceasedRequestItems != null)
        oldDeceasedRequestItems?.addAll(newDeceasedRequestItems);
      emitter(state.copyWith(
        status: BlocStatus.success,
        deceasedRequestItems: oldDeceasedRequestItems,
        currentPage: state.currentPage + 1,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getDeceasedTransportRequestsHandler(
      GetDeceasedTransportRequestsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.loadingShimmer,
        currentPage: 0,
        searchBy: e.text,
        clearFilters: e.clear));

    final failureOrSuccess = await _getDeceasedTransportRequests(e.clear == true
        ? GetRequestsParams(
            isDriver: e.isDriver,
            page: 0,
            size: 10,
            text: e.text ?? state.searchBy,
          )
        : GetRequestsParams(
            isDriver: e.isDriver,
            page: 0,
            size: 10,
            text: e.text ?? state.searchBy,
            isMultiCity: e.isMultiCity ?? state.isMultiCity(),
            transportLocationStatusId:
                e.transportLocationStatusId ?? state.locationFilterItem?.id,
            deceasedTransportRequestStatusId:
                e.requestStatusId ?? state.requestStatusFilterItem?.id));

    failureOrSuccess.fold((failure) {
      String? errorCode = (failure as ServerFailure).errorCode;
      BlocStatus status = BlocStatus.retry;
      if (errorCode == "2") {
        status = BlocStatus.success;
      }

      emitter(state.copyWith(
        status: status,
        deceasedRequestItems: status == BlocStatus.success ? [] : null,
        totalItemCount: 0,
        errorMessage: "",
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        deceasedRequestItems: success.data?.result?.items,
        totalItemCount: success.data?.result?.totalItemCount,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getDeceasedTransportRequestDetailsHandler(
      GetDeceasedTransportRequestDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess;
    if (e.isDriver) {
      failureOrSuccess = await _getDeceasedDriverRequestDetails(e.requestId);
    } else {
      failureOrSuccess = await _getDeceasedTransportRequestDetails(e.requestId);
    }
    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));
      if (e.isDriver) {
        final result = await NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.ekramTransportationDetailsScreen,
                arguments: success.data?.result);
        print(result);
        if (result == true) {
          add(GetDeceasedTransportRequestsEvent(isDriver: state.isDriver!));
        }
      } else {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.driverEkramTransportationDetailsScreen,
            arguments: success.data?.result);
      }
    });
  }

  Future<void> _showFilterHandler(ShowFilterEvent e, Emitter emitter) async {
    List<LookUpItem> filters = state.transferStatusList ?? [];

    List<LookUpItem> requestStatusListFilters = state.requestStatusList ?? [];
    List<LookUpItem> locationsListFilters = state.locationsList ?? [];

    if (requestStatusListFilters.isEmpty) {
      emitter(state.copyWith(
        status: BlocStatus.loading,
        errorMessage: "",
      ));
      final failureOrSuccess = await _getStatus(0);
      requestStatusListFilters = failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
        return [];
      }, (success) {
        emitter(state.copyWith(
          status: BlocStatus.success,
          requestStatusList: success.data?.result,
          errorMessage: "",
        ));
        return success.data?.result ?? [];
      });
    }
    /*if (locationsListFilters.isEmpty) {
      emitter(state.copyWith(
        status: BlocStatus.loading,
        errorMessage: "",
      ));
      final failureOrSuccess = await _getLocations(0);
      locationsListFilters = failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
        return [];
      }, (success) {
        emitter(state.copyWith(
          status: BlocStatus.success,
          locationsList: success.data?.result,
          errorMessage: "",
        ));
        return success.data?.result ?? [];
      });
    }*/

    await CustomPopUpsWidgets.showBottomSheet(
      NavigationService.navigatorKey.currentContext!,
      child: FilterDialog(
        onClear: () {
          add(GetDeceasedTransportRequestsEvent(
              isDriver: state.isDriver!, clear: true));
        },
        // cityCurrentSelection: state.cityFilterItem,
        //  deathCurrentSelection: state.locationFilterItem,
        requestCurrentSelection: state.requestStatusFilterItem,
        /* citiesItems: [
          LookUpItem(id: 0, name: trans("inside_city")),
          LookUpItem(id: 1, name: trans("outside_city"))
        ],*/
        requestStatusItems: requestStatusListFilters,
        // deathTransferItems:
        //     state.isDriver == true ? locationsListFilters : null,
        onFilter: (List<LookUpItem?>? items) {
          emitter(state.copyWith(
              requestStatusFilterItem: items?[0],
              locationFilterItem: items?[1],
              cityFilterItem: items?[2]));
          add(GetDeceasedTransportRequestsEvent(
              isDriver: state.isDriver!,
              requestStatusId: items?[0]?.id,
              transportLocationStatusId: items?[1]?.id,
              isMultiCity: items?[2]?.id != null
                  ? (items?[2]?.id == 0 ? false : true)
                  : null));
        },
      ),
    );
  }

  Future<void> _getCemetryRequestsHandler(
      GetCemetryRequestsEvent event, Emitter emitter) async {
    emitter(state.copyWith(
      cemetryListStatus: BlocStatus.loadingShimmer,
      currentPage: 0,
    ));

    final failureOrSuccess = await _getCemetryRequests(
        GetRequestsParams(page: 0, size: 10, isDriver: false));

    failureOrSuccess.fold((failure) {
      String? errorCode = (failure as ServerFailure).errorCode;
      BlocStatus status = BlocStatus.retry;
      if (errorCode == "2") {
        status = BlocStatus.success;
      }

      emitter(state.copyWith(
        cemetryListStatus: status,
        cemetryRequestItems: status == BlocStatus.success ? [] : null,
        // totalItemCount: 0,
        errorMessage: "",
      ));
    }, (success) {
      emitter(state.copyWith(
        cemetryListStatus: BlocStatus.success,
        cemetryRequestItems: success.data?.result?.items,
        // totalItemCount: success.data?.result?.totalItemCount,
        errorMessage: "",
      ));
    });
  }

  Future<void> _loadMoreCemetryRequestsHandler(
      GetMoreCemetryRequestsEvent e, Emitter emitter) async {
    emitter(state.copyWith(cemetryListStatus: BlocStatus.loadMore));

    final failureOrSuccess = await _getCemetryRequests(GetRequestsParams(
        isDriver: true, page: state.cemetryCurrentPage + 1, size: 10));

    failureOrSuccess.fold((failure) {
      String? errorCode = (failure as ServerFailure).errorCode;
      BlocStatus status = BlocStatus.failure;
      if (errorCode == "2") {
        status = BlocStatus.success;
      }

      emitter(state.copyWith(
        cemetryListStatus: status,
        errorMessage: status == BlocStatus.failure
            ? (failure as ServerFailure).errorMessage
            : "",
      ));
    }, (success) {
      List<CemetryRequestItem>? newDeceasedRequestItems =
          success.data?.result?.items;
      List<CemetryRequestItem>? oldDeceasedRequestItems =
          state.cemetryRequestItems;
      if (newDeceasedRequestItems != null)
        oldDeceasedRequestItems?.addAll(newDeceasedRequestItems);
      emitter(state.copyWith(
        cemetryListStatus: BlocStatus.success,
        cemetryRequestItems: oldDeceasedRequestItems,
        cemetryCurrentPage: state.cemetryCurrentPage + 1,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getCemetryRequestDetailsHandler(
      GetCemetryRequestDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess;

    failureOrSuccess = await _getCemetryRequestDetails(e.requestId);

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      NavigationService.navigatorKey.currentState!.pushNamed(
          RouteName.EkramCemetryDetailsPage,
          arguments: success.data?.result);
    });
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
