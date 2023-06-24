import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../objections/domain/entities/objection_details.dart';
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

  ObjectionsDetailsBloc({ObjectionDetails? details})
      : _getObjectionDetails = GetObjectionDetails(repository: sl()),
        _getTransactionDetails = GetTransactionDetails(repository: sl()),
        super(ObjectionDetailsState(details: details)) {
    on<ObjectionDetailsEvent>((event, emit) {});

    on<GetObjectionDetailsEvent>(_getObjectionDetailsHandler);
    on<GetTransactionDetailsEvent>(_getTransactionsDetailsHandler);
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
        errorMessage: "",
      ));

      NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.objectionsDetailsPage, arguments: success);
    });
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
