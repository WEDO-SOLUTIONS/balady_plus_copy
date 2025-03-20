import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.iBMPlexSansArabicMedium();
    final image = await imageFromAssetBundle('assets/images/splash-screen.gif');

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [

              pw.SizedBox(
                width: double.infinity,

                  child: pw.Text(title, style: pw.TextStyle(font: font,fontSize:23),textDirection: pw.TextDirection.ltr),

              ),
              // pw.SizedBox(height: 20),
              // pw.Flexible(child: pw.Image(image)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
