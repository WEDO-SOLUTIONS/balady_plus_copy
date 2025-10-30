import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../shared_features/widgets/app_bar.dart';

class PDFViewer extends StatefulWidget {
  final String text;
  final String url;
  const PDFViewer({super.key, required this.text, required this.url});

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.text ?? "",
      ),
      body: SfPdfViewer.network(
        widget.url ?? "",
      ),
    );
  }
}
