import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';

import '../../../home/custom_app_bar.dart';
import '../../../home/text_item.dart';
import '../requir_item/item.dart';

class RequirBuilding extends StatelessWidget {
  const RequirBuilding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        icon: ImagePath.arrowright,
        name: 'متطلبات وإجراءات إصدا...',
        listicon: ImagePath.frame,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextItem(
                name: 'متطلبات الحصول على شهادة امتثال المباني:',
                size: 18,
                desc:
                    'يلزم تحقيق المتطلبات وتقديم الوثائق الآتية للحصول على شهادة امتثال المباني:\n1. رخصة بناء، أو صك ملكية، أو حجة استحكام، أو عقد إستثماري لكامل المبنى، أو فاتورة للكهرباء أو المياه للمبنى\n2. رفع الطلب عبر منصة بلدي .\n3. موافقه الأمانة/البلدية.',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'إجراءات إصدار شهادة امتثال المباني:',
                  style: TextStyle(
                    color: Color(0xFF145E75),
                    fontSize: 18,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextItem(
                name: '1. المباني الجديدة:',
                size: 18,
                desc:
                    'تصدر شهادة امتثال المباني بشكل تلقائي بعد إصدار شهادة الاشغال للمبنى وفق المحددة في الأحكام العامة على أن يقوم مالك حق الانتفاع بتجديدها بعد انتهاء تلك المدة.',
              ),
              TextItem(
                name: '2. المباني القائمة:',
                size: 18,
                desc:
                    'لما لك حق الانتفاع خيارين لإصدار شهادة امتثال المبنى، الخيار الأول: من خلال طلب ( مالك حق الانتفاع) بنفسه مباشرة، والخيار الثاني: من خلال تفويض مكتب هندسي مؤهل، وذلك من خلال الخطوات التالية:',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'من خلال مالك حق الانتفاع بنفسه مباشرة:',
                  style: TextStyle(
                    color: Color(0xFF145E75),
                    fontSize: 16,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Item(
                desc: '1. تسجيل الدخول عبر منصة بلدي',
              ),
              Item(
                desc: '2. الدخول على خدمة إصدار شهادة امتثال المباني',
              ),
              Item(
                desc:
                    '3. إدخال البيانات المنصوص عليها في الفقرة رقم (1) من متطلبات الحصول على شهادة امتثال المباني، واستكمال كافة البيانات المطلوبه في نموذج طلب إصدار شهادة الامتثال.',
              ),
              Item(
                desc:
                    '4. الإقرار في الطلب باستيفاء جميع اشتراطات ومتطلبات إصدار شهادة امتثال المباني الواردة في هذا الدليل.',
              ),
              Item(
                desc:
                    '5. قيام الأمانة/البلدية بجدولة زيارة للتحقق من البيانات المدخلة.',
              ),
              Item(
                desc:
                    '6. موافقه الأمانة/البلدية على الطلب بعد التأكد من عدم وجود المخالفات المذكورة في هذا الدليل على المبنى.',
              ),
              Item(
                desc: '7. اصدار شهاده امتثال المباني للمبني',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Text(
                  'من خلال المكتب الهندسي المؤهل',
                  style: TextStyle(
                    color: Color(0xFF145E75),
                    fontSize: 16,
                    fontFamily: 'packages/balady_uikit/Frutiger',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Item(
                desc: '1. دخول المستفيد على منصة بلدي',
              ),
              Item(
                desc:
                    '2. تفو يض مكتب هند سي مؤهل لاستكمال إجراءات إصدار شهادة امتثال المباني للمبنى.',
              ),
              Item(
                desc:
                    '3. قيام المكتب الهندسي المؤهل بإدخال البيانات المنصوص عليها في الفقرة رقم (1) من متطلبات الحصول على شهادة امتثال المباني، واستكمال كافه البيانات المطلوبة في نموذج طلب إصدار شهادة الامتثال.',
              ),
              Item(
                  desc:
                      '4. قيام المكتب الهندسي المؤهل بالتحقق استيفاء المبنى لجميع اشتراطات ومتطلبات شهادة امتثال المباني، وعدم وجود المخالفات المذكورة في هذا الدليل على المبنى.'),
              Item(
                desc:
                    '5. الإقرار باستيفاء جميع اشتراطات ومتطلبات إصدار شهادة امتثال المباني الواردة في هذا الدليل.',
              ),
              Item(
                desc:
                    '6. يقوم المكتب الهند سي المؤهل باستكمال إجراءات إصدار الشهادة وفق الإجراءات المتبعة في الأمانة/البلدية.',
              ),
              Item(
                desc: '7. إصدار شهادة امتثال المباني من قبل الأمانة/البلدية.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
