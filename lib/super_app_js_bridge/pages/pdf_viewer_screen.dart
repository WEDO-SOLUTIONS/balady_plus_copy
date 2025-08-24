import 'package:balady_plus/super_app_js_bridge/model/js_pdf_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final JsPdfModel pdfData;

  const PdfViewerScreen({super.key, required this.pdfData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: pdfData.type == "bayes"
          ? SfPdfViewer.memory(
              pdfData.bytes!,
            )
          : SfPdfViewer.network(
              pdfData.url!,
            ),
    );
  }
}
