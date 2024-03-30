import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/comliance_request_details.dart';

class ComplianceClauseSubmitItem extends StatefulWidget {
  final EmtithalItem item;
  const ComplianceClauseSubmitItem({super.key, required this.item});

  @override
  State<ComplianceClauseSubmitItem> createState() =>
      _ComplianceClauseSubmitItemState();
}

class _ComplianceClauseSubmitItemState
    extends State<ComplianceClauseSubmitItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: const Color(0xffD4D4D8), width: 1)),
        child: Column(
          children: [
            Row(
              children: [
                CustomTextWidget(
                  widget.item.itemDesc ?? "",
                  fontColor: AppColor.blackModern800Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 14,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColor.primary300Light,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColor.white,
                  ),
                ),
              ],
            ),

            // if (_isExpanded)
          ],
        ),
      ),
    );
  }
}
