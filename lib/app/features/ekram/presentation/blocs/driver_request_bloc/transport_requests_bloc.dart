import 'package:balady_plus/app/features/ekram/domain/entities/get_requests_params.dart';
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
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/cemetry_requests/cemetry_request_item.dart';

part 'transport_requests_event.dart';

part 'transport_requests_state.dart';

class TransportRequestsBloc
    extends Bloc<EkramRequestsEvent, EkramRequestsState> {
  final GetDeceasedTransportRequests _getDeceasedTransportRequests;
  final GetStatus _getStatus;

  TransportRequestsBloc({
    required GetDeceasedTransportRequests getDeceasedTransportRequests,
    required bool isDriver,
  })  : _getDeceasedTransportRequests = getDeceasedTransportRequests,
        _getStatus = sl<GetStatus>(),
        super(EkramRequestsState(isDriver: isDriver)) {
    on<EkramRequestsEvent>((event, emit) {
      emit(state);
    });

    on<GetDeceasedTransportRequestsEvent>(_getRequestsHandler);
    on<GetMoreDeceasedTransportRequestsEvent>(_loadMoreHandler);

    // Stop used this event
    // on<ShowFilterEvent>(_showFilterHandler);
  }

  Future<void> _loadMoreHandler(
      GetMoreDeceasedTransportRequestsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loadMore));

    final failureOrSuccess = await _getDeceasedTransportRequests(
        GetRequestsParams(
            page: state.currentPage + 1, size: 10, isDriver: state.isDriver));

    failureOrSuccess.fold((failure) {
      String? errorCode = (failure as ServerFailure).errorCode;
      BlocStatus status = BlocStatus.failure;
      if (errorCode == "2") {
        status = BlocStatus.success;
      }

      emitter(state.copyWith(
        status: status,
        errorMessage:
            status == BlocStatus.failure ? (failure).errorMessage : "",
      ));
    }, (success) {
      List<TransportRequestItemModel>? newDeceasedRequestItems =
          success.data?.result?.items;
      List<TransportRequestItemModel>? oldDeceasedRequestItems =
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

  Future<void> _getRequestsHandler(
      GetDeceasedTransportRequestsEvent e, Emitter emitter) async {
    emitter(
      state.copyWith(
        status: BlocStatus.loadingShimmer,
        currentPage: 0,
        searchBy: e.text,
        clearFilters: e.clear,
      ),
    );

    final failureOrSuccess = await _getDeceasedTransportRequests(
      e.clear == true
          ? GetRequestsParams(
              page: 0,
              size: 10,
              isDriver: state.isDriver,
              text: e.text ?? state.searchBy,
            )
          : GetRequestsParams(
              page: 0,
              size: 10,
              isDriver: state.isDriver,
              text: e.text ?? state.searchBy,
              isMultiCity: e.isMultiCity ?? state.isMultiCity(),
              transportLocationStatusId:
                  e.transportLocationStatusId ?? state.locationFilterItem?.id,
              deceasedTransportRequestStatusId:
                  e.requestStatusId ?? state.requestStatusFilterItem?.id,
            ),
    );

    failureOrSuccess.fold((failure) {
      BlocStatus status = BlocStatus.retry;
      emitter(state.copyWith(
        status: status,
        deceasedRequestItems: status == BlocStatus.success ? [] : null,
        totalItemCount: 0,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      CommonFunctions.showError(failure.errorMessage);
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        deceasedRequestItems: success.data?.result?.items,
        totalItemCount: success.data?.result?.totalItemCount,
        errorMessage: "",
      ));
    });
  }

  // Future<void> _showFilterHandler(ShowFilterEvent e, Emitter emitter) async {
  //   // List<LookUpItem> filters = state.transferStatusList ?? [];
  //   List<LookUpItem> requestStatusListFilters = state.requestStatusList ?? [];
  //   // List<LookUpItem> locationsListFilters = state.locationsList ?? [];
  //
  //   if (requestStatusListFilters.isEmpty) {
  //     emitter(state.copyWith(
  //       status: BlocStatus.loading,
  //       errorMessage: "",
  //     ));
  //     final failureOrSuccess = await _getStatus(0);
  //     requestStatusListFilters = failureOrSuccess.fold((failure) {
  //       emitter(state.copyWith(
  //         status: BlocStatus.failure,
  //         errorMessage: (failure as ServerFailure).errorMessage,
  //       ));
  //       return [];
  //     }, (success) {
  //       emitter(state.copyWith(
  //         status: BlocStatus.success,
  //         requestStatusList: success.data?.result,
  //         errorMessage: "",
  //       ));
  //       return success.data?.result ?? [];
  //     });
  //   }
  //   /*if (locationsListFilters.isEmpty) {
  //     emitter(state.copyWith(
  //       status: BlocStatus.loading,
  //       errorMessage: "",
  //     ));
  //     final failureOrSuccess = await _getLocations(0);
  //     locationsListFilters = failureOrSuccess.fold((failure) {
  //       emitter(state.copyWith(
  //         status: BlocStatus.failure,
  //         errorMessage: (failure as ServerFailure).errorMessage,
  //       ));
  //       return [];
  //     }, (success) {
  //       emitter(state.copyWith(
  //         status: BlocStatus.success,
  //         locationsList: success.data?.result,
  //         errorMessage: "",
  //       ));
  //       return success.data?.result ?? [];
  //     });
  //   }*/
  //
  //   await CustomPopUpsWidgets.showBottomSheet(
  //     NavigationService.navigatorKey.currentContext!,
  //     child: FilterDialog(
  //       onClear: () {
  //         add(GetDeceasedTransportRequestsEvent(
  //             isDriver: state.isDriver!, clear: true));
  //       },
  //       // cityCurrentSelection: state.cityFilterItem,
  //       //  deathCurrentSelection: state.locationFilterItem,
  //       requestCurrentSelection: state.requestStatusFilterItem,
  //       /* citiesItems: [
  //         LookUpItem(id: 0, name: trans("inside_city")),
  //         LookUpItem(id: 1, name: trans("outside_city"))
  //       ],*/
  //       requestStatusItems: requestStatusListFilters,
  //       // deathTransferItems:
  //       //     state.isDriver == true ? locationsListFilters : null,
  //       onFilter: (List<LookUpItem?>? items) {
  //         emitter(
  //           state.copyWith(
  //             requestStatusFilterItem: items?[0],
  //             locationFilterItem: items?[1],
  //             cityFilterItem: items?[2],
  //           ),
  //         );
  //         add(
  //           GetDeceasedTransportRequestsEvent(
  //             isDriver: state.isDriver!,
  //             requestStatusId: items?[0]?.id,
  //             transportLocationStatusId: items?[1]?.id,
  //             isMultiCity: items?[2]?.id != null
  //                 ? (items?[2]?.id == 0 ? false : true)
  //                 : null,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
