// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/evaluation/widget/compliance_check_widget.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/core/utils/constants/language.dart';

class EvaluationsPage extends StatelessWidget {
  const EvaluationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: " التقييم",
        ),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 9,
                  decoration: BoxDecoration(color: Color(0xFFEAEFF6)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 250),
                  child: Container(
                    height: 9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF2E7998)),
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView.builder(
                  itemCount: 3,
                  itemBuilder: (ctx, index) {
                    return ComplianceCheckWidget(
                      onSelect: (bool value) {},
                      text:
                          "يرجى الالتزام بتجديد الرخصة قبل انتهائها أو إلغائها في حالة عدم الرغبة في تجديدها وذلك لتجنب رسوم غرامة",
                      image:
                          'packages/smart_advisor/smart_advisor_assets/images/imageone.png',
                    );
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(IconPath.arrowLeft),
                SizedBox(
                  width: 8,
                ),
                Text(
                  ("previous").tr(),
                  style: GoogleFonts.cairo(
                      fontSize: 16,
                      color: Color(0xFFCCCED4),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }
}
