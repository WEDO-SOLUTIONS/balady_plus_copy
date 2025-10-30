import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';

import '../../../qa/presentation/pages/qa_page.dart';
import 'building_requirements_page.dart';

class CompliancePage extends StatefulWidget {
  const CompliancePage({super.key});

  @override
  State<CompliancePage> createState() => _CompliancePageState();
}

class _CompliancePageState extends State<CompliancePage> {
  int currentSelected = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ComplianceWidget(
          currentSelection: currentSelected,
          onSelect: (int index) {
            currentSelected = index;
            setState(() {});
          },
        ),
        if (currentSelected == 1) const Conditions(),
        if (currentSelected == 2) const FAQ(),
      ],
    );
  }
}

class FAQ extends StatelessWidget {
  const FAQ({super.key});

  @override
  Widget build(BuildContext context) {
    return const QAPage();
  }
}

class Conditions extends StatelessWidget {
  const Conditions({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuildingRequirementsPage();
  }
}

class ComplianceWidget extends StatelessWidget {
  final Function onSelect;
  final int currentSelection;
  const ComplianceWidget(
      {super.key, required this.onSelect, this.currentSelection = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with icon and text
          /* Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "موقع المنشأة يقع ضمن الخطة الأولى",
                    style: AppStyle.heading1BoldStyle.copyWith(
                        color: AppColor.textPrimaryColor, fontSize: 16),
                  ),
                  Text(
                    "لتطبيق شهادة الإمتثال ",
                    style: AppStyle.textRegularRomanStyle.copyWith(
                        color: AppColor.statusAccentColor, fontSize: 16),
                  ),
                ],
              ),

              //   Image.asset(
              //      "packages/smart_advisor/smart_advisor_assets/images/compliance.png"),
            ],
          ),
          const SizedBox(height: 30),*/
          // Horizontal buttons section
          Row(
            children: [
              // FAQ Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onSelect(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: currentSelection == 1
                          ? AppColor.statusAccentColor
                          : AppColor.surfaceTertairyColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text(
                        'بنود الإمتثال',
                        style: AppStyle.textRegularStyle.copyWith(
                          color: currentSelection == 1
                              ? AppColor.white
                              : AppColor.textPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Compliance Button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    onSelect(2);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: currentSelection == 2
                          ? AppColor.statusAccentColor
                          : AppColor.surfaceTertairyColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text(
                        'الأسئلة الشائعة',
                        style: AppStyle.textRegularStyle.copyWith(
                          color: currentSelection == 2
                              ? AppColor.white
                              : AppColor.textPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
