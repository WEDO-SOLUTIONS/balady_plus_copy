import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/local/navigation_services.dart';
import '/app/features/fees_calculator/presentation/widgets/calculator_item.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/core/utils/constants/language.dart';

import '../../domain/entities/fees_calculator_response.dart';

class CalculatorResultPage extends StatefulWidget {
  final FeesCalculatorResponse args;
  const CalculatorResultPage({super.key, required this.args});

  @override
  State<CalculatorResultPage> createState() => _CalculatorResultPageState();
}

class _CalculatorResultPageState extends State<CalculatorResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ("final_result").tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  Image.asset(
                      "packages/smart_advisor/smart_advisor_assets/images/background_calculator.png"),
                  Container(
                    padding: const EdgeInsets.only(top: 20, right: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(widget.args.totalFees.toString(),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.cairo(
                                  color: const Color(0xFFFFFFFF),
                                  fontSize: 49,
                                  fontWeight: FontWeight.w800,
                                )),
                            Text("ريال",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.cairo(
                                  color: const Color(0xFFFFFFFF),
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text("تكلفة الرسوم الاجمالية",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.cairo(
                                  color: const Color(0xFFFFFFFF),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text("مقسمة حسب التالي",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.cairo(
                      color: const Color(0xFF000000),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.args.items?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return CalculatorItem(
                    title: widget.args.items![index].costItemDescription ?? "",
                    subTitle:
                        widget.args.items![index].costItemValue.toString(),
                  );
                }),
            const SizedBox(
              height: 60,
            ),
            CustomButton(
                onPress: () {
                  NavigationService.navigatorKey.currentState!.pop(context);
                },
                text: "حساب رسوم اخرى")
          ],
        ),
      ),
    );
  }
}
