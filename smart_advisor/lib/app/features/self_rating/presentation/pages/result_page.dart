import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../home_page/presentation/pages/new_home_page.dart';
import '../../../manage_license_flow/presentation/widgets/bottom_buttons.dart';
import '../../../shared_features/new_app_bar.dart';
import '../../data/models/rating_items_response.dart';
import '../../domain/entities/submit_rating_request.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final double value;
  final List<InspectionSubClausesList> nonCompliance;
  const ResultPage(
      {super.key, required this.value, required this.nonCompliance});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              ClausesAppBar(
                title: "النتيجة النهائية",
              ),
              HalfCircularPercentageIndicator(
                percentage: widget.value,
                radius: 100,
              ),
              if (widget.nonCompliance.isEmpty) ComplianceResult(),
              if (widget.nonCompliance.isNotEmpty)
                Expanded(
                  child: NonComplianceResult(
                    nonCompliance: widget.nonCompliance,
                  ),
                ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: CustomBottomButtons(
              nextText: "العودة الى الرئيسية",
              prevText: "العودة الى الرئيسية",
              isNextOnly: true,
              isNextDisabled: false,
              onNext: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const NewHomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              onPrev: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class CircularPercentageIndicator extends StatelessWidget {
  final double percentage;

  CircularPercentageIndicator({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer background circle
        SizedBox(
          width: 160,
          height: 160,
          child: CircularProgressIndicator(
            value: 1.0, // Full circle for background
            strokeWidth: 20,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffE7EBF4)),
          ),
        ),
        // Inner background circle (progress track)
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: 1.0, // Full circle for the inner track background
            strokeWidth: 16,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
        // Progress circle showing actual percentage
        SizedBox(
          width: 150,
          height: 150,
          child: CircularProgressIndicator(
            value: percentage / 100,
            strokeWidth: 16,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            backgroundColor:
                Colors.transparent, // No background color for this layer
          ),
        ),
        // Inner grey circle
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        // Percentage text in the center
        Text(
          '${percentage.toStringAsFixed(1)}%', // Display percentage with 1 decimal
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class HalfCircularPercentageIndicator extends StatelessWidget {
  final double percentage;
  final double radius;

  HalfCircularPercentageIndicator({
    required this.percentage,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 233,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE2E9F0),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Background and progress half-circles

              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "نتيجة الامتثال",
                          style: AppStyle.textRegularRomanStyle
                              .copyWith(color: Color(0xff1E1E1E), fontSize: 14),
                        ),
                        Image.asset(
                          "packages/smart_advisor/smart_advisor_assets/icons/png/chart-button.png",
                          width: 32,
                          height: 32,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 170.0),
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: SizedBox(
                              width: radius * 2,
                              child: CustomPaint(
                                painter: HalfCirclePainter(
                                  progressColor: AppColor.statusPositiveColor,
                                  percentage: percentage,
                                  radius: radius,
                                  rounded: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                                '${percentage.toStringAsFixed(1)}%', // Display percentage with 1 decimal
                                style: TextStyle(
                                  fontSize: radius /
                                      5, // Scale font size based on radius
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                )),
                            Text(
                              ' امتثال منشأتك', // Display percentage with 1 decimal
                              style: AppStyle.textRegularRomanStyle.copyWith(
                                  color: AppColor.textSecondaryColor,
                                  fontSize: 14),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              height: 60,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xFF568F64).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  width: 1,
                                  color: const Color(0xffE2E9F0),
                                ),
                              ),
                              child: percentage < 100
                                  ? Text(
                                      "يمكنك مراجعة البنود غير الممتثلة واتخاذ الخطوات اللازمة لتعزيز مستوى الامتثال في منشأتك.",
                                      style: AppStyle.textRegularRomanStyle
                                          .copyWith(
                                              color: AppColor.textPrimaryColor,
                                              fontSize: 12),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "لقد حققت نسبة امتثال 100%. منشأتك ملتزمة بجميع المعايير المطلوبة. استمر في هذا الأداء المتميز!",
                                      style: AppStyle.textRegularRomanStyle
                                          .copyWith(
                                        color: AppColor.textPrimaryColor,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Percentage text in the center
            ],
          ),
        ],
      ),
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final Color backgroundColor;
  final Color progressColor;
  final double percentage;
  final double radius;
  final bool rounded;

  HalfCirclePainter({
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.green,
    this.percentage = 0.0,
    required this.radius,
    this.rounded = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15 // Stroke width proportional to radius
      ..strokeCap = rounded ? StrokeCap.round : StrokeCap.butt; // Rounded edges

    // Define the bounding rectangle for the arc
    final Rect arcRect =
        Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    // Draw the background half-circle
    paint.color = backgroundColor.withOpacity(0.2);
    canvas.drawArc(
      arcRect,
      math.pi, // Start angle (leftmost point)
      -math.pi, // Sweep angle (180 degrees for a half-circle)
      false,
      paint,
    );

    // Draw the progress half-circle
    paint.color = progressColor;
    double progressRadians =
        (percentage / 100) * -math.pi; // Convert percentage to radians
    canvas.drawArc(
      arcRect,
      math.pi, // Start angle (leftmost point)
      progressRadians, // Sweep angle (proportional to percentage)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RoundedNumberWidget extends StatelessWidget {
  final int number;

  RoundedNumberWidget({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, // Set width of the widget
      height: 20, // Set height of the widget
      decoration: BoxDecoration(
        color: Color(0xffFB923C), // Background color
        borderRadius: BorderRadius.circular(4), // Rounded corners
      ),
      alignment: Alignment.center, // Center the text inside the container
      child: Text(
        '$number', // Display the number passed to the widget
        style: AppStyle.textRegularRomanStyle
            .copyWith(fontSize: 9, color: AppColor.white),
      ),
    );
  }
}

class RatingWidgetItem extends StatelessWidget {
  final String item;

  const RatingWidgetItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, top: 16, bottom: 16),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE2E9F0),
        ),
      ),
      child: Column(
        children: [
          Text(
            item ?? "",
            style: AppStyle.textRegularRomanStyle.copyWith(
              color: const Color(0xA1465463),
            ),
          ),
        ],
      ),
    );
  }
}

