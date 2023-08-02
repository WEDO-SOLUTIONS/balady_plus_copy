import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

part 'cr_step2_activity_data_state.dart';

class CrStep2ActivityDataCubit extends Cubit<CrStep2ActivityDataState> {
  final GetSubActivities _getSubActivities;

  CrStep2ActivityDataCubit()
      : _getSubActivities = GetSubActivities(repository: sl()),
        super(const CrStep2ActivityDataState());

  void onSelectIsicActivity(DropDownItem isicActivity) async {
    emit(state.copyWith(
        selectedIsicActivity: isicActivity,
        subActivitiesStatus: BlocStatus.loading));

    final response = await _getSubActivities(isicActivity.id ?? '');
    response.fold(
        (failure) => emit(state.copyWith(
              subActivitiesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )),
        (success) {
          emit(state.copyWith(
            subActivitiesStatus: BlocStatus.success,
            subActivities: List.from(success)));
        });
  }

  void onSelectSubActivity(DropDownItem subActivity) =>
      emit(state.copyWith(selectedSubActivity: subActivity));
}
