import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/feedback/feedback_category.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/widgets/feedback/feedback_type_item_widget.dart';

class FeedbackSelectOptionsWidget extends StatelessWidget {
  final DirectoryObjectMessage poiDataValue;
  final List<FeedbackCategoryEntity> categoriesValue;
  final void Function(FeedbackCategoryEntity, int?) onTap;

  const FeedbackSelectOptionsWidget({
    required this.poiDataValue,
    required this.categoriesValue,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(poiDataValue.title, style: context.textStyle.callout),
                const SizedBox(height: 5),
                Text(poiDataValue.makeAddress(), style: context.textStyleV3.bodySmallRegular),
              ],
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          Material(
            shape: smoothBorder(RadiusBorder.l),
            color: context.colorsV2.backgroundSurface1,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 6),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = categoriesValue[index];
                return FeedbackTypeItemWidget(
                  title: item.name,
                  iconUrl: item.iconUrl,
                  onTap: () => onTap(
                    item,
                    poiDataValue.id?.objectId,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: context.colorsV2.borderSoft,
                height: 8,
                thickness: 0.5,
                indent: 52,
              ),
              itemCount: categoriesValue.length,
            ),
          ),
        ],
      );
}
