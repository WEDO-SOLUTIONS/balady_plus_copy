import '/app/core/dependency_injection/injection_container.dart';
import '/app/core/errors/failures.dart';
import '/app/core/services/local/use_case.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/select_activity/domain/use_cases/get_sectors.dart';
import 'package:bloc/bloc.dart';
import '/app/features/home_page/presentation/bloc/home_event.dart';
import '/app/features/home_page/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetSectorUC _getSector;

  HomeBloc()
      : _getSector = GetSectorUC(repository: sl()),
        super(HomeState()) {
    on<HideHintChat>(_hideHinChat);

    on<GetSectorEvent>((event, emit) async {
      emit(state.copyWith(sectorStatus: BlocStatus.loading));

      final failureOrSuccess = await _getSector(NoParams());
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
              sectorStatus: BlocStatus.success, sectors: success.items));
        },
      );
    });
    add(GetSectorEvent());
  }
  void _hideHinChat(HideHintChat event, Emitter emit) {
    emit(state.copyWith(showChatHint: false));
  }
}
