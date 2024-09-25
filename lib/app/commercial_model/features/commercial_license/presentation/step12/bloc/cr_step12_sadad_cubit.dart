import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../domain/use_cases/cr_caluclate_fees.dart';

part 'cr_step12_sadad_state.dart';

class CrStep12SadadCubit extends Cubit<CrStep12SadadState> {
  final CrCalculateFees _calculateFees;

  CrStep12SadadCubit()
      : _calculateFees = CrCalculateFees(repository: sl()),
        super(const CrStep12SadadState()) {
    init();
  }

  void init() {
    emit(state.copyWith(status: BlocStatus.loading));

    int minYears =
        sl<CommercialLicenseBloc>().state.locationResponse?.minYears ?? 0;
    int maxYears =
        sl<CommercialLicenseBloc>().state.locationResponse?.maxYears ?? 0;

    List<String> list = [];

    for (int i = minYears; i <= maxYears; i++) {
      list.add(i.toString());
    }

    emit(state.copyWith(period: list, status: BlocStatus.success));
  }

  void onSelectSaddadYear(String year) async {
    emit(state.copyWith(selectedPeriod: year));
  }

  void calculate() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _calculateFees(CrCalculateFeesRequest(
        requestId: requestId,
        sadadPeriod: int.tryParse(state.selectedPeriod ?? "")));
    response.fold((failure) {
      //  sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));

      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));

      sl<CommercialLicenseBloc>().updateCalculatorData(
          crCalculateFeesResponse: success,
          selectedPeriod: state.selectedPeriod);
      emit(state.copyWith(status: BlocStatus.success));
    });
  }
}
