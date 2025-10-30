import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/request_details_model.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../objectable_transactions/domain/entities/create_objection_page_params.dart';
import '../../../../objectable_transactions/domain/entities/validate_objection_params.dart';
import '../../../../objectable_transactions/domain/use_cases/validate_objectable_transactions.dart';
import '../../../../vd/vd_exports.dart';
import '../../domain/entities/violation_details_params.dart';
import '../../violations_exports.dart';

part 'violation_details_event.dart';

part 'violation_details_state.dart';

class ViolationDetailsBloc
    extends Bloc<ViolationDetailsEvent, ViolationDetailsState> {
  final GetViolationDetails _getViolationDetails;
  final GetGISData _getGisData;

  final ValidateObjectableTransaction validateObjectableTransaction;

  ViolationDetailsBloc({required ViolationsEntity? violationDetails})
      : _getViolationDetails = GetViolationDetails(repository: sl()),
        _getGisData = GetGISData(repository: sl()),
        validateObjectableTransaction =
            ValidateObjectableTransaction(repository: sl()),
        super(ViolationDetailsState(
          violationsEntity: violationDetails,
        )) {
    on<ViolationDetailsEvent>((event, emit) {});

    on<GetViolationDetailsEvent>(_getViolationDetailsHandler);

    on<GetGisLocationInfoEvent>(_getGisDataInfoHandler);

    on<ValidateObjectionDetailsTransactions>(_validateObjectableTransaction);
    add(const GetGisLocationInfoEvent());
  }

  Future<void> _getGisDataInfoHandler(
      GetGisLocationInfoEvent e, Emitter emitter) async {
    double? x = double.tryParse(state.details?.coordinateX ?? "");
    double? y = double.tryParse(state.details?.coordinateY ?? "");

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

  Future<void> _getViolationDetailsHandler(
      GetViolationDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess = await _getViolationDetails(ViolationDetailsParams(
        id: e.id,
        applicationId: e.applicationId,
        identityNumber:
            CommonProperties.selectedDelegator?.unifiedNationalNumber));

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage:
            failure is ServerFailure ? (failure).errorMessage : "noData".tr(),
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        details: success,
        errorMessage: "",
      ));
    });
  }

  Future<void> _validateObjectableTransaction(
      ValidateObjectionDetailsTransactions e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    var failureOrSuccess = await validateObjectableTransaction(
        ValidateObjectionParams(
            applicationId: state.violationsEntity?.applicationId,
            transactionId: state.violationsEntity?.violationNumber));

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
      if (success) {
        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.createObjectionDetails,
            arguments: CreateObjectionPageParams(
                details: state.details,
                item:
                    state.violationsEntity?.getObjectableTransactionsEntity()));
      }
    });
  }
}
