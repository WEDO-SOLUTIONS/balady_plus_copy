import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../commercial_license_exports.dart';

part 'cr_step1_applicant_data_state.dart';

class CrStep1ApplicantDataCubit extends Cubit<CrStep1ApplicantDataState> {
  final GetRecordInfo _getRecordInfo;

  CrStep1ApplicantDataCubit()
      : _getRecordInfo = GetRecordInfo(repository: sl()),
        super(const CrStep1ApplicantDataState());

  void getRecordInfo() async {
    emit(state.copyWith(recordStatus: BlocStatus.loading));
    final response = await _getRecordInfo("1010709880");

    /// TODO: UnComment below line
    // final response = await _getRecordInfo(
    //     CommonProperties.selectedDelegator?.crNumber ?? "");
    response.fold(
        (failure) => emit(state.copyWith(
              recordStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )),
        (success) => emit(state.copyWith(
            recordStatus: BlocStatus.success,
            recordInfo: success.data?.result)));
  }
}
