import '/app/features/select_activity/domain/entities/rubrics_request_params.dart';
import '/app/features/select_activity/domain/use_cases/get_rubrics.dart';
import '/app/features/select_activity/presentation/blocs/rubrics_bloc/rubrics_event.dart';
import '/app/features/select_activity/presentation/blocs/rubrics_bloc/rubrics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart' show BlocStatus;
import '../../../domain/entities/rubrics_page_params.dart';

class RubricsBloc extends Bloc<RubricsEvent, RubricsState> {
  final GetRubricsUc _getRubrics;
  final RubricsPageParams args;

  RubricsBloc({required this.args})
      : _getRubrics = GetRubricsUc(repository: sl()),
        super(const RubricsState()) {
    ///
    on<GetRubricsEvent>((event, emit) async {
      emit(state.copyWith(rubricsStatus: BlocStatus.loading));

      final failureOrSuccess = await _getRubrics(RubricsRequestParams(
        rubricsID: args.category.id,
      ));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(rubricsStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            rubricsStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
            rubricsStatus: BlocStatus.success,
            rubrics: success,
          ));
        },
      );
    });
    add(const GetRubricsEvent());
  }
}
