import 'package:flutter/material.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep1ApplicantData extends StatelessWidget {
  const CRStep1ApplicantData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRHeaderDesc(header: "بيانات مقدم الطلب"),
                  SizedBox(height: 12),
                  ReadOnlyField(
                    title: "رقم الجوال",
                    subTitle: '05049389393',
                    showSpace: false,
                  ),
                  SizedBox(height: 8),
                  NotesWidget(
                    notes: [
                      "سوف يتم استلام جميع الاشعارات على رقم الجوال المسجل في النظام",
                    ],
                  ),
                  ReadOnlyField(
                    title: "صفه مقدم الطلب",
                    subTitle: 'مالك المنشاه',
                  ),
                  ReadOnlyField(
                    title: "السجل التجاري",
                    subTitle: '89107831',
                  ),
                  ReadOnlyField(
                    title: "اسم المنشاه",
                    subTitle: 'الخزائن المبتكره',
                  ),
                  ReadOnlyField(
                    title: "رقم المنشآه",
                    subTitle: '8098787',
                  ),
                  ReadOnlyField(
                    title: "مصدر السجل التجاري",
                    subTitle: 'الدمام',
                  ),
                ],
              ),
            ),
          ),
        ),
        CRPreviousNextButtons(isBtnDisabled: false),
      ],
    );
  }
}
