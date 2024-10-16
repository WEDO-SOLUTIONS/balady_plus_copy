import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';

class RequirementsView extends StatelessWidget {
  const RequirementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
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
                    'المتطلبات ',
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
                      'صورة خارجية للمحل ويتم إبراز لوحة المحل.',
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
                      ' عقد الإيجار أو صك الملكية أو عقد الاستثمار للموقع من البلدية أو الجهات الحكومية الأخرى.',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        height: 1.8,
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
                      'فاتورة أدوات السلامة أو تقرير سلامة من الدفاع المدني للأنشطة الفوريه',
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
      ),
    );
  }
}
