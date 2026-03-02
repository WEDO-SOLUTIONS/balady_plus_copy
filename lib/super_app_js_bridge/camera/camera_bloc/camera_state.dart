part of 'camera_bloc.dart';

class CameraState extends Equatable {
  BlocStatus status;
  String? errorMessage;
  bool? showCamera;
  bool isFlashOn;
  double zoom;
  double scaleFactor;
  bool? multi;
  bool? isCameraInitialized;
  AttachmentItem? files;

  CameraState({
    this.status = BlocStatus.initial,
    this.errorMessage,
    this.showCamera = true,
    this.isFlashOn = false,
    this.zoom = 0.0,
    this.scaleFactor = 1.0,
    this.multi = false,
    this.isCameraInitialized,
    this.files,
  });

  CameraState copyWith({
    final BlocStatus? status,
    final String? errorMessage,
    final bool? showCamera,
    final AttachmentItem? files,
    final bool? isFlashOn,
    final double? zoom,
    final double? scaleFactor,
    final bool? multi,
    final bool? isCameraInitialized,
  }) {
    return CameraState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      showCamera: showCamera ?? this.showCamera,
      files: files ?? this.files,
      multi: multi ?? this.multi,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      zoom: zoom ?? this.zoom,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
    );
  }

  @override
  List<Object?> get props => [
        status,
        showCamera,
        isFlashOn,
        zoom,
        scaleFactor,
        isCameraInitialized,
      ];
}
