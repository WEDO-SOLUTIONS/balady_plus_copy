import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pdf/pdf.dart';

import 'package:printing/printing.dart';


import 'package:pdf/widgets.dart' as pw;

import '../../../../../../../features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';


class PrintPreview extends StatelessWidget {
  const PrintPreview(this.title, {super.key});
  final String title;


  @override
  Widget build(BuildContext context) {

     return Scaffold(
        appBar: DefaultAppBarWidget(
        title: 'viewForPrint'.tr()),
        body: PdfPreview(
          build: (format) => _generatePdf(format, title),
        ),
      );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();
    var data = await rootBundle.load("fonts/FrutigerLTArabic45Light.ttf");
    final ttf = pw.Font.ttf(data.buffer.asByteData());
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return pw.Text(title, style: pw.TextStyle(font:ttf ,fontSize: 28)); // Center
        }));
    return await pdf.save();
  }
}
