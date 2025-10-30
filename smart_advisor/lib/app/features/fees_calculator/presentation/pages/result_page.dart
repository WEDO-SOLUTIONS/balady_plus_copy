import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../shared_features/new_app_bar.dart';
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
    return Stack(
      children: [
        Scaffold(
          body: Stack(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF8FFEC)
                          .withOpacity(0.73), // Lightest color with opacity
                      const Color(0xFFEBE9FF)
                          .withOpacity(0.52), // Mid color with opacity
                      const Color(0xFFEAF6D8).withOpacity(0.73),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [
                      0.0,
                      0.5,
                      1.0
                    ], // Adjust the stop points for smooth gradient transition
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewAppBar(
                      title: ("final_result").tr(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFCCC9DC).withOpacity(
                                        0.24), // Color with 24% opacity
                                    offset: const Offset(0, 6), // X: 0, Y: 6
                                    blurRadius: 20, // Blur radius of 20
                                    spreadRadius: 0, // Spread of 0
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Image.asset(
                                      "packages/smart_advisor/smart_advisor_assets/images/background_calculator.png"),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("تكلفة الرسوم الاجمالية",
                                                textAlign: TextAlign.start,
                                                style: AppStyle
                                                    .textRegularRomanStyle
                                                    .copyWith(fontSize: 16)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                widget.args.totalFees
                                                    .toString(),
                                                textAlign: TextAlign.start,
                                                style: AppStyle
                                                    .heading1BoldStyle
                                                    .copyWith(
                                                        fontSize: 35,
                                                        color: AppColor
                                                            .statusAccentColor)),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("ريال",
                                                textAlign: TextAlign.start,
                                                style: AppStyle
                                                    .textRegularRomanStyle
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: AppColor
                                                            .statusAccentColor)),
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
                                    title: widget.args.items![index]
                                            .costItemDescription ??
                                        "",
                                    subTitle: widget
                                        .args.items![index].costItemValue
                                        .toString(),
                                  );
                                }),
                            const SizedBox(
                              height: 60,
                            ),
                            CustomButton(
                                btnBorderColor: AppColor.statusAccentColor,
                                btnColor: Colors.transparent,
                                textColor: AppColor.statusAccentColor,
                                onPress: () {
                                  NavigationService.navigatorKey.currentState!
                                      .pop(context);

                                  NavigationService.navigatorKey.currentState!
                                      .pop(context);
                                },
                                text: "الرجوع إلى التفاصيل"),
                            SizedBox(
                              height: 16,
                            ),
                            CustomButton(
                                onPress: () {
                                  NavigationService.navigatorKey.currentState!
                                      .pop(context);
                                },
                                text: "حساب رسوم اخرى")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
