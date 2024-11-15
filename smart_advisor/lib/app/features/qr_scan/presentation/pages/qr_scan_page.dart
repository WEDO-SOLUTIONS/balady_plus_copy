import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/app_bar.dart';

import '../blocs/_bloc/qr_bloc.dart';

String scanResult = "";
late QRViewController controller;
final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

class QrScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  String? qrText;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid && controller != null) {
      controller?.pauseCamera();
    }
    if (controller != null) controller?.resumeCamera();
  }

  listen() {
    controller?.scannedDataStream.take(1).listen((scanData) async {
      scanResult = scanData.code!;
      checkBarcode(context);
    });
  }

  void checkBarcode(BuildContext context) async {
    // success
    controller.pauseCamera();
    if (scanResult.isNotEmpty) {
      String text = scanResult.split("/").last ?? "";
      if (text.isNotEmpty)
        context.read<QRBloc>().add(GetQrDetailsEvent(qr: text));
    } else {
      CommonFunctions.showError("خطأ");
      Timer(const Duration(seconds: 3), () async {
        controller.resumeCamera();
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    //facilityRatingViewModel.ratingItems = [];
    // locator.resetLazySingleton(instance: facilityRatingViewModel);
    //locator.resetLazySingleton(instance: viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QRBloc(),
      child: BlocListener<QRBloc, QrState>(
        listener: (context, state) {
          if (state.qrStatus == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
            Timer(const Duration(seconds: 3), () async {
              controller.resumeCamera();
            });
          }
        },
        child: BlocBuilder<QRBloc, QrState>(
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: 'مسح الرمز المرئي',
              ),
              body: Stack(
                children: <Widget>[
                  QRView(
                    key: qrKey,
                    onQRViewCreated: (QRViewController c) {
                      setState(() {
                        controller = c;
                      });
                      controller.scannedDataStream.listen((scanData) async {
                        scanResult = scanData.code!;
                        checkBarcode(context);
                      });
                    },
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                      borderRadius: 10,
                      borderLength: 30,
                      borderWidth: 10,
                      cutOutSize: 300,
                    ),
                  ),
                  if (state.qrStatus == BlocStatus.loading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColor.statusAccentColor,
                      ),
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
