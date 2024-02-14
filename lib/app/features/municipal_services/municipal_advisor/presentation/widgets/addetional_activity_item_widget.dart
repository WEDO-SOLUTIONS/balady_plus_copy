import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../domain/entities/activity_details_entity.dart';

class AddetionalActivityItemWidget extends StatelessWidget {
  final ActivityDetailsEntity item;
  final Function onDelete;
  final Function onChangedArea;
  const AddetionalActivityItemWidget(
      {super.key,
      required this.item,
      required this.onDelete,
      required this.onChangedArea});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomTextWidget(
                  item.activityName,
                  fontSize: 16,
                  maxLines: 10,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.black700,
                ),
              ),
              IconButton(
                  onPressed: () {
                    onDelete();
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextFieldWidget(
            label: 'area'.tr(),
            hintText: 'area'.tr(),
            isDigitsOnly: true,
            keyboardType: TextInputType.number,
            suffixIcon: CustomTextWidget(
              "m2".tr(),
              fontSize: 12,
              fontWeight: AppFontWeight.semiBold,
              fontColor: AppColor.blackModern400Light,
            ),
            bottomMargin: 24,
            onChanged: (value) {
              onChangedArea(value);
            },
          ),
        ],
      ),
    );
  }
}
