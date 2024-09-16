import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/app_bar.dart';

import '../blocs/_bloc/qr_bloc.dart';

class QrScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QRBloc(),
      child: BlocListener<QRBloc, QrState>(
        listener: (context, state) {
          if (state.qrStatus == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        child: BlocBuilder<QRBloc, QrState>(
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(
                title: 'مسح الرمز المرئي',
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: (QRViewController controller) {
                        setState(() {
                          this.controller = controller;
                        });
                        controller.scannedDataStream.take(1).listen((scanData) {
                          setState(() {
                            qrText = scanData.code;
                          });
                          String text = scanData.code?.split("/").last ?? "";
                          if (text.isNotEmpty)
                            context
                                .read<QRBloc>()
                                .add(GetQrDetailsEvent(qr: text));
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {}

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
