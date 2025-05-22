import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/data/repositories/mini_apps_repository.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_mini_apps_list_state.dart';

class HomeMiniAppsListCubit extends Cubit<HomeMiniAppsListState> {
  MiniAppsRepository homeServicesUseCases;

  HomeMiniAppsListCubit({
    required this.homeServicesUseCases,
  }) : super(const HomeMiniAppsListLoadingState()) {
    loadMiniApps();
  }

  Future<void> loadMiniApps() async {
    emit(const HomeMiniAppsListLoadingState());
    homeServicesUseCases.getMiniAppsList().then(
      (value) {
        value.fold(
          (l) {
            emit(HomeMiniAppsListFiledState(errors: l.toString()));
          },
          (listMiniApps) {
            HomeMiniAppsListState state = HomeMiniAppsListSuccessState(
              miniAppsList: listMiniApps,
            );
            for (var element in listMiniApps) {
              if (element.serviceKey == "municipalservice") {
                state = HomeMiniAppsListSuccessState(
                  miniAppsList: listMiniApps,
                  municipalAppBloc: MiniAppsEngineBloc(miniApp: element),
                );
              }
            }
            emit(state);
          },
        );
      },
    );
  }
}
