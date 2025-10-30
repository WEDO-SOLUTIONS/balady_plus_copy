import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';

class HowToApply extends StatelessWidget {
  const HowToApply({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 45, right: 16, left: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طريقه التقديم',
                  style: GoogleFonts.cairo(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SvgPicture.asset(
                    'packages/smart_advisor/smart_advisor_assets/images/close.svg'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              ' يمكنك التقديم لطلب رخصة تجارية لنشاطك ',
              style: GoogleFonts.cairo(
                  fontSize: 16, color: const Color(0xFF656A73)),
            ),
            Text(
              'على سبيل المثال لا الحصر - رخصة أعمال، تراخيص البيئة، ترخيص شركة صناعية، ترخيص شركة طبية، ترخيص شركة أطعمة، ترخيص شركة سياحة، ترخيص مؤسسة احترافية من خلال الخطوات التالية:',
              style: GoogleFonts.cairo(
                  fontSize: 16, color: const Color(0xFF656A73), height: 1.7),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  IconPath.checkCircle,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    'إدخال سجل المنشأة وتحديد النشاط والمساحة.',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: const Color(0xFF18182D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              endIndent: 0,
              color: Color(0xFFECEEEE),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  IconPath.checkCircle,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    'تحديد الموقع وتعبئة تفاصيل المحل أو العربة.',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: const Color(0xFF18182D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              height: 1,
              thickness: 1,
              endIndent: 0,
              color: Color(0xFFECEEEE),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  IconPath.checkCircle,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    'دفع الرسوم إذا كان النشاط فوري أو إرسال الطلب للبلدية في حال الأنشطة غير الفورية.',
                    style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: const Color(0xFF18182D),
                        height: 1.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
