import '/app/core/dependency_injection/injection_container.dart';
import '/app/core/errors/failures.dart';
import '/app/core/services/services_exports.dart';
import '/app/core/utils/constants/route_names.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/fees_calculator/domain/entities/fees_calculator_request.dart';
import '/app/features/fees_calculator/domain/use_cases/calculate_fees.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/permits_activites_response.dart';
import '/app/features/select_activity/domain/use_cases/get_activites.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../select_activity/domain/entities/addetional_activites_response.dart';

part 'calculator_event.dart';

part 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  final GetActivitesUc _getActivites;
  final ActivityDetailsPageParams args;
  final CalculateFeesUC calculateFees;
  CalculatorBloc({required this.args})
      : _getActivites = GetActivitesUc(repository: sl()),
        calculateFees = CalculateFeesUC(repository: sl()),
        super(CalculatorState(
            totalArea: args.area.toString(),
            addetionalActivitesResponse: args.addetionalActivites,
            permits: args.permits)) {
    on<ChangeAddetionalActivityEvent>(changeAddetionalActivityArea);
    on<ChangeCleanOptionEvent>(changeCleanOptions);
    on<AddBoardnEvent>(addBoardHandler);
    on<CalculateEvent>(calculateHandler);
    on<ChangeLicenseYears>(changeLicenseYearsHandler);
    on<DeleteAddetionalActivityItemEvent>(
        DeleteAddetionalActivityItemEventHandler);

    on<DeletePermitItemEvent>(DeletePermitItemHandler);

    on<ChangePermitWidthEvent>(changePermitWidth);
    on<ChangePermitHeightEvent>(ChangePermitHeight);

    on<ChangePermitDaysEvent>(changePermitDays);
    on<ChangePermitNoOfVeichlesEvent>(changePermitNoOfVeichles);
  }

  void changePermitNoOfVeichles(
      ChangePermitNoOfVeichlesEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<PermitItem> addetionalActivitesResponse = state.permits ?? [];
    addetionalActivitesResponse[event.index].nonFoodVehicleCount =
        int.tryParse(event.data);
    emit(state.copyWith(
        status: BlocStatus.success, permits: addetionalActivitesResponse));
  }

  void changePermitDays(ChangePermitDaysEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<PermitItem> addetionalActivitesResponse = state.permits ?? [];
    addetionalActivitesResponse[event.index].days = int.tryParse(event.data);
    emit(state.copyWith(
        status: BlocStatus.success, permits: addetionalActivitesResponse));
  }

  void ChangePermitHeight(ChangePermitHeightEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<PermitItem> addetionalActivitesResponse = state.permits ?? [];
    addetionalActivitesResponse[event.index].length =
        double.tryParse(event.data);
    emit(state.copyWith(
        status: BlocStatus.success, permits: addetionalActivitesResponse));
  }

  void changePermitWidth(ChangePermitWidthEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<PermitItem> addetionalActivitesResponse = state.permits ?? [];
    addetionalActivitesResponse[event.index].width =
        double.tryParse(event.data);
    emit(state.copyWith(
        status: BlocStatus.success, permits: addetionalActivitesResponse));
  }

  void DeletePermitItemHandler(
      DeletePermitItemEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<PermitItem> addetionalActivitesResponse = state.permits ?? [];
    addetionalActivitesResponse.removeAt(event.index);
    emit(state.copyWith(
        status: BlocStatus.success, permits: addetionalActivitesResponse));
  }

  void DeleteAddetionalActivityItemEventHandler(
      DeleteAddetionalActivityItemEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<AddetionalActivityItem> addetionalActivitesResponse =
        state.addetionalActivitesResponse ?? [];
    addetionalActivitesResponse.removeAt(event.index);
    emit(state.copyWith(
        status: BlocStatus.success,
        addetionalActivitesResponse: addetionalActivitesResponse));
  }

  void changeAddetionalActivityArea(
      ChangeAddetionalActivityEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<AddetionalActivityItem> addetionalActivitesResponse =
        state.addetionalActivitesResponse ?? [];
    addetionalActivitesResponse[event.index].area = double.tryParse(event.area);
    emit(state.copyWith(
        status: BlocStatus.success,
        addetionalActivitesResponse: addetionalActivitesResponse));
  }

  void changeCleanOptions(ChangeCleanOptionEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(status: BlocStatus.success, cleanOption: event.item));
  }

  void changeLicenseYearsHandler(ChangeLicenseYears event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(
        state.copyWith(status: BlocStatus.success, selectedPeriod: event.item));
  }

  void addBoardHandler(AddBoardnEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    List<LookUpItem> boards = state.boards ?? [];

    boards.add(event.item.copyWith(area: event.area));

    emit(state.copyWith(status: BlocStatus.success, boards: boards));
  }

  void calculateHandler(CalculateEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    /* List<int> activityIds = [args.activityId!.id];

    args.addetionalActivites?.forEach((e) {
      activityIds.add(e.activityId);
    });*/

    final failureOrSuccess = await calculateFees(FeesCalculatorRequest(
        municipalityGisCode: args.gisData?.municipalityuniquecode,
        longitude: args.gisRequest?.lon.toString(),
        latitude: args.gisRequest?.lat.toString(),
        activityId: args.activityId?.id,
        licensePeriod: state.selectedPeriod?.id,
        shopArea: args.area,
        cleanOption: state.cleanOption?.idStr,
        boards: state.boards
            ?.map(
                (x) => Board(area: double.tryParse(x.area ?? ""), typeId: x.id))
            .toList()));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(status: BlocStatus.closeLoading));
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        NavigationService.navigatorKey.currentState!
            .pushNamed(RouteName.calculatorResultsPage, arguments: success);
      },
    );
  }
}
