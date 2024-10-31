import '../../domain/use_cases/search_isics.dart';
import '/app/core/dependency_injection/injection_container.dart';
import '/app/core/errors/failures.dart';
import '/app/core/utils/enums/bloc_status.dart';
import 'package:bloc/bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchIsicsUC _searchIsicsUC;

  SearchBloc()
      : _searchIsicsUC = SearchIsicsUC(repository: sl()),
        super(SearchState()) {
    on<SearchIsicEvent>((event, emit) async {
      emit(state.copyWith(sectorStatus: BlocStatus.loading));

      final failureOrSuccess = await _searchIsicsUC(event.keyword);
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(sectorStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            sectorStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
              sectorStatus: BlocStatus.success, sectors: success));
        },
      );
    });
  }
}
