import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/activites_page_params.dart';
import '/app/features/select_activity/domain/entities/activity_request_params.dart';
import '/app/features/select_activity/domain/entities/isics_page_params.dart';
import '/app/features/select_activity/domain/use_cases/get_activites.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart' show BlocStatus;

part 'activites_event.dart';

part 'activites_state.dart';

class ActivitesBloc extends Bloc<ActivitesEvent, ActivitesState> {
  final GetActivitesUc _getActivites;
  final ActivitesPageParams args;

  ActivitesBloc({required this.args})
      : _getActivites = GetActivitesUc(repository: sl()),
        super(const ActivitesState()) {
    ///
    on<GetActivitesEvent>((event, emit) async {
      emit(state.copyWith(isicsStatus: BlocStatus.loading));

      final failureOrSuccess = await _getActivites(ActivityRequestParams(
        isicId: args.isic.id,
      ));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(isicsStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            isicsStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
            isicsStatus: BlocStatus.success,
            isics: success,
          ));
        },
      );
    });

    add(const GetActivitesEvent());
  }
}
