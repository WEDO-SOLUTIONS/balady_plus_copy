import 'dart:convert';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../core/image_path.dart';
import '../home/custom_app_bar.dart';
import '../home/stack_image.dart';
import '../home/text_item.dart';
import '../list/list_item/general_provisions/provisions_model.dart';
import '../list/list_item/requir_item/item.dart';
import '../list/list_item/requir_item/conditions_model.dart';
import '../list/list_item/requir_item/container_requir.dart';
import '../list/list_item/requir_item/requir_item.dart';
import '../list/list_item/terms/term_model.dart';
import '../list/list_item/terms/terms_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompliancePDFHomePage extends StatefulWidget {
  const CompliancePDFHomePage({super.key});

  @override
  State<CompliancePDFHomePage> createState() => _CompliancePDFHomePageState();
}

class _CompliancePDFHomePageState extends State<CompliancePDFHomePage> {
  List<ProvisionsModel> data = [];
  List<TermModel> data1 = [];
  List<ConditionsModel> data2 = [];

  Future<void> readdata() async {
    if (data.isEmpty || data1.isEmpty || data2.isEmpty) {
      String aa = await rootBundle
          .loadString("assets/compliance_pdf/text/provisions.json");
      var B = json.decode(aa);

      {
        List<ProvisionsModel>? model = B != null
            ? List<ProvisionsModel>.from(
                B.map((x) => ProvisionsModel.fromMap(x)))
            : null;
        data = model ?? [];
        setState(() {});
      }

      await readdata1();
      await readdata2();
    }
  }

  Future<void> readdata1() async {
    String ad =
        await rootBundle.loadString("assets/compliance_pdf/text/defi.json");
    var A = json.decode(ad);
    print(A);
    {
      List<TermModel>? model = A != null
          ? List<TermModel>.from(A.map((x) => TermModel.fromMap(x)))
          : null;
      data1 = model ?? [];
      setState(() {});
    }
  }

