part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class TakePhoto extends CameraEvent {
  // final AttachmentItem? file;
  TakePhoto();
}

class ReTakePhotoEvent extends CameraEvent {
  // final AttachmentItem? file;
  ReTakePhotoEvent();
}

class InitCameraEvent extends CameraEvent {
  InitCameraEvent();
}

class OnNewCameraSelected extends CameraEvent {
  OnNewCameraSelected();
}

class SetZoomLevelEvent extends CameraEvent {
  final double zoom;
  SetZoomLevelEvent({required this.zoom});
}

class ToggleCameraFlashEvent extends CameraEvent {
  ToggleCameraFlashEvent();
}

class UpdateScaleLevelEvent extends CameraEvent {
  final double scale;
  UpdateScaleLevelEvent({required this.scale});
}

class ShowLoading extends CameraEvent {
  final bool status;
  ShowLoading({required this.status});
}
