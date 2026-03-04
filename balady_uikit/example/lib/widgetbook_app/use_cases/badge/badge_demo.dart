import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '22. Badge',
  type: Widget,
)
Widget badgeDemo(BuildContext context) {
  final iconPosition = context.knobs.list(
    label: 'ICON POSITION',
    options: [
      BadgeIconPosition.none,
      BadgeIconPosition.start,
      BadgeIconPosition.end,
    ],
    initialOption: BadgeIconPosition.none,
  );
  final text = Directionality.of(context) == TextDirection.ltr ? 'Status text' : 'نص الحالة';
  final statusText = context.knobs.stringOrNull(label: 'Status text', initialValue: text) ?? text;

  Widget badgePrimary(BuildContext context, BadgeType badgeType) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            container(badgeType.name, context),
            const SizedBox(
              height: 50,
            ),
            BaladyBadge.primary(
              statusText,
              badgeType: badgeType,
              iconPosition: iconPosition,
              icon: iconPosition == BadgeIconPosition.none ? null : GeneralIcons.placeholder,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget badgeSecondary(BuildContext context, BadgeType badgeType) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            container(badgeType.name, context),
            const SizedBox(
              height: 50,
            ),
            BaladyBadge.secondary(
              statusText,
              badgeType: badgeType,
              iconPosition: iconPosition,
              icon: iconPosition == BadgeIconPosition.none ? null : GeneralIcons.placeholder,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget badgeTertiary(BuildContext context, BadgeType badgeType) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            container(badgeType.name, context),
            const SizedBox(
              height: 50,
            ),
            BaladyBadge.tertiary(
              statusText,
              badgeType: badgeType,
              iconPosition: iconPosition,
              icon: iconPosition == BadgeIconPosition.none ? null : GeneralIcons.placeholder,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  return Scaffold(
    backgroundColor: Colors.white,
    body: Directionality(
      textDirection: Directionality.of(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Badge",
            style: context.textStyles.bodyLargeMedium.copyWith(
              fontSize: 32,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: container("Primary", context)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              badgePrimary(context, BadgeType.neutral),
              badgePrimary(context, BadgeType.success),
              badgePrimary(context, BadgeType.warning),
              badgePrimary(context, BadgeType.error),
              badgePrimary(context, BadgeType.info1),
              badgePrimary(context, BadgeType.info2),
              badgePrimary(context, BadgeType.info3),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: container("Secondary", context)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              badgeSecondary(context, BadgeType.neutral),
              badgeSecondary(context, BadgeType.success),
              badgeSecondary(context, BadgeType.warning),
              badgeSecondary(context, BadgeType.error),
              badgeSecondary(context, BadgeType.info1),
              badgeSecondary(context, BadgeType.info2),
              badgeSecondary(context, BadgeType.info3),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: container("Tertiary", context)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              badgeTertiary(context, BadgeType.neutral),
              badgeTertiary(context, BadgeType.success),
              badgeTertiary(context, BadgeType.warning),
              badgeTertiary(context, BadgeType.error),
              badgeTertiary(context, BadgeType.info1),
              badgeTertiary(context, BadgeType.info2),
              badgeTertiary(context, BadgeType.info3),
            ],
          ),
        ],
      ),
    ),
  );
}

Container container(String text, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    alignment: Alignment.centerLeft,
    height: AppSizes.m,
    // width: double.infinity,
    decoration:
        BoxDecoration(color: context.colors.backgroundSurface4, borderRadius: BorderRadius.circular(RadiusBorder.m)),
    child: Text(
      text,
      style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundSoft),
    ),
  );
}