  Future<void> readdata2() async {
    String qa = await rootBundle
        .loadString("assets/compliance_pdf/text/conditions.json");
    var r = json.decode(qa);
    print(r);
    {
      List<ConditionsModel>? model = r != null
          ? List<ConditionsModel>.from(r.map((x) => ConditionsModel.fromMap(x)))
          : null;
      data2 = model ?? [];
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    /* readdata();
    readdata1();
    readdata2();*/
  }

  @override
  Widget build(BuildContext context) {
    readdata();
    return Scaffold(
      appBar: const CustomAppBar(
        icon: ImagePath.closebutton,
        name: 'شهادة امتثال المباني',
        listicon: ImagePath.frame,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextItem(
                  name: 'مقدمة ',
                  size: 17,
                  desc:
                      'أعد هذا الدليل بناء على ما نصت عليه المادة الخامسة من نظام البلديات والقري الصادر بالمرسوم الملكي رقم (م/5)وتاريخ 1397/2/21ه التي حددت دور الوزارة بالقيام بجميع الاعمال المتعلقة بتنظيم البلدة وإصلاحها وتجميلها والمحافظه علي الصحة والراحة والسلامة العامة، ولما أن معالجة التشوه البصري في المدن على رأس أولو يات منظومة العمل البلدي ، لما يعكس ذلك صور ة لائقة عن المملكة وشعبها، فضلا عن تعزيز الوعي والسلوك الحضاري للمستفيد والمستثمر بأهمية المحافظة على البيئة وحماية المرافق العامة. \nوتهدف شهادة امتثال المباني إلى ضمان إلتزام ملاك حق الانتفاع للمباني الواقعة في المناطق المحددة في المستكشف الجغرافي لشهادة امتثال المباني في منصة بلدي ، بعدم ا ستحداث عناصر ومكونات مخالفة للترخيص مما يسهم في الحد من التشوه البصري في تلك المباني والارتقاء بجودة المشهد الحضر ي في المدن.',
                ),
                const TextItem(
                  name: 'نطاق التطبيق',
                  size: 17,
                  desc:
                      'يتم تطبيق إصدار شهادة امتثال المباني على جميع المباني الواقعة على الشوارع التجارية المحددة في المستكشف الجغرافي لشهادة امتثال المباني في منصة بلدي',
                ),
                const StackImage(name: 'المصطلحات والتعريفات'),
                const TextItem(
                  name: 'المصطلحات والتعريفات',
                  size: 18,
                  desc:
                      'يقصد بالألفاظ والمصطلحات الآتية - أينما وردت في هذه الدليل - المعاني المبينة أمام كل منها، ما لم يقتض السياق غير ذلك',
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data1.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return TermsItem(
                        name: data1[index].name, desc: data1[index].desc);
                  },
                ),
                const StackImage(name: 'إشتراطات شهادة امتثال المباني'),
                const TextItem(
                  name: 'اشتراطات شهادة امتثال المباني',
                  size: 18,
                  desc:
                      'يشترط لإصدار شهادة امتثال المبنى وفق هذا الدليل، خلوه من المخالفات الآتية:',
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data2.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return RequirementsItem(
                      desc: data2[index].desc,
                      image: data2[index].photo,
                    );
                  },
                ),
                const ContainerRequir(),
                const StackImage(
                    name:
                        '    متطلبات وإجراءات إصدار\nشهادة امتثال المباني وتجديدها'),
                const TextItem(
                  name: 'متطلبات الحصول على شهادة امتثال المباني:',
                  size: 18,
                  desc:
                      'يلزم تحقيق المتطلبات وتقديم الوثائق الآتية للحصول على شهادة امتثال المباني:\n1. رخصة بناء، أو صك ملكية، أو حجة استحكام، أو عقد إستثماري لكامل المبنى، أو فاتورة للكهرباء أو المياه للمبنى\n2. رفع الطلب عبر منصة بلدي .\n3. موافقه الأمانة/البلدية.',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    'إجراءات إصدار شهادة امتثال المباني:',
                    style: TextStyle(
                      color: Color(0xFF145E75),
                      fontSize: 18,
                      fontFamily: Constants.appFontType,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const TextItem(
                  name: '1. المباني الجديدة:',
                  size: 18,
                  desc:
                      'تصدر شهادة امتثال المباني بشكل تلقائي بعد إصدار شهادة الاشغال للمبنى وفق المحددة في الأحكام العامة على أن يقوم مالك حق الانتفاع بتجديدها بعد انتهاء تلك المدة.',
                ),
                const TextItem(
                  name: '2. المباني القائمة:',
                  size: 18,
                  desc:
                      'لما لك حق الانتفاع خيارين لإصدار شهادة امتثال المبنى، الخيار الأول: من خلال طلب ( مالك حق الانتفاع) بنفسه مباشرة، والخيار الثاني: من خلال تفويض مكتب هندسي مؤهل، وذلك من خلال الخطوات التالية:',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
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
                const Item(
                  desc: '1. تسجيل الدخول عبر منصة بلدي',
                ),
                const Item(
                  desc: '2. الدخول على خدمة إصدار شهادة امتثال المباني',
                ),
                const Item(
                  desc:
                      '3. إدخال البيانات المنصوص عليها في الفقرة رقم (1) من متطلبات الحصول على شهادة امتثال المباني، واستكمال كافة البيانات المطلوبه في نموذج طلب إصدار شهادة الامتثال.',
                ),
                const Item(
                  desc:
                      '4. الإقرار في الطلب باستيفاء جميع اشتراطات ومتطلبات إصدار شهادة امتثال المباني الواردة في هذا الدليل.',
                ),
                const Item(
                  desc:
                      '5. قيام الأمانة/البلدية بجدولة زيارة للتحقق من البيانات المدخلة.',
                ),
                const Item(
                  desc:
                      '6. موافقه الأمانة/البلدية على الطلب بعد التأكد من عدم وجود المخالفات المذكورة في هذا الدليل على المبنى.',
                ),
                const Item(
                  desc: '7. اصدار شهاده امتثال المباني للمبني',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                const Item(
                  desc: '1. دخول المستفيد على منصة بلدي',
                ),
                const Item(
                  desc:
                      '2. تفو يض مكتب هند سي مؤهل لاستكمال إجراءات إصدار شهادة امتثال المباني للمبنى.',
                ),
                const Item(
                  desc:
                      '3. قيام المكتب الهندسي المؤهل بإدخال البيانات المنصوص عليها في الفقرة رقم (1) من متطلبات الحصول على شهادة امتثال المباني، واستكمال كافه البيانات المطلوبة في نموذج طلب إصدار شهادة الامتثال.',
                ),
                const Item(
                    desc:
                        '4. قيام المكتب الهندسي المؤهل بالتحقق استيفاء المبنى لجميع اشتراطات ومتطلبات شهادة امتثال المباني، وعدم وجود المخالفات المذكورة في هذا الدليل على المبنى.'),
                const Item(
                  desc:
                      '5. الإقرار باستيفاء جميع اشتراطات ومتطلبات إصدار شهادة امتثال المباني الواردة في هذا الدليل.',
                ),
                const Item(
                  desc:
                      '6. يقوم المكتب الهند سي المؤهل باستكمال إجراءات إصدار الشهادة وفق الإجراءات المتبعة في الأمانة/البلدية.',
                ),
                const Item(
                  desc:
                      '7. إصدار شهادة امتثال المباني من قبل الأمانة/البلدية.',
                ),
                const StackImage(name: 'الأحكام العامة'),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'أحكام عامة',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF145E75),
                      fontSize: 17,
                      fontFamily: 'packages/balady_uikit/Frutiger',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Item(desc: data[index].desc);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
