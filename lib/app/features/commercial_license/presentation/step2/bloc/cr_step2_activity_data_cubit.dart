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

part 'cr_step2_activity_data_state.dart';

class CrStep2ActivityDataCubit extends Cubit<CrStep2ActivityDataState> {
  final GetSubActivities _getSubActivities;
  final GetAccommodationTypes _getAccommodationTypes;
  final GetSubActivityDetails _getSubActivityDetails;
  final SaveActivityDetails _saveActivityDetails;

  CrStep2ActivityDataCubit()
      : _getSubActivities = GetSubActivities(repository: sl()),
        _getAccommodationTypes = GetAccommodationTypes(repository: sl()),
        _getSubActivityDetails = GetSubActivityDetails(repository: sl()),
        _saveActivityDetails = SaveActivityDetails(repository: sl()),
        super(const CrStep2ActivityDataState());

  void getSubActivityDetails(SubActivityEntity subActivity) async {
    emit(state.copyWith(subActivityDetailsStatus: BlocStatus.loading));
    final response =
        await _getSubActivityDetails(subActivity.activityId.toString() ?? '');
    response.fold(
        (failure) => emit(state.copyWith(
              subActivityDetailsStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          selectedSubActivity: Nullable(subActivity),
          subActivityDetailsStatus: BlocStatus.success,
          subActivityDetails: success.data?.result));

      print("STATE ${state.selectedSubActivity}");
      print("STATE ${success.data?.result}");

      BottomSheetDialog.showDraggableSheet(
          NavigationService.navigatorKey.currentContext!,
          child: CrStep2ConditionsPage(
            activityTerms: success.data?.result?.activityTerms,
          ));
    });
  }

  void onSelectIsicActivity(IsicActivity isicActivity) async {
    emit(state.copyWith(
        selectedIsicActivity: isicActivity,
        selectedSubActivity: Nullable(null),
        subActivitiesStatus: BlocStatus.loading));
    final response = await _getSubActivities(isicActivity.id ?? '');
    response.fold(
        (failure) => emit(state.copyWith(
              subActivitiesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          subActivitiesStatus: BlocStatus.success,
          subActivities: List.from(success)));
    });
  }

  void getAccommodationTypes() async {
    emit(state.copyWith(accommodationTypesStatus: BlocStatus.loading));
    final response = await _getAccommodationTypes(NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
              accommodationTypesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          accommodationTypesStatus: BlocStatus.success,
          accommodationTypes: List.from(success)));
    });
  }

  void onSelectSubActivity(SubActivityEntity subActivity) async {
    print("onSelectSubActivity $subActivity");
    getSubActivityDetails(subActivity);
  }

  void onAccommodationTypes(DropDownItem accommodationTypes) =>
      emit(state.copyWith(selectedAccommodationType: accommodationTypes));

  void updateArea(double? area) {
    emit(state.copyWith(totalArea: area));
  }

  void updateWorkerType(WorkersTypes type) {
    print(type);
    emit(state.copyWith(workerType: type));
  }

  void save() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading));
    final response = await _saveActivityDetails(SubmitActivityDetailRequest(
        requestId: requestId,
        workerTypeId: state.workerType!.index,
        area: state.totalArea ?? 0,
        detailedActivityId: state.selectedSubActivity!.activityId));

    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      emit(state.copyWith(status: BlocStatus.success));
    });
  }
}
