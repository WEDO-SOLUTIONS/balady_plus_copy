import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_scheme_data.dart';
import 'package:mapness/entities/feedback/feedback_type.dart';
import 'package:mapness/features/feedback/feedback_scheme.dart';
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
        isSendVisible: false,
        child: Builder(
          builder: (context) {
            if (objectId == null) {
              return const SizedBox();
            }
            final id = int.tryParse(objectId!);
            if (id == null) {
              return Center(child: Loading.large());
            }
            final poiData = ref.watch(poiFeedbackProvider(id));
            final schemes = ref.watch(feedbackSchemeProvider);
            if (poiData.isLoading || schemes.isLoading) {
              return Center(child: Loading.large());
            } else if (poiData.hasError || schemes.hasError) {
              return Center(child: Text(context.l10n.failedToLoadData));
            }
            final poiDataValue = poiData.value;
            final schemeValue = schemes.value;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Spacing.$4x),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(poiDataValue?.title ?? '', style: context.textStyle.callout),
                      const SizedBox(height: 5),
                      Text(poiDataValue?.makeAddress() ?? '', style: context.textStyleV3.bodySmallRegular),
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
                        title: schemeValue.feedbacks[index].title,
                        icon: schemeValue.feedbacks[index].icon,
                        onTap: () => _onTap(
                          context,
                          schemeValue.feedbacks[index],
                          poiDataValue?.id?.objectId,
                        ),
                      ),
                      separatorBuilder: (context, index) => const _Divider(),
                      itemCount: schemeValue!.feedbacks.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

  void _onTap(BuildContext context, FeedbackSchemeData scheme, int? objectId) {
    if (objectId == null) {
      return;
    }
    final objectId_ = objectId.toString();
    FeedbackRoute(objectId: objectId_, schemeId: scheme.id).push(context);
  }
}

class _FeedbackTypeItem extends ConsumerWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;
  const _FeedbackTypeItem({
    required this.title,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ContentRow(
        onTap: onTap,
        options: ContentRowOptions(
          leadingIcon: Icon(
            icon.feedbackIcon(isLTR: context.isLTR),
            color: context.colorsV2.accentDefault,
          ),
          title: title,
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
