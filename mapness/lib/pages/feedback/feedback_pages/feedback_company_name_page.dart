import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_business_owner.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

/// TODO: Implement the FeedbackCompanyNamePage
class FeedbackCompanyNamePage extends StatelessWidget {
  final String initialCompanyName;
  final String objectId;

  const FeedbackCompanyNamePage({
    required this.initialCompanyName,
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context) => FeedbackPageTemplate(
        title: context.l10n.feedbackCompanyName,
        onSend: () {
          FeedbackSuccessRoute(objectId: objectId).push(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BaladyInput(
                labelText: 'Company name',
                labelStyle: context.textStyleV3.captionMediumRegular,
                initialValue: initialCompanyName,
                fillColor: context.colorsV2.backgroundSurface1,
                onChanged: (value) => print(value),
              ),
              Spacing.$4x.heightBox,
              BaladyInput(
                hintText: 'Add extra information',
                labelText: 'Company location',
                labelStyle: context.textStyleV3.captionMediumRegular,
                fillColor: context.colorsV2.backgroundSurface1,
                onChanged: (value) => print(value),
              ),
              Spacing.$4x.heightBox,
              FeedbackBusinessOwner(
                value: false,
                onChanged: (value) => print(value),
              ),
            ],
          ),
        ),
      );
}
