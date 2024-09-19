import '/app/features/select_activity/domain/entities/isics_page_params.dart';
import '/app/features/select_activity/domain/entities/isics_request_params.dart';
import '/app/features/select_activity/domain/use_cases/get_Isics.dart';
import '/app/features/select_activity/presentation/blocs/isics_bloc/isics_event.dart';
import '/app/features/select_activity/presentation/blocs/isics_bloc/isics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart' show BlocStatus;

class IsicsBloc extends Bloc<IsicsEvent, IsicsState> {
  final GetIsicsUc _getIsics;
  final IsicsPageParams args;

  IsicsBloc({required this.args})
      : _getIsics = GetIsicsUc(repository: sl()),
        super(const IsicsState()) {
    ///
    on<GetIsicsEvent>((event, emit) async {
      emit(state.copyWith(isicsStatus: BlocStatus.loading));

      final failureOrSuccess = await _getIsics(IsicsRequestParams(
          rubricId: args.rubric.id, categoryId: args.category.id));
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
    add(const GetIsicsEvent());
  }
}
