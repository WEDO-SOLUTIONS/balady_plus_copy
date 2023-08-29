import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/custom_expansion_panel.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_details_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationsNotApprovedWidget extends StatelessWidget {
  const ViolationsNotApprovedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelListWidget(
      bgColor: AppColor.white,
      children: [
        ExpansionPanelInfo(
            isExpanded: true,
            title: 'violations_not_approved'.tr(),
            body: SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return const ViolationDetailsWidget();
                },
              ),
            )),
      ],
    );
  }
}
