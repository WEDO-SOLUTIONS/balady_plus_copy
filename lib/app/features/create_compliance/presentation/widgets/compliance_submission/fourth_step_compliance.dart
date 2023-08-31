import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_image_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class FourthStepCompliance extends StatelessWidget {
  const FourthStepCompliance({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ComplianceSubmitTitle(
              title: 'compliance_clauses_title'.tr(),
              subtitle: 'compliance_clauses_subtitle'.tr(),
            ),
            const SizedBox(
              height: 10,
            ),
            const ComplianceImageWidget(),
            const SizedBox(
              height: 10,
            ),
            const ComplianceImageWidget(),
            const SizedBox(
              height: 10,
            ),
            const ComplianceImageWidget(),
            const SizedBox(
              height: 10,
            ),
            ElevatedButtonWidget.next(
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
