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
                    label: "رقم الجوال",
                    value: '05049389393',
                    withBottomMargin: false,
                  ),
                  SizedBox(height: 8),
                  NotesWidget(
                    notes: [
                      "سوف يتم استلام جميع الاشعارات على رقم الجوال المسجل في النظام",
                    ],
                  ),
                  ReadOnlyField(
                    label: "صفه مقدم الطلب",
                    value: 'مالك المنشاه',
                  ),
                  ReadOnlyField(
                    label: "السجل التجاري",
                    value: '89107831',
                  ),
                  ReadOnlyField(
                    label: "اسم المنشاه",
                    value: 'الخزائن المبتكره',
                  ),
                  ReadOnlyField(
                    label: "رقم المنشآه",
                    value: '8098787',
                  ),
                  ReadOnlyField(
                    label: "مصدر السجل التجاري",
                    value: 'الدمام',
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
