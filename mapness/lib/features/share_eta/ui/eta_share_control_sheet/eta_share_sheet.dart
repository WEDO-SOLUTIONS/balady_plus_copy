import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';

typedef EtaSheetSubtitleBuilder = Widget Function(BuildContext context, String timeLeft);
typedef EtaSheetContentBuilder = List<Widget> Function(BuildContext context);

class EtaShareSheet extends StatelessWidget {
  final String title;
  final String? confirmBtnTitle;
  final VoidCallback? onConfirmTap;
  final String? timeLeft;

  final EtaSheetSubtitleBuilder? subtitleBuilder;
  final EtaSheetContentBuilder? contentBuilder;

  const EtaShareSheet({
    required this.title,
    super.key,
    this.confirmBtnTitle,
    this.onConfirmTap,
    this.timeLeft,
    this.subtitleBuilder,
    this.contentBuilder,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.colors.backgroundSurface4,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(RadiusBorder.xl),
        topRight: Radius.circular(RadiusBorder.xl),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(child: SheetDragger()),
          ContentRow(
            options: ContentRowOptions(
              padding: EdgeInsets.zero,
              title: title,
              titleStyle: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
              customActionWidget: AppButton.close(
                onTap: () => context.router.pop(),
                padding: EdgeInsets.zero,
                textColor: context.colors.neutralOnContainer,
                color: context.colors.neutralContainerDefault,
              ),
            ),
          ),
          if (timeLeft != null && subtitleBuilder != null) subtitleBuilder!.call(context, timeLeft!),
          Spacing.$4x.heightBox,
          ContentWrapper(color: context.colors.backgroundSurface1, children: contentBuilder?.call(context) ?? []),
          if (onConfirmTap != null && confirmBtnTitle != null)
            Padding(
              padding: const EdgeInsets.only(top: Spacing.$4x),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  buttonColorScheme: ButtonColorScheme.accentSecondary,
                  size: ButtonSize.large,
                  onTap: onConfirmTap,
                  primaryLabel: confirmBtnTitle,
                ),
              ),
            ),
          const SizedBox(height: Spacing.$8x),
        ],
      ),
    ),
  );
}
