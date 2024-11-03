import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../shared_features/new_app_bar.dart';
import '../../data/models/rating_items_response.dart';
import '../../domain/entities/submit_rating_request.dart';

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
    return Stack(
      children: [
        Container(
          height: 400,
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
        Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: Column(
            children: [
              NewAppBar(
                title: "درجة امتثال منشأتك",
                showClose: true,
              ),
              CircularPercentageIndicator(
                percentage: widget.value,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "البنود الغير ممتثلة",
                              style: AppStyle.somarSemiBold.copyWith(
                                  color: AppColor.textPrimaryColor,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            RoundedNumberWidget(
                              number: widget.nonCompliance.length,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.nonCompliance.length,
                            itemBuilder: (ctx, index) {
                              return RatingWidgetItem(
                                  item: widget
                                          .nonCompliance[index].subClauseName ??
                                      "");
                            },
                          ),
                        ),
                        CustomButton(
                          text: "الرئيسية",
                          onPress: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
          width: 110,
          height: 110,
          child: CircularProgressIndicator(
            value: 1.0, // Full circle for background
            strokeWidth: 22,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xffE7EBF4)),
          ),
        ),
        // Inner background circle (progress track)
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: 1.0, // Full circle for the inner track background
            strokeWidth: 16,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
        // Progress circle showing actual percentage
        SizedBox(
          width: 100,
          height: 100,
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
          width: 70,
          height: 70,
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
