import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/entities/feedback/feedback_type.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackTypesPage extends ConsumerWidget {
  final String poiTitle;
  final String address;

  const FeedbackTypesPage({
    required this.poiTitle,
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Material(
          color: context.colorsV2.backgroundSurface4,
          child: Scaffold(
            appBar: BaladyTopBar.iconAndText(
              title: context.l10n.feedbackWhatsWrong,
              leading: ActionModel(
                icon: SystemIcons.arrowCornerLeftLarge,
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Spacing.$4x),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(poiTitle, style: context.textStyle.callout),
                      const SizedBox(height: 5),
                      Text(address, style: context.textStyleV3.bodySmallRegular),
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
                        onTap: () => _onTap(context, FeedbackType.values[index]),
                      ),
                      separatorBuilder: (context, index) => const _Divider(),
                      itemCount: FeedbackType.values.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _onTap(BuildContext context, FeedbackType type) {
    switch (type) {
      case FeedbackType.companyName:
        FeedbackCompanyNameRoute(poiTitle).push(context);
        break;
      case FeedbackType.areaOfActivity:
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
