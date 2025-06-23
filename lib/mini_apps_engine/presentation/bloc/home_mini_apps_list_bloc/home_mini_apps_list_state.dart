part of 'home_mini_apps_list_cubit.dart';

abstract class HomeMiniAppsListState extends Equatable {
  const HomeMiniAppsListState();
}

class HomeMiniAppsListLoadingState extends HomeMiniAppsListState {
  const HomeMiniAppsListLoadingState();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class HomeMiniAppsListSuccessState extends HomeMiniAppsListState {
  final List<MiniAppModel> miniAppsList;
  final MiniAppsEngineBloc? municipalAppBloc;
  // final String serverPath;
  const HomeMiniAppsListSuccessState({
    required this.miniAppsList,
    // required this.serverPath,
    this.municipalAppBloc,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [miniAppsList, municipalAppBloc,];//serverPath
}

class HomeMiniAppsListFiledState extends HomeMiniAppsListState {
  final String errors;

  const HomeMiniAppsListFiledState({required this.errors});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
