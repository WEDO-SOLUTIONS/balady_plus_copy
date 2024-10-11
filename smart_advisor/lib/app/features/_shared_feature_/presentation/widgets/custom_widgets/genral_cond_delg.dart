import '../../../../../core/services/local/navigation_services.dart';
import '../../../../shared_features/widgets/text_item_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GenralCondDelg extends StatelessWidget {
  const GenralCondDelg({super.key});

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
                  InkWell(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!
                            .pop(context);
                      },
                      child: SvgPicture.asset(
                          'packages/smart_advisor/smart_advisor_assets/images/close.svg')),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const TextItemComponent(description: 'سجل تجاري للنشاط.'),
              const TextItemComponent(
                  description:
                      'الالتزام بنظام اجراءات التراخيص البلدية ولائحته التنفيذية'),
              const TextItemComponent(
                  description:
                      'تطبيق متطلبات ذوي الاحتياجات الخاصة في تصميم منشآت المحطة ومركز الخدمة وفقا للاشتراطات الخاصة بالخدمات البلدية المتعلقة بذوي الاحتياجات الخاصة الصادرة من الوزارة.'),
              const TextItemComponent(
                  description:
                      'الالتزام بتحقيق متطلبات الأشخاص ذوي الإعاقة بهدف تيسير وتسهيل حركتهم وتهيئة الأوضاع والابعاد والفراغات المناسبة لاستخدامهم طبقا لمتطلبات الفصل (1009)والباب (11)من كود البناء السعودي (SBC-201) وحسب الدليل المبسط لمعايير الوصول الشامل للمنشآت التجارية')
            ],
          ),
        ),
      ),
    );
  }
}
