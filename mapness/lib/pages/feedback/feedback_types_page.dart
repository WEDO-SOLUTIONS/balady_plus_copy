import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_type.dart';
import 'package:mapness/features/feedback/poi_feedback.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/feedback/feedback_page_template.dart';

class FeedbackTypesPage extends ConsumerWidget {
  final String? objectId;

  const FeedbackTypesPage({
    required this.objectId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => FeedbackPageTemplate(
        title: context.l10n.feedbackWhatsWrong,
        child: Builder(
          builder: (context) {
            if (objectId == null) {
              return const SizedBox();
            }
            final id = int.tryParse(objectId!);
            if (id == null) {
              return Center(child: Loading.large());
            }
            final data = ref.watch(poiFeedbackProvider(id));
            return data.maybeWhen(
              data: (data) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: Spacing.$4x),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data?.title ?? '', style: context.textStyle.callout),
                        const SizedBox(height: 5),
                        Text(data?.makeAddress() ?? '', style: context.textStyleV3.bodySmallRegular),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.$4x),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: Material(
                      shape: smoothBorder(RadiusBorder.l),
                      color: context.colorsV2.backgroundSurface1,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _FeedbackTypeItem(
                          type: FeedbackType.values[index],
                          onTap: () => _onTap(context, FeedbackType.values[index], data!),
                        ),
                        separatorBuilder: (context, index) => const _Divider(),
                        itemCount: FeedbackType.values.length,
                      ),
                    ),
                  ),
                ],
              ),
              orElse: () => Center(child: Loading.large()),
            );
          },
        ),
      );

  void _onTap(BuildContext context, FeedbackType type, DirectoryObjectMessage data) {
    final localObjectId = data.id?.objectId;
    if (localObjectId == null) {
      return;
    }
    switch (type) {
      case FeedbackType.companyName:
        FeedbackCompanyNameRoute(data.title, localObjectId.toString()).push(context);
        break;
      case FeedbackType.areaOfActivity:
        FeedbackAreaOfActivityRoute(data.subtitle, localObjectId.toString()).push(context);
        break;
      case FeedbackType.address:
      case FeedbackType.workingHours:
      case FeedbackType.phoneNumber:
      case FeedbackType.websiteOrSocialMedia:
      case FeedbackType.companyHasBeenClosed:
      case FeedbackType.other:
        break;
    }
  }
}

class _FeedbackTypeItem extends ConsumerWidget {
  final FeedbackType type;
  final VoidCallback onTap;
  const _FeedbackTypeItem({required this.type, required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ContentRow(
        onTap: onTap,
        options: ContentRowOptions(
          leadingIcon: Icon(
            type.icon(isLTR: context.isLTR),
            color: context.colorsV2.accentDefault,
          ),
          title: type.title(context.l10n),
          titleStyle: context.textStyleV3.bodyLargeRegular,
          actionWidget: ContentRowActionOptions(
            actionIcon: AppIcons(
              iconData: context.isLTR ? SystemIcons.arrowCornerRightLarge : SystemIcons.arrowCornerLeftLarge,
              color: context.colorsV2.neutralDefault,
            ),
          ),
        ),
      );
}

class _Divider extends StatelessWidget {
  const _Divider({super.key});

  @override
  Widget build(BuildContext context) => Divider(
        color: context.colorsV2.borderSoft,
        height: 8,
        thickness: 0.5,
        indent: 52,
      );
}
