import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:equatable/equatable.dart';

abstract class MiniAppsEngineEvent extends Equatable {
  const MiniAppsEngineEvent();

  @override
  List<Object> get props => [];
}


class CheckMiniAppsEngineEvent extends MiniAppsEngineEvent {

  final MiniAppModel miniApp;

  const CheckMiniAppsEngineEvent({required this.miniApp});

  @override
  List<Object> get props => [];
}

class DownloadMiniAppsEngineEvent extends MiniAppsEngineEvent {
  final MiniAppModel miniApp;

  const DownloadMiniAppsEngineEvent({required this.miniApp});

  @override
  List<Object> get props => [];
}

