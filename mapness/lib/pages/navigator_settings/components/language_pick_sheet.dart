import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_line_widget.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/navigator_settings/components/language_row_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:urbi_utils/urbi_utils.dart';

@RoutePage()
class LanguagePickSheetPage extends StatelessWidget {
  const LanguagePickSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.35,
      builder: (context, controller) => Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundSurface4,
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
                  lineColor: colors.neutralMuted,
                ),
                Spacing.$3x.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.voiceLanguageTitle,
                      style: context.textStyle.heading2.copyWith(
                        color: colors.foregroundDefault,
                      ),
                    ),
                    AppButton.close(
                      padding: EdgeInsets.zero,
                      onTap: () => context.router.popForced(),
                      color: colors.neutralDefault.withOpacity(0.12),
                      iconColor: colors.foregroundSoft,
                      innerPadding: const EdgeInsets.all(Spacing.$2x),
                    ),
                  ],
                ),
                Spacing.$3x.heightBox,
                ContentWrapper(
                  color: context.colors.backgroundSurface4,
                  children: Language.values
                      .map<Widget>(
                        (e) => LanguageRowWidget(
                          currentLanguage: e,
                        ),
                      )
                      .insertBetween(
                        Divider(
                          color: colors.borderSoft,
                          indent: Spacing.$4x,
                          endIndent: 0,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
