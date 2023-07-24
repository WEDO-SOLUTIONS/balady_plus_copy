import 'package:flutter/material.dart';
import '../../../commercial_license_exports.dart';

class CRStep5AttachmentData extends StatelessWidget {
  const CRStep5AttachmentData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CRHeaderDesc(
                    maxLines: null,
                    textHeight: 1.5,
                    header: "بيانات المرفق",
                    desc:
                        "امتداد الملفات المسموح بإرفاق jpeg، jpg، png، pdf لا يتعدى حجم الملف 10 ميجابايت",
                  ),
                  const SizedBox(height: 12),
                  PickFileComponent(
                    title: "رخصه بناء",
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: "صورة المحل الخارجية باللوحة",
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: "عقد الاستثمار",
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                  PickFileComponent(
                    title: "مستند اثبات ملكية العلامة التجارية",
                    file: null,
                    onDelete: () {},
                    onPickedFile: (file) {},
                  ),
                ],
              ),
            ),
          ),
        ),
        const CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
