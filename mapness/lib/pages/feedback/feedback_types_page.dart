import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/fields_entity/feedback_icon.dart';
import 'package:mapness/features/feedback/feedback_categories.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_form_container.dart';

class FeedbackTypesPage extends ConsumerWidget {
  final String? objectId;

  const FeedbackTypesPage({
    required this.objectId,
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    return FeedbackFormContainer(
      title: context.l10n.feedbackWhatsWrong,
      isSendVisible: false,
      child: Consumer(
        builder: (context, ref, child) {
          if (objectId == null) {
            return const SizedBox();
          }
          final id = int.tryParse(objectId!);
          if (id == null) {
            return Center(child: Loading.large());
          }
          final poiData = ref.watch(poiFeedbackProvider(id));
          final categories = ref.watch(feedbackCategoriesProvider);

          if (poiData.isLoading || categories.isLoading) {
            return Center(child: Loading.large());
          } else if (poiData.hasError || categories.hasError) {
            return Center(
                child: Text(
                    '${context.l10n.failedToLoadData}\n\n${poiData.error}\n\n${categories.error}\n${categories.stackTrace}'));
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
                    Text(poiDataValue?.title ?? '',
                        style: context.textStyle.callout),
                    const SizedBox(height: 5),
                    // Text(poiDataValue?.makeAddress() ?? '',
                    Text(poiDataValue?.toString() ?? '',
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
                    return _FeedbackTypeItem(
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
        },
      ),
    );
  }

  // TODO: refactor
  void _onTap(BuildContext context, scheme, int? objectId) {
    if (objectId == null) {
      return;
    }
    final objectId_ = objectId.toString();
    FeedbackRoute(objectId: objectId_, schemeId: scheme.id).push(context);
  }
}

class _FeedbackTypeItem extends ConsumerWidget {
  final String title;
  final FeedbackIcon icon;
  final VoidCallback onTap;

  const _FeedbackTypeItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ContentRow(
        onTap: onTap,
        options: ContentRowOptions(
          leadingIcon: Icon(
            icon.iconData(isLTR: context.isLTR),
            color: context.colorsV2.accentDefault,
          ),
          title: title,
          titleStyle: context.textStyleV3.bodyLargeRegular,
          actionWidget: ContentRowActionOptions(
            actionIcon: AppIcons(
              iconData: context.isLTR
                  ? SystemIcons.arrowCornerRightLarge
                  : SystemIcons.arrowCornerLeftLarge,
              color: context.colorsV2.neutralDefault,
            ),
          ),
        ),
      );
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
