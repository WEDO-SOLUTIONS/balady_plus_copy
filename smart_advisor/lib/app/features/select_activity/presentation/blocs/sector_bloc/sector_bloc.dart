import '/app/core/dependency_injection/injection_container.dart';
import '/app/core/errors/failures.dart';
import '/app/core/services/services_exports.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/use_cases/get_sectors.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'sector_event.dart';

part 'sector_state.dart';

class SectorBloc extends Bloc<SectorEvent, SectorState> {
  final GetSectorUC _getSector;

  SectorBloc()
      : _getSector = GetSectorUC(repository: sl()),
        super(const SectorState()) {
    ///
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
    add(const GetSectorEvent());
  }
}
