// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../shared_features/widgets/text_item_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/language.dart';

class LocationCondtionDelg extends StatelessWidget {
  const LocationCondtionDelg({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 620,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 45, right: 16, left: 26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ("location_requirements").tr(),
                    style: GoogleFonts.cairo(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!
                            .pop(context);
                      },
                      child: SvgPicture.asset(
                          'packages/smart_advisor/smart_advisor_assets/images/close.svg')),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TextItemComponent(
                        description: 'الاتقل مساحة الموقع عن 1500م2'),
                    TextItemComponent(
                        description:
                            'يشترط أن لا تقل مساحة الفتحات عن 1/8 المساحة المبنية من النشاط.'),
                    TextItemComponent(
                        description:
                            'أن يكون الموقع داخل مخططات الورش أو المناطق الصناعية المعتمدة ضمن المخططات الهيكلية للمدن والقرى.'),
                    TextItemComponent(
                        description: 'أن يكون المبنى من دور واحد (أرضي فقط).'),
                    TextItemComponent(
                        description: 'يكون بعيداً عن أي منشأة صناعية غذائية.'),
                    const TextItemComponent(
                        description:
                            'ألا يكون له تأثير سلبي على البيئة المجاورة.ألا يكون له تأثير سلبي على البيئة المجاورة.'),
                    const TextItemComponent(
                        description:
                            'يكون في موقع لا ينجم عنه إزعاج أو ضرر مباشر لجيرانه.'),
                    const TextItemComponent(
                        description:
                            'يمنع منعاً باتاً التغيير في المساحة بالزيادة أو النقص مع عدم تغيير غرض الاستعمال إلا بعد موافقة الجهة المختصة.')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
