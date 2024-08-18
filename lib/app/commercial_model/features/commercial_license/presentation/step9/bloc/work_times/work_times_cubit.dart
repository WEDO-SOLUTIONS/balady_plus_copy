import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import '../../../../commercial_license_exports.dart';
import '../../../../data/models/qr/apply_commercial_response_model.dart';
import '../../../../domain/use_cases/save_qr_worktimes_data.dart';

part 'work_times_state.dart';

class WorkTimesCubit extends Cubit<WorkTimesState> {
  final SaveQrWorkTimesData _saveQrWorkTimesData;

  WorkTimesCubit()
      : _saveQrWorkTimesData = SaveQrWorkTimesData(repository: sl()),
        super(const WorkTimesState());

  void onSelectedWorkTime(int index) {
    emit(state.copyWith(status: BlocStatus.loading));
    final workTimes = state.workingTimes;
    workTimes![index] = state.workingTimes![index].copyWith(
        isSelected: !(state.workingTimes![index].isSelected ?? false));

    emit(state.copyWith(workTimes: workTimes, status: BlocStatus.success));
  }

  void onAddPeriods(
      {required int index,
      required List<PeriodEntity> periods,
      required QRWorkTimes type}) {
    var ctx = NavigationService.navigatorKey.currentContext;
    emit(state.copyWith(status: BlocStatus.loading));

    var workTimes = state.workingTimes![index];

    if (type == QRWorkTimes.OPEN_24HOUR) {
      workTimes.openShiftOption = "OPEN_24HOUR";
      workTimes.firstFromTime = null;
      workTimes.firstToTime = null;
      workTimes.secondFromTime = null;
      workTimes.secondToTime = null;
    } else if (type == QRWorkTimes.SHIFTED) {
      workTimes.openShiftOption = "SHIFTED";
      if (periods.length == 1) {
        workTimes.firstFromTime =
            "${periods[0].from.hour}:${periods[0].from.minute}";
        workTimes.firstToTime = "${periods[0].to.hour}:${periods[0].to.minute}";
      }
      if (periods.length == 2) {
        workTimes.firstFromTime =
            "${periods[0].from.hour}:${periods[0].from.minute}";
        workTimes.firstToTime = "${periods[0].to.hour}:${periods[0].to.minute}";
        workTimes.secondFromTime =
            "${periods[1].from.hour}:${periods[1].from.minute}";
        workTimes.secondToTime =
            "${periods[1].to.hour}:${periods[1].to.minute}";
      }
    }

    List<WorkingTime> times = state.workingTimes ?? [];
    times[index] = workTimes;
    emit(state.copyWith(workTimes: times, status: BlocStatus.success));
  }

  void init() {
    if (state.workingTimes == null) {
      emit(state.copyWith(status: BlocStatus.loading));
      emit(state.copyWith(
          status: BlocStatus.success,
          workTimes: sl<CommercialLicenseBloc>()
              .state
              .applyCommercialResponse
              ?.workTimes
              ?.workingTimes));
    }
  }

  void save() async {
    int? requestId =
        sl<CommercialLicenseBloc>().state.applyCommercialResponse?.requestId;

    emit(state.copyWith(status: BlocStatus.loading));
    print("ddd");
    List<WorkingTime>? workingTimes = state.workingTimes?.map((e) {
      if (e.isSelected != true) {
        e.openShiftOption = "CLOSED";
      }
      if (e.openShiftOption == "CLOSED" || e.openShiftOption == "OPEN_24HOUR") {
        e.firstFromTime = null;
        e.firstToTime = null;
        e.secondFromTime = null;
        e.secondToTime = null;
      }
      return e;
    }).toList();
    print("gg");

    final failureOrSuccess = await _saveQrWorkTimesData(
        SaveWorkTimesRequest(requestId: requestId, workingTimes: workingTimes));

    failureOrSuccess.fold((l) {
      emit(
        state.copyWith(
            errorMessage: (l as ServerFailure).errorMessage,
            status: BlocStatus.failure),
      );
    }, (r) {
      emit(
        state.copyWith(errorMessage: "", status: BlocStatus.success),
      );
      sl<CommercialLicenseBloc>().add(const GoToNextPageEvent());
    });
  }
}
