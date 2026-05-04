part of 'camera_bloc.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class TakePhoto extends CameraEvent {
  // final AttachmentItem? file;
  const TakePhoto();
}

class ReTakePhotoEvent extends CameraEvent {
  // final AttachmentItem? file;
  const ReTakePhotoEvent();
}

class InitCameraEvent extends CameraEvent {
  const InitCameraEvent();
}

class OnNewCameraSelected extends CameraEvent {
  const OnNewCameraSelected();
}

class SetZoomLevelEvent extends CameraEvent {
  final double zoom;
  const SetZoomLevelEvent({required this.zoom});
}

class ToggleCameraFlashEvent extends CameraEvent {
  const ToggleCameraFlashEvent();
}

class UpdateScaleLevelEvent extends CameraEvent {
  final double scale;
  const UpdateScaleLevelEvent({required this.scale});
}

class ShowLoading extends CameraEvent {
  final bool status;
  const ShowLoading({required this.status});
}
