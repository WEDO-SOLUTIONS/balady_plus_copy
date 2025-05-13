import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/data/repositories/mini_apps_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_mini_apps_list_state.dart';

class HomeMiniAppsListCubit extends Cubit<HomeMiniAppsListState> {
  MiniAppsRepository homeServicesUseCases;

  HomeMiniAppsListCubit({
    required this.homeServicesUseCases,
  }) : super(const HomeMiniAppsListLoadingState()) {
    loadServices();
  }

  Future<void> loadServices() async {
    emit(const HomeMiniAppsListLoadingState());
    homeServicesUseCases.getMiniAppsList().then(
      (value) {
        value.fold(
          (l) {
            emit(
              HomeMiniAppsListFiledState(
                errors: l.toString(),
              ),
            );
          },
          (r) {
            emit(
              HomeMiniAppsListSuccessState(miniAppsList: r),
            );
          },
        );
      },
    );
  }
}
