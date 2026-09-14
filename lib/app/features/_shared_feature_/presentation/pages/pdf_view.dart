import 'dart:convert';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pdfx/pdfx.dart';

class PDFViewer extends StatefulWidget {
  final Uint8List file;
  final String? title;

  const PDFViewer({super.key, required this.file, this.title});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late PdfController pdfController;
  //
  @override
  void initState() {
    super.initState();
    pdfController = PdfController(document: PdfDocument.openData(widget.file));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white4,
      body: Stack(
        children: [
          Center(
            child: PdfView(scrollDirection: Axis.vertical, controller: pdfController),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, right: 16),
                child: Image.asset(IconPath.qrWhiteCloseIcon, height: 24.0, width: 24.0, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullImageView extends StatelessWidget {
  final String imageBase64;

  const FullImageView({super.key, required this.imageBase64});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(title: ("lbl_attachments").tr()),
      body: Center(child: Image.memory(base64Decode(imageBase64), fit: BoxFit.cover)),
    );
  }
}

class FullImageViewBytes extends StatelessWidget {
  final Uint8List imageBase64;

  const FullImageViewBytes({super.key, required this.imageBase64});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(title: ("lbl_attachments").tr()),
      body: Center(child: Image.memory(imageBase64, fit: BoxFit.cover)),
    );
  }
}
