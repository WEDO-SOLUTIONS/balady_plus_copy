import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_type_item_widget.dart';

class FeedbackSelectOptionsWidget extends ConsumerWidget {
  final int objectId;
  const FeedbackSelectOptionsWidget({required this.objectId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poiData = ref.watch(poiFeedbackProvider(objectId));
    final categories = ref.watch(feedbackCategoriesProvider);

    if (poiData.isLoading || categories.isLoading) {
      return Center(child: Loading.large());
    } else if (poiData.hasError || categories.hasError) {
      return Center(child: Text(context.l10n.failedToLoadData));
    }

    final poiDataValue = poiData.value;
    final categoriesValue = categories.value;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(poiDataValue?.title ?? '', style: context.textStyle.callout),
              const SizedBox(height: 5),
              Text(poiDataValue?.makeAddress() ?? '',
                  style: context.textStyleV3.bodySmallRegular),
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
                icon: item.icon,
                onTap: () => _onTap(
                  context,
                  item,
                  poiDataValue?.id?.objectId,
                ),
              );
            },
            separatorBuilder: (context, index) => const _Divider(),
            itemCount: categoriesValue!.length,
          ),
        ),
      ],
    );
  }

  void _onTap(BuildContext context, scheme, int? objectId) {
    if (objectId == null) {
      return;
    }
    final objectId_ = objectId.toString();
    FeedbackRoute(objectId: objectId_, schemeId: scheme.id).push(context);
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Divider(
        color: context.colorsV2.borderSoft,
        height: 8,
        thickness: 0.5,
        indent: 52,
      );
}
