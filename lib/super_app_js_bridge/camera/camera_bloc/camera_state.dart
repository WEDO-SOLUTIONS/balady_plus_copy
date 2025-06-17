part of 'camera_bloc.dart';

class CameraState extends Equatable {
  BlocStatus status;
  // bool? isFromHome;
  String? errorMessage;
  bool? showCamera;
  bool isFlashOn;
  double zoom;
  double scaleFactor;
  bool? multi;
  bool? isCameraInitialized;
  List<AttachmentItem>? files;
  SplResponse? splResponse;
  CategoryItem selectedCattegory;
  GISParams? location;
  GISResponse? gisResponse;
  bool qrCodeFlow;
  PAGE_TYPE? pageType;

  CameraState(
      {this.status = BlocStatus.initial,
      // this.isFromHome = false,
      this.errorMessage,
      this.showCamera = true,
      this.isFlashOn = false,
      this.zoom = 0.0,
      this.scaleFactor = 1.0,
      this.multi = false,
      this.isCameraInitialized,
      this.files,
      this.splResponse,
      required this.selectedCattegory,
      this.gisResponse,
      this.location,
      this.qrCodeFlow = false,
      this.pageType});

  CameraState copyWith(
      {final BlocStatus? status,
      // final bool? isFromHome,
      final String? errorMessage,
      final bool? showCamera,
      final List<AttachmentItem>? files,
      final bool? isFlashOn,
      final double? zoom,
      final double? scaleFactor,
      final bool? multi,
      final bool? isCameraInitialized,
      SplResponse? splResponse,
      CategoryItem? selectedCattegory,
      final GISParams? location,
      final GISResponse? gisResponse,
      final bool? qrCodeFlow,
      final PAGE_TYPE? pageType}) {
    return CameraState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        showCamera: showCamera ?? this.showCamera,
        files: files ?? this.files,
        multi: multi ?? this.multi,
        splResponse: splResponse ?? this.splResponse,
        selectedCattegory: selectedCattegory ?? this.selectedCattegory,
        isFlashOn: isFlashOn ?? this.isFlashOn,
        scaleFactor: scaleFactor ?? this.scaleFactor,
        zoom: zoom ?? this.zoom,
        isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
        // isFromHome: isFromHome ?? this.isFromHome,
        location: location ?? this.location,
        gisResponse: gisResponse ?? this.gisResponse,
        qrCodeFlow: qrCodeFlow ?? this.qrCodeFlow,
        pageType: pageType ?? this.pageType);
  }

  @override
  List<Object?> get props => [
        status,
        showCamera,
        isFlashOn,
        zoom,
        scaleFactor,
        isCameraInitialized,
        // isFromHome,
        gisResponse,
        location,
        qrCodeFlow,
        pageType
      ];
}