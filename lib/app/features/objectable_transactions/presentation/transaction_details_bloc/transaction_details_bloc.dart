import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../vd/domain/entities/gis/gis_params.dart';
import '../../../vd/domain/entities/gis/gis_response.dart';
import '../../../vd/domain/use_cases/get_gis_data.dart';
import '../../domain/entities/create_objection_page_params.dart';
import '../../domain/entities/objectable_transaction_entity.dart';
import '../../domain/entities/transaction_details.dart';
import '../../domain/entities/validate_objection_params.dart';
import '../../domain/use_cases/get_objection_details.dart';
import '../../domain/use_cases/get_transaction_details.dart';
import '../../domain/use_cases/validate_objectable_transactions.dart';

part 'transaction_details_event.dart';

part 'transaction_details_state.dart';

class TransactionDetailsBloc
    extends Bloc<TransactionDetailsEvent, TransactionDetailsState> {
  final GetObjectionDetails _getObjectionDetails;
  final GetTransactionDetails _getTransactionDetails;
  final GetGISData _getGisData;
  final ValidateObjectableTransaction validateObjectableTransaction;

  TransactionDetailsBloc(
      {TransactionDetails? transactionDetails,
      ObjectableTransactionsEntity? item})
      : _getObjectionDetails = GetObjectionDetails(repository: sl()),
        _getTransactionDetails = GetTransactionDetails(repository: sl()),
        _getGisData = GetGISData(repository: sl()),
        validateObjectableTransaction =
            ValidateObjectableTransaction(repository: sl()),
        super(
            TransactionDetailsState(details: transactionDetails, item: item)) {
    on<TransactionDetailsEvent>((event, emit) {});
    // on<GetTransactionDetailsEvent>(_getObjectionDetailsHandler);
    on<GetGisLocationInfoEvent>(_getGisDataInfoHandler);
    on<ValidateObjectionDetailsTransactions>(_validateObjectableTransaction);
    add(GetGisLocationInfoEvent());
  }

  Future<void> _getGisDataInfoHandler(
      GetGisLocationInfoEvent e, Emitter emitter) async {
    double? x = double.tryParse(state.details?.coordinateY ?? "");
    double? y = double.tryParse(state.details?.coordinateX ?? "");

    if (x == null || y == null) return;
    emitter(state.copyWith(gisStatus: BlocStatus.loading));

    var failureOrSuccess = await _getGisData(GISParams(x: x, y: y));

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        gisStatus: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        gisStatus: BlocStatus.success,
        gisLocation: success,
        errorMessage: "",
      ));
    });
  }

  Future<void> _validateObjectableTransaction(
      ValidateObjectionDetailsTransactions e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess = await validateObjectableTransaction(
        ValidateObjectionParams(
            applicationId: state.item?.applicationId,
            transactionId: state.item?.transactionId));

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
      if (success)
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.createObjectionDetails,
            arguments: CreateObjectionPageParams(
                details: state.details, item: state.item));
    });
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
