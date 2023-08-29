import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/violation_results_page.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_address_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_category_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_location_widgets/violation_title_location_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationLocationListWidget extends StatelessWidget {
  const ViolationLocationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 343,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 24,
            ),
            const ViolationLocationTitleWidget(),
            const SizedBox(
              height: 24,
            ),
            const ViolationAddressSectionWidget(),
            const SizedBox(
              height: 12,
            ),
            const ViolationCategoryWidget(),
            const SizedBox(height: 200),
            CustomElevatedButtonWidget(
              text: 'result-1'.tr(),
              btnColor: AppColor.blueSkyLight800,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViolationResultsPage()),
                );
              },
            ),
          ]),
        ),
      ],
    );
  }
}
