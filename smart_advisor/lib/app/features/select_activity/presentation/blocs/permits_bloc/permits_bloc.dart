import '/app/features/home/home_exports.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/permit_request_params.dart';
import '/app/features/select_activity/domain/entities/permits_activites_response.dart';
import '/app/features/select_activity/domain/use_cases/get_permits.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart' show BlocStatus;

part 'permits_event.dart';

part 'permits_state.dart';

class PermitsBloc extends Bloc<PermitsEvent, PermitsState> {
  final ActivityDetailsPageParams args;

  final GetPermitsUc _getPermits;

  PermitsBloc({required this.args})
      : _getPermits = GetPermitsUc(repository: sl()),
        super(const PermitsState()) {
    ///
    on<GetPermitsEvent>((event, emit) async {
      emit(state.copyWith(permitsStatus: BlocStatus.loading));

      List<int> activityIds = [args.activityId!.id];

      args.addetionalActivites?.forEach((e) {
        activityIds.add(e.activityId);
      });

      final failureOrSuccess = await _getPermits(PermitRequestParams(
          activityIds: activityIds,
          latitude: args.gisRequest!.lat,
          longitude: args.gisRequest!.lon));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(permitsStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            permitsStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          List<PermitItem> p = [];
          for (int i = 0; i < success.length; i++) {
            success[i].order = i;
            p.add(success[i]);
          }
          emit(state.copyWith(
            permitsStatus: BlocStatus.success,
            permits: p,
          ));
        },
      );
    });

    on<TogglePermitEvent>(getZonesHandler);

    add(const GetPermitsEvent());
  }

  void getZonesHandler(TogglePermitEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<PermitItem> addetionalActivitesResponse = state.permits ?? [];

    bool isSelected =
        addetionalActivitesResponse[event.index].isSelected ?? false;
    addetionalActivitesResponse[event.index].isSelected = !isSelected;

    emit(state.copyWith(
        status: BlocStatus.success, permits: addetionalActivitesResponse));
  }
}
