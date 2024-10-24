import '/app/features/home/home_exports.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart' show BlocStatus;

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetNewsUc _getNews;

  HomeBloc()
      : _getNews = GetNewsUc(repository: sl()),
        super(const HomeState()) {
    ///
    on<GetNews>((event, emit) async {
      emit(state.copyWith(newsStatus: BlocStatus.loading));

      final failureOrSuccess =
          await _getNews(NewsParams(pageSize: 10, pageIndex: 1));
      await failureOrSuccess.fold(
        (failure) async {
          emit(state.copyWith(newsStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            newsStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          emit(state.copyWith(
            newsStatus: BlocStatus.success,
            newsResponse: success,
          ));
        },
      );
    });
  }
}
