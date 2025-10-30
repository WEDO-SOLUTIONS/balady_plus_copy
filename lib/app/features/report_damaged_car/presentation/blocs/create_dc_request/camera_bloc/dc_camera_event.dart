part of 'dc_camera_bloc.dart';

abstract class DCCameraEvent extends Equatable {
  const DCCameraEvent();

  @override
  List<Object> get props => [];
}

class NavigateToDetailsScreenEvent extends DCCameraEvent {
  CreateDCBloc createDCBloc;
  NavigateToDetailsScreenEvent({required this.createDCBloc});
}

class GetUserLocationEvent extends DCCameraEvent {
  GetUserLocationEvent();
}

class GetGISEvent extends DCCameraEvent {
  final GISParams params;
  GetGISEvent({
    required this.params,
  });
}

class TakePhoto extends DCCameraEvent {
  // final AttachmentItem? file;
  TakePhoto();
}

class ReTakePhotoEvent extends DCCameraEvent {
  // final AttachmentItem? file;
  ReTakePhotoEvent();
}

class InitCameraEvent extends DCCameraEvent {
  InitCameraEvent();
}

class OnNewCameraSelected extends DCCameraEvent {
  OnNewCameraSelected();
}

class SetZoomLevelEvent extends DCCameraEvent {
  final double zoom;
  SetZoomLevelEvent({required this.zoom});
}

class ToggleCameraFlashEvent extends DCCameraEvent {
  ToggleCameraFlashEvent();
}

class UpdateScaleLevelEvent extends DCCameraEvent {
  final double scale;
  UpdateScaleLevelEvent({required this.scale});
}

class ShowLoading extends DCCameraEvent {
  final bool status;
  ShowLoading({required this.status});
}
