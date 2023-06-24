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
import '../../domain/entities/transaction_details.dart';
import '../../domain/use_cases/get_objection_details.dart';
import '../../domain/use_cases/get_transaction_details.dart';

part 'transaction_details_event.dart';

part 'transaction_details_state.dart';

class TransactionDetailsBloc
    extends Bloc<TransactionDetailsEvent, TransactionDetailsState> {
  final GetObjectionDetails _getObjectionDetails;
  final GetTransactionDetails _getTransactionDetails;
  final GetGISData _getGisData;

  TransactionDetailsBloc(
      {required GetObjectionDetails getObjectionDetails,
      required GetTransactionDetails getTransactionDetails,
      TransactionDetails? transactionDetails})
      : _getObjectionDetails = getObjectionDetails,
        _getTransactionDetails = getTransactionDetails,
        _getGisData = GetGISData(repository: sl()),
        super(TransactionDetailsState(details: transactionDetails)) {
    on<TransactionDetailsEvent>((event, emit) {});
    on<GetTransactionDetailsEvent>(_getObjectionDetailsHandler);
    on<GetGisLocationInfoEvent>(_getGisDataInfoHandler);

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

  Future<void> _getObjectionDetailsHandler(
      GetTransactionDetailsEvent e, Emitter emitter) async {
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
        errorMessage: "",
      ));

      NavigationService.navigatorKey.currentState!.pushNamed(
        RouteName.objectionsDetailsPage,
        arguments: success,
      );
    });
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
