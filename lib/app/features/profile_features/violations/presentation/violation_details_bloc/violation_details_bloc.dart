import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../violations_exports.dart';
part 'violation_details_event.dart';

part 'violation_details_state.dart';

class ViolationDetailsBloc
    extends Bloc<ViolationDetailsEvent, ViolationDetailsState> {
  final GetViolationDetails _getViolationDetails;

  ViolationDetailsBloc()
      : _getViolationDetails = GetViolationDetails(repository: sl()),
        super(const ViolationDetailsState()) {
    on<ViolationDetailsEvent>((event, emit) {});

    on<GetViolationDetailsEvent>(_getViolationDetailsHandler);
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