class ComplianceResult extends StatefulWidget {
  const ComplianceResult({super.key});

  @override
  State<ComplianceResult> createState() => _ComplianceResultState();
}

class _ComplianceResultState extends State<ComplianceResult> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE9EEF5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Text(
              "الخطوة التالية",
              style: AppStyle.somarSemiBold
                  .copyWith(color: AppColor.textPrimaryColor, fontSize: 16),
            ),
            SizedBox(height: 8.0),*/
            Text(
              "يمكنك استخدام هذا التقييم بشكل دوري للتحقق من الامتثال والحفاظ على مستوى الأداء العالي في منشأتك.",
              style: AppStyle.textRegularStyle
                  .copyWith(color: AppColor.textSecondaryColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class NonComplianceResult extends StatefulWidget {
  final List<InspectionSubClausesList> nonCompliance;

  const NonComplianceResult({super.key, required this.nonCompliance});

  @override
  State<NonComplianceResult> createState() => _NonComplianceResultState();
}

class _NonComplianceResultState extends State<NonComplianceResult> {
  @override
  Widget build(BuildContext context) {
    // Refactor: Changing the data structure to store based on clause numbers and names
    Map<(String, String), List<InspectionSubClausesList>> items =
        getRatingsItems(widget.nonCompliance);

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE9EEF5),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "البنود الغير ممتثلة:",
              style: AppStyle.somarSemiBold
                  .copyWith(color: AppColor.textPrimaryColor, fontSize: 16),
            ),
            /* SizedBox(height: 8.0),
            Text(
              "الآن، وبعد معرفة نتيجتك، يمكنك مراجعة البنود غير الممتثلة واتخاذ الخطوات اللازمة لتعزيز مستوى الامتثال في منشأتك.",
              style: AppStyle.textRegularStyle
                  .copyWith(color: AppColor.textSecondaryColor, fontSize: 16),
            ),*/
            // SizedBox(height: 16.0),
            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView(
                  //  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 140),

                  children: items.entries.map((entry) {
                    print(entry);
                    final clauseName = entry.key;
                    final subClauses = entry.value;
                    return Expansion(
                        clauseName: clauseName.$2, items: subClauses);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to map non-compliance items by clause names
  /*Map<(String, String), List<InspectionSubClausesList>> getRatingsItems(
      final List<InspectionSubClausesList>? items) {
    Map<(String, String), List<InspectionSubClausesList>> data = {};

    for (int i = 0; i < (items?.length ?? 0); i++) {
      InspectionSubClausesList item = items![i];

      if (data.containsKey((item.clauseNo, item.clauseName))) {
        List<InspectionSubClausesList> ratings =
            data[(item.clauseNo, item.clauseName)] ?? [];
        ratings.add(item);
        data.putIfAbsent(
            (item.clauseNo!, item.clauseName ?? ""), () => ratings);
      } else {
        data.putIfAbsent((item.clauseNo!, item.clauseName ?? ""), () => [item]);
      }
    }

    return data;
  }*/

  Map<(String, String), List<InspectionSubClausesList>> getRatingsItems(
      final List<InspectionSubClausesList>? items) {
    Map<(String, String), List<InspectionSubClausesList>> data = {};

    for (int i = 0; i < (items?.length ?? 0); i++) {
      InspectionSubClausesList item = items![i];

      if (!data.containsKey((item.getClausesName(), item.getClausesName()))) {
        // If clauseName not in the map, initialize with the current item
        data[(item.getClausesName(), item.getClausesName())] = [item];
      } else {
        data[(item.getClausesName(), item.getClausesName())]!.add(item);
      }
    }

    return data;
  }
}

class Expansion extends StatefulWidget {
  const Expansion({
    super.key,
    required this.clauseName,
    required this.items,
  });

  final String clauseName;
  final List<InspectionSubClausesList> items;

  @override
  State<Expansion> createState() => _ExpansionState();
}

class _ExpansionState extends State<Expansion> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
                color: Color(
                    0xFFF7F9FA), // Light background color inside the border
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Color(0xff568F64), // Light green border color
                  width: 1,
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        "packages/smart_advisor/smart_advisor_assets/icons/png/clause_icon.png",
                        height: 45,
                        width: 45,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: Text(
                          widget.clauseName,
                          style: AppStyle.textRegularRomanStyle,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    RoundedNumberWidget(
                      number: widget.items.length,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    isExpanded == true
                        ? Icon(
                            Icons.keyboard_arrow_up,
                            color: AppColor.textPrimaryColor,
                          )
                        : Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColor.textPrimaryColor,
                          )
                  ],
                )
              ],
            ),
          ),
        ),
        if (isExpanded)
          ...widget.items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SubClauesWidget(
                item: item.subClauseName ?? "",
              ),
            );
          }).toList()
      ],
    );
  }
}

class SubClauesWidget extends StatelessWidget {
  final String item;
  const SubClauesWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE9EEF5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item,
            style: AppStyle.textRegularRomanStyle.copyWith(
              color: const Color(0xA1465463),
            ),
          ),
        ],
      ),
    );
  }
}

class ClausesAppBar extends StatelessWidget {
  final String title;
  const ClausesAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0x3398FCFF), // 20% opacity
            Color(0x00ADC587), // 0% opacity
          ],
          radius:
              1.0, // Adjust the radius to control the spread of the gradient
          center: Alignment.topLeft, // Set the center of the gradient
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 12,
          left: 50,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    NavigationService.navigatorKey.currentState!.pop(context);
                  },
                  icon: SvgPicture.asset(
                    IconPath.newBackIcon,
                    width: 24,
                    height: 24,
                    color: AppColor.textPrimaryColor, //statusAccentColor,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          style: AppStyle.callout1BoldStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
