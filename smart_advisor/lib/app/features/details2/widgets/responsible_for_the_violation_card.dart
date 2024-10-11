import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/home2/widgets/tags_text.dart';
import 'package:flutter/material.dart';

class ResponsibleForTheViolationCard extends StatefulWidget {
  final String title;
  final List<String> responsible;
  const ResponsibleForTheViolationCard(
      {super.key, required this.title, required this.responsible});

  @override
  State<ResponsibleForTheViolationCard> createState() =>
      _ResponsibleForTheViolationCardState();
}

class _ResponsibleForTheViolationCardState
    extends State<ResponsibleForTheViolationCard> {
  final isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.surfaceSecondaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: AppStyle.footNoteBoldStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.responsible
                    .map((e) => RoundedCardWithText(text: e))
                    .toList())
          ],
        ),
      ),
    );
  }
}
