import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class RequirementsFinesView extends StatelessWidget {
  final String url;
  const RequirementsFinesView({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 290,
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
                    'الاشتراطات والغرامات ',
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
                'تعرف على قائمة الاشتراطات والموافقات الحكومية المطلوبة بحسب نوع النشاط.',
                style: GoogleFonts.cairo(
                    fontSize: 16, color: const Color(0xFF656A73)),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  launchUrl(Uri.parse(url));
                },
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                      color: Color(0xFFF1F6F7),
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'متطلبات واشتراطات الخدمة',
                          style: GoogleFonts.cairo(
                              fontSize: 14, color: Color(0xFF155F75)),
                        ),
                        SvgPicture.asset(
                            'packages/smart_advisor/smart_advisor_assets/images/link-square.svg'),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
