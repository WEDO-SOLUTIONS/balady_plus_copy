import 'package:equatable/equatable.dart';

//!
abstract class MiniAppsEngineState extends Equatable {
  const MiniAppsEngineState();

  MiniAppsEngineState copyWith();
}

class MiniAppsEngineInitialState extends MiniAppsEngineState {
  const MiniAppsEngineInitialState();

  @override
  List<Object> get props => [];

  @override
  MiniAppsEngineState copyWith() {
    return const MiniAppsEngineInitialState();
  }
}

class MiniAppsEngineLoadingState extends MiniAppsEngineState {
  final String progress;

  const MiniAppsEngineLoadingState({required this.progress});

  @override
  List<Object> get props => [progress];

  @override
  MiniAppsEngineState copyWith({String? progress}) {
    return MiniAppsEngineLoadingState(progress: progress ?? this.progress);
  }
}

class MiniAppsEngineLoadedState extends MiniAppsEngineState {
  final String servicePath;
  final String path;

  const MiniAppsEngineLoadedState({required this.servicePath, required this.path});

  @override
  List<Object> get props => [servicePath, path];

  @override
  MiniAppsEngineState copyWith() {
    return MiniAppsEngineLoadedState(servicePath: servicePath, path: path);
  }
}

class MiniAppsEngineErrorState extends MiniAppsEngineState {
  final String errorMessage;

  const MiniAppsEngineErrorState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  MiniAppsEngineState copyWith() {
    return MiniAppsEngineErrorState(errorMessage: errorMessage);
  }
}

class FailedDownloadState extends MiniAppsEngineState {
  const FailedDownloadState();

  @override
  List<Object> get props => [];

  @override
  MiniAppsEngineState copyWith() {
    return const FailedDownloadState();
  }
}
