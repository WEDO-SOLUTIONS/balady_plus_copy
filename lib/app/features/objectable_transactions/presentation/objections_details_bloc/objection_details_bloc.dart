import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/remote_config.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../objections/domain/entities/objection_details.dart';
import '../../../objections/domain/use_cases/cancel_objection.dart';
import '../../../objections/domain/use_cases/get_objectable_permit.dart';
import '../../domain/entities/create_objection_page_params.dart';
import '../../domain/entities/transaction_details_params.dart';
import '../../domain/use_cases/get_objection_details.dart';
import '../../domain/use_cases/get_transaction_details.dart';

part 'objection_details_event.dart';

part 'objection_details_state.dart';

class ObjectionsDetailsBloc
    extends Bloc<ObjectionDetailsEvent, ObjectionDetailsState> {
  final GetObjectionDetails _getObjectionDetails;
  final GetTransactionDetails _getTransactionDetails;
  final CancelObjection cancelObjection;
  final GetObjectablePermit getObjectablePermit;

  ObjectionsDetailsBloc()
      : _getObjectionDetails = GetObjectionDetails(repository: sl()),
        _getTransactionDetails = GetTransactionDetails(repository: sl()),
        cancelObjection = CancelObjection(repository: sl()),
        getObjectablePermit = GetObjectablePermit(repository: sl()),
        super(ObjectionDetailsState()) {
    on<ObjectionDetailsEvent>((event, emit) {});

    on<GetObjectionDetailsEvent>(_getObjectionDetailsHandler);
    on<GetTransactionDetailsEvent>(_getTransactionsDetailsHandler);
    on<CancelObjectionEvent>(_cancelObjectionHandler);
    on<OpenObjectableDetails>(_openObjectableDetails);
  }

  Future<void> _openObjectableDetails(
      OpenObjectableDetails e, Emitter emitter) async {
    String? serviceTypeId = state.details?.serviceTypeId;
    String? hash = state.details?.requestSubmitterData?.objectedTransactionUrl
        ?.split("/")
        .lastOrNull;
    print(
        "SERViceType ${state.details?.requestSubmitterData?.objectedTransactionUrl}");

    if (serviceTypeId == "3" || serviceTypeId == "4") {
      add(GetTransactionDetailsEvent(
          params: TransactionDetailsParams(
        applicationId: state.details?.serviceGroupId ?? "13",
        id: state.details?.requestSubmitterData?.objectedTransactionId ?? "",
      )));
    } else if (state.details?.serviceGroupId == "1003") {
      print("YYY $serviceTypeId");
      if (serviceTypeId == "1") {
        print("III");
        emitter(state.copyWith(status: BlocStatus.loading));

        var failureOrSuccess = await getObjectablePermit(hash ?? "");

        await failureOrSuccess.fold((failure) {
          print(failure);

          emitter(state.copyWith(
            status: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        }, (success) async {
          print(success);
          if (success.isNotEmpty) {
            CommonFunctions.openBaladyWebView(success, isObjections: true);
          } else {
            CommonFunctions.openBaladyWebView(
                "${RemoteConfig.baladyBaseUrl}/dashboardclient/requests/details/${hash}",
                isObjections: true);
          }
          emitter(state.copyWith(
            status: BlocStatus.success,
            errorMessage: "",
          ));
        });
      } else if (serviceTypeId == "2") {
        CommonFunctions.openBaladyWebView(
            "${RemoteConfig.baladyBaseUrl}/dashboardclient/licenses/details/${hash}",
            isObjections: true);
      }
    } else if (state.details?.serviceGroupId == "1200") {
      var splitted = state.details?.requestSubmitterData?.objectedTransactionUrl
          ?.split("/requestType/");

      hash = splitted?[0].split("/").lastOrNull;
      var typeName = serviceTypeId == "1" ? 'requests' : "licenses";
      CommonFunctions.openBaladyWebView(RemoteConfig.baladyBaseUrl +
          "/dashboardclient/" +
          typeName +
          '/construction-details/' +
          (hash ?? "") +
          '/requestType/' +
          "1200");
    } else if (state.details?.serviceGroupId == "1100") {
      var splitted = state.details?.requestSubmitterData?.objectedTransactionUrl
          ?.split("/requestType/");

      hash = splitted?[0].split("/").lastOrNull;
      var typeName = serviceTypeId == "1" ? 'requests' : "licenses";
      CommonFunctions.openBaladyWebView(RemoteConfig.baladyBaseUrl +
          "/dashboardclient/" +
          typeName +
          '/construction-details/' +
          (hash ?? "") +
          '/requestType/' +
          "1100");
    }
  }

  Future<void> _cancelObjectionHandler(
      CancelObjectionEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess =
        await cancelObjection(state.details?.objectionRequestNumber ?? "");

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

      CommonFunctions.showSuccess("objctions_cancelled");
      add(GetObjectionDetailsEvent(
          params: state.details?.objectionRequestNumber ?? ""));
    });
  }

  Future<void> _getTransactionsDetailsHandler(
      GetTransactionDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess = await _getTransactionDetails(e.params);

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
          RouteName.transactionDetailsPage,
          arguments: CreateObjectionPageParams(details: success));
    });
  }

  Future<void> _getObjectionDetailsHandler(
      GetObjectionDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess = await _getObjectionDetails(e.params);

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        details: success,
        errorMessage: "",
      ));
    });
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
