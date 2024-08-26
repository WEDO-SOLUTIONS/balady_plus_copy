import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/pages/navigator_settings/components/language_row_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:urbi_utils/urbi_utils.dart';

class LanguagePickSheet extends StatelessWidget {
  const LanguagePickSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorsV2 = context.colorsV2;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.3,
      builder: (context, controller) => DecoratedBox(
        decoration: BoxDecoration(
          color: colorsV2.backgroundSurface4,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(RadiusBorder.xl),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Column(
            children: [
              Spacing.$2x.heightBox,
              DrawLineWidget(
                lineHeight: Spacing.$1x,
                lineWidth: Spacing.$10x,
                lineColor: colorsV2.neutralMuted,
              ),
              Spacing.$3x.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.voiceLanguageTitle,
                    style: context.textStyle.heading2.copyWith(
                      color: colorsV2.foregroundDefault,
                    ),
                  ),
                  AppButton.close(
                    padding: EdgeInsets.zero,
                    onTap: () => context.pop(),
                    color: colorsV2.neutralDefault.withOpacity(0.12),
                    iconColor: colorsV2.foregroundSoft,
                    innerPadding: const EdgeInsets.all(Spacing.$2x),
                  ),
                ],
              ),
              Spacing.$3x.heightBox,
              ContentWrapper(
                color: context.color.surfaceBaseTertiary,
                children: Language.values
                    .map<Widget>(
                      (e) => LanguageRowWidget(
                        currentLanguage: e,
                      ),
                    )
                    .insertBetween(
                      Padding(
                        padding: const EdgeInsets.only(left: Spacing.$4x),
                        child: Divider(color: colorsV2.borderSoft),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
