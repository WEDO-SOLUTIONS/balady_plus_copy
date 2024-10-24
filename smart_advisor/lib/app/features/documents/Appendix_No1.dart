import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppendixNo1 extends StatelessWidget {
  const AppendixNo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.statusAccentColor),
          onPressed: () {
            // Handle back button action
          },
        ),
        title: Text(
          'الملحق',
          style: AppStyle.calloutBoldStyle
              .copyWith(color: AppColor.textPrimaryColor),
        ),
        centerTitle: true,
        actions: [
          SvgPicture.asset('assets/images/svg_icon/PDFicone.svg')
          // IconButton(
          //   icon: Icon(Icons.picture_as_pdf, color: AppColor.black),
          //   onPressed: () {
          //     // Handle download action
          //   },
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SASO Logo
            Image.asset('assets/images/SASO.png'),
            SizedBox(height: 100),

            // Organization Name in Arabic and English
            Text(
              'الهيئة السعودية للمواصفات والمقاييس والجودة',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Saudi Standards, Metrology and Quality Org.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),

            // Document Title
            Text(
              'ملحق رقم (1)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),

            // Document Subtitle
            Text(
              'اللائحة التنفيذية لنظام القياس والمعايرة\nالاشتراطات الفنية لمضخات الوقود',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),

            // Publishing Date
            Column(
              children: [
                Text(
                  'نُشر في موقع الهيئة بتاريخ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  '11/6/2018م\n27/9/1439هـ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
