import '../../../../../core/services/local/navigation_services.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/details_fine_fees.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/language.dart';

// ignore: constant_identifier_names

class BottomSheetScreen extends StatefulWidget {
  const BottomSheetScreen({super.key});

  @override
  State<BottomSheetScreen> createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text('show'.tr()),
            onPressed: () async {
              showModalBottomSheet(
                backgroundColor: Color(0xff000000),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) => BottomSheetWidget(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: 10,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Color(0xff2E7998)),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero, topRight: Radius.zero)),
            padding: const EdgeInsets.all(12.0),
            height: MediaQuery.of(context).size.height / 1.2,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 231, 230, 230)),
                          child: IconButton(
                            onPressed: () {
                              NavigationService.navigatorKey.currentState!
                                  .pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: const Color.fromARGB(128, 0, 0, 0),
                            ),
                          ),
                        ),
                        Text(
                          ("details").tr(),
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      ("violation").tr(),
                      style: GoogleFonts.cairo(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: const Color.fromRGBO(142, 154, 158, 0.096)),
                      child: Align(
                          alignment: FractionalOffset.centerRight,
                          child: Text(
                            'إجراءات السلامة',
                            style: GoogleFonts.cairo(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: 288,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  const Color.fromRGBO(142, 154, 158, 0.096)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          children: [
                            Text(
                              'التدريب على خطة الإخلاء أثناء الحريق أو الطوارئ وكيفية التعامل مع المواد والمركبات الخطرة.',
                              style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff656A73)),
                            ),
                            Text(
                              '- توفير وسائل الأمن والسلامة  (حسب تعليمات الدفاع المدني) مثل طفايات الحريق ويكون مثبت عليها بطاقة تاريخ الصلاحية ومواعيد إجراء الاختبارات',
                              style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff656A73)),
                            ),
                            Text(
                              '- موافقة الدفاع المدنى على الموقع للمحلات التى تكون عرضة لأخطار الحريق',
                              style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff656A73)),
                            ),
                            Text(
                              '- يجب توفير صندوق للإسعافات الأولية يكون مُزوّدا بالمواد ذات الأهمية الطبيّة مثل: الأشرطة اللاصقة الملونة، والأربطة الطبية، والقطن والشاش، والمواد المطهرِّة، وأي مواد آخرى للعناية بالجروح.',
                              style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff656A73)),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          width: 170,
                          height: 70,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color.fromRGBO(
                                      142, 154, 158, 0.096)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'نوع الرقابه',
                                    style: GoogleFonts.cairo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  SvgPicture.asset(
                                      'packages/smart_advisor/smart_advisor_assets/images/Eye.svg')
                                ],
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'الرقابة على الأسواق',
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff656A73)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 170,
                          height: 70,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromRGBO(142, 154, 158, 0.096)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'رقم اللائحة',
                                    style: GoogleFonts.cairo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  SvgPicture.asset(
                                      'packages/smart_advisor/smart_advisor_assets/images/Cardss.svg')
                                ],
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                '1/3/32',
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff656A73)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DetailsFineFees(),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
