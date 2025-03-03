import 'dart:async';

import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'dart:io';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:image_picker/image_picker.dart';

import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart'
    show FacilityDialog, FacilityQRDetailsViewModel;
import 'package:scan/scan.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../vd/domain/entities/camera/camera_page_params.dart';
import '../../../vd/presentation/dialogs/qr_types_dialog.dart';

String scanResult = "";
late QRViewController controller;
final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

class QrScreen extends StatefulWidget {
  const QrScreen({Key? key}) : super(key: key);

  @override
  _QrScreenState createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceYourFeedback);

    CommonFunctions.sendUXCamEvent(UXCamEvents.YourFeedback_Open_Scan_Event);
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  listen() {
    controller.scannedDataStream.take(1).listen((scanData) async {
      scanResult = scanData.code!;
      checkBarcode(context);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    //facilityRatingViewModel.ratingItems = [];
    // locator.resetLazySingleton(instance: facilityRatingViewModel);
    //locator.resetLazySingleton(instance: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: Stack(
        children: [
          _QrWidget(),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
              child: CustomTextWidget(
                ("scanFacilityCode").tr(),
                fontColor: AppColor.white,
                fontWeight: AppFontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Align(
              alignment: AlignmentDirectional.bottomStart,
              child: _ScanImageWidget()),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    top: MediaQuery.of(context).padding.top + 10, start: 16),
                child: Image.asset(
                  IconPath.qrWhiteCloseIcon,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ),
          // const CustomCircularLoadingWidget()
        ],
      ),
    );
  }
}

class _QrWidget extends StatefulWidget {
  @override
  State<_QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<_QrWidget> {
  late Barcode result;

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: Platform.isAndroid
          ? QrScannerOverlayShape(
              borderColor: Colors.black,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 250)
          : null,
    );
  }

  void _onQRViewCreated(QRViewController _controller) {
    setState(() {
      controller = _controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      scanResult = scanData.code!;
      checkBarcode(context);
    });
  }
}

class _ScanImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 20, start: 20),
      child: CustomIconButtonWidget(
        icon: IconPath.qrScanImageIcon,
        onPressed: () => scanImg(context),
        btnHeight: 42,
        btnWidth: 42,
      ),
    );
  }

  void scanImg(BuildContext context) async {
    bool isPhotosAllowed = await Helpers.checkPhotosSettings(context);
    if (!isPhotosAllowed) return;
    //MM  showLockScreen = false;
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 600,
    );
    //MM  Helpers.showLock();

    if (image == null) return;
    try {
      final rest = await Scan.parse(image.path);
      scanResult = rest ?? "";
      checkBarcode(context);
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      error.toString();
    }
  }
}

void checkBarcode(BuildContext context) async {
  final FacilityQRDetailsViewModel viewModel =
      locator<FacilityQRDetailsViewModel>();

  // success
  controller.pauseCamera();
  if (scanResult.isNotEmpty) {
    bool isLicenseFound = false;
    String? licenseId = viewModel.getLicenceFromBarcode(scanResult);
    if (licenseId != null) {
      isLicenseFound = await viewModel.getFacilityData(licenseId);
    }

    if (isLicenseFound) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => WillPopScope(
                onWillPop: () {
                  controller.resumeCamera();
                  Navigator.of(context).pop();
                  return Future<bool>.value(true);
                },
                child: FacilityDialog(
                  address: viewModel.getCityAndStreet(),
                  facilityImg: viewModel.getCoverPhotoUrl(),
                  rate: viewModel.getFacilityAvrageRating(),
                  facilityName: viewModel.getFacilityName(),
                  reviewers: viewModel.getFacilityTotalRatingCount(),
                  onDetailsScreen: () {
                    /* NavigationService.navigatorKey.currentState!.pushNamed(
                        RoutesNames.facilityScreenRoute,
                        arguments: viewModel.facilityRespoonse);*/
                  },
                  onRatingScreen: () {
                    /*NavigationService.navigatorKey.currentState!.pushNamed(
                        RoutesNames.facilityRatingRoute,
                        arguments: viewModel.facilityRespoonse);*/
                  },
                  onIncidentScreen: () async {
                    bool isLocationAvailable =
                        await CommonFunctions.checkLocationSettings(context);
                    bool isCameraAllowed =
                        await CommonFunctions.checkCameraSettings(context);
                    if (isLocationAvailable && isCameraAllowed) {
                      double? lat = viewModel.facilityRespoonse?.data?.result
                          ?.comLicenseInfo?.locationInfo?.latitude;
                      double? long = viewModel.facilityRespoonse?.data?.result
                          ?.comLicenseInfo?.locationInfo?.longitude;

                      if (lat != null && long != null) {
                        CommonFunctions.sendUXCamEvent(
                            UXCamEvents.SnapAndSend_Open_From_FeedBack_Event);
                        await BottomSheetDialog.showDraggableSheet(context,
                            dialogKeyName: DialogName.vdTypesDialog,
                            currentRouteName: RouteName.qrFacilityScreenRoute,
                            child: BottomSheetWithActions(
                              title: "customerVoiceReportTypeWord".tr(),
                              body: QrTypesDialog(
                                cmeraParamsPage: CameraParamsPage(
                                  lat: lat,
                                  lon: long,
                                  qrCodeFlow: true,
                                  pageType: PAGE_TYPE.qrDialog,
                                  // isFromHome: false,
                                ),
                              ),
                            ));
                      }
                    }
                  },
                ),
              )).then((value) => controller.resumeCamera());

      CommonFunctions.sendUXCamEvent(UXCamEvents.finishServiceYourFeedback);
    } else {
      Timer(const Duration(seconds: 3), () async {
        controller.resumeCamera();
      });
    }
  }
  // fail
  else {
    CommonFunctions.showError(("wrong_qr_code").tr());
    Timer(const Duration(seconds: 3), () async {
      controller.resumeCamera();
    });
  }
}
