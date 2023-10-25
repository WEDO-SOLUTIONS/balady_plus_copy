import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

part 'cr_step12_calculator_state.dart';

class CrStep2ActivityDataCubit extends Cubit<CrStep2ActivityDataState> {
  final GetSubActivities _getSubActivities;

  CrStep2ActivityDataCubit()
      : _getSubActivities = GetSubActivities(repository: sl()),
        super(const CrStep2ActivityDataState());

  void onSelectSaddadYear(IsicActivity isicActivity) async {}

  /*void calculate() async {
    print("HHH");
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;
    print("HHH $requestId");

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _saveActivityDetails(SubmitActivityDetailRequest(
        requestId: requestId,
        workerTypeId: state.workerType!.index,
        area: state.totalArea ?? 0,
        detailedActivityId: state.selectedSubActivity!.id!));
    print("GGG");
    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      emit(state.copyWith(status: BlocStatus.success));
    });
  }*/
}
