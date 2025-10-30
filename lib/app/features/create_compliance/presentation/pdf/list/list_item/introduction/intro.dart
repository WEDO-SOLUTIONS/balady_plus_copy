import 'package:flutter/material.dart';
import '../../../home/custom_app_bar.dart';
import '../../../home/text_item.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        icon: ImagePath.arrowright,
        name: 'مقدمة',
        listicon: ImagePath.frame,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextItem(
                name: 'مقدمة ',
                size: 17,
                desc:
                    'أعد هذا الدليل بناء على ما نصت عليه المادة الخامسة من نظام البلديات والقري الصادر بالمرسوم الملكي رقم (م/5)وتاريخ 1397/2/21ه التي حددت دور الوزارة بالقيام بجميع الاعمال المتعلقة بتنظيم البلدة وإصلاحها وتجميلها والمحافظه علي الصحة والراحة والسلامة العامة، ولما أن معالجة التشوه البصري في المدن على رأس أولو يات منظومة العمل البلدي ، لما يعكس ذلك صور ة لائقة عن المملكة وشعبها، فضلا عن تعزيز الوعي والسلوك الحضاري للمستفيد والمستثمر بأهمية المحافظة على البيئة وحماية المرافق العامة. \nوتهدف شهادة امتثال المباني إلى ضمان إلتزام ملاك حق الانتفاع للمباني الواقعة في المناطق المحددة في المستكشف الجغرافي لشهادة امتثال المباني في منصة بلدي ، بعدم ا ستحداث عناصر ومكونات مخالفة للترخيص مما يسهم في الحد من التشوه البصري في تلك المباني والارتقاء بجودة المشهد الحضر ي في المدن.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
