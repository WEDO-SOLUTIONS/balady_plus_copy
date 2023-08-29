import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/custom_expansion_panel.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_list_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/pages/approved_violation_page.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'violation_details_widget.dart';

class ViolationApprovedWidget extends StatelessWidget {
  const ViolationApprovedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelListWidget(
      bgColor: AppColor.white,
      children: [
        ExpansionPanelInfo(
            isExpanded: true,
            title: 'violations_approved'.tr(),
            body: SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ApprovedViolationPage()));
                      },
                      child: const ViolationDetailsWidget());
                },
              ),
            )),
      ],
    );
  }
}
