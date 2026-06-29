import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:equatable/equatable.dart';

//!
abstract class MiniAppsEngineEvent extends Equatable {
  const MiniAppsEngineEvent();

  @override
  List<Object> get props => [];
}

class CheckMiniAppsEngineEvent extends MiniAppsEngineEvent {
  final MiniApp miniApp;

  const CheckMiniAppsEngineEvent({required this.miniApp});

  @override
  List<Object> get props => [];
}

class DownloadMiniAppsEngineEvent extends MiniAppsEngineEvent {
  final MiniApp miniApp;

  const DownloadMiniAppsEngineEvent({required this.miniApp});

  @override
  List<Object> get props => [];
}

class OpenServerEngineEvent extends MiniAppsEngineEvent {
  final MiniApp miniApp;

  const OpenServerEngineEvent({required this.miniApp});

  @override
  List<Object> get props => [];
}
