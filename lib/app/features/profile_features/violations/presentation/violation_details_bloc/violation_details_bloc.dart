import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../vd/vd_exports.dart';
import '../../violations_exports.dart';
part 'violation_details_event.dart';

part 'violation_details_state.dart';

class ViolationDetailsBloc
    extends Bloc<ViolationDetailsEvent, ViolationDetailsState> {
  final GetViolationDetails _getViolationDetails;
  final GetGISData _getGisData;

  ViolationDetailsBloc()
      : _getViolationDetails = GetViolationDetails(repository: sl()),
       _getGisData = GetGISData(repository: sl()),
        super(const ViolationDetailsState()) {
    on<ViolationDetailsEvent>((event, emit) {});

    on<GetViolationDetailsEvent>(_getViolationDetailsHandler);

    on<GetGisLocationInfoEvent>(_getGisDataInfoHandler);

    add(GetGisLocationInfoEvent());

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

    var failureOrSuccess = await _getViolationDetails(e.params);

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
}
