import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/landing/dashboard/city_event_config.dart';
import 'package:sheetify/multi_state_sheet/animated_state_components/sheet_base_components.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';
import 'package:sheetify/multi_state_sheet/state_snapping/sheet_state_mapper.dart';

/// Unified event background widget that displays event-specific banners
class CityEventBackground extends StatelessWidget {
  final VoidCallback? onTap;
  final MultiStateSheetController<ThreeStateSheet> controller;
  final CityEventConfig config;

  const CityEventBackground({required this.controller, required this.config, super.key, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () => onTap?.call(),
    child: MultiStateSheetBuilder(
      defaultState: ThreeStateSheet.hidden,
      builder: (context, state, interpolation, child) => Padding(
        padding: EdgeInsets.only(top: state == ThreeStateSheet.hidden ? Spacing.$1x * (1 - interpolation) : 0),
        child: SizedBox(
          height: config.bannerBoxHeight * (state == ThreeStateSheet.hidden ? clampDouble(interpolation * 3, 0, 1) : 1.0),
          width: double.infinity,
          child: Transform.translate(
            offset: Offset(0, config.verticalOffset),
            // The box above sets a tight height, which would otherwise squash
            // the banner to it. Releasing the constraint lets a config draw
            // taller than its box and tuck the surplus under the sheet.
            child: OverflowBox(
              alignment: Alignment.topCenter,
              maxHeight: double.infinity,
              child: SizedBox(
                height: config.bannerDrawHeight ?? config.bannerBoxHeight,
                child: _EventBanner(config: config),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _EventBanner extends StatelessWidget {
  final CityEventConfig config;

  const _EventBanner({required this.config});

  @override
  Widget build(BuildContext context) {
    final formattedDate = config.getFormattedDate(context);

    const shape = BorderRadius.vertical(top: Radius.circular(RadiusBorder.xl));
    final overlay = config.backgroundOverlay(context);

    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: shape, color: config.getBackgroundColor(context)),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          // Sits over the flat colour and under the text. Clipped to the
          // banner's own rounded top, which the DecoratedBox only applies to
          // its decoration — a child would otherwise paint over the corners.
          if (overlay != null) Positioned.fill(child: ClipRRect(borderRadius: shape, child: overlay)),
          Align(
        alignment: config.textAlignment,
        child: Padding(
          padding: const EdgeInsets.only(right: Spacing.$4x),
          child: formattedDate != null
              ? Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: config.getText(context.l10n)),
                      const TextSpan(text: ' · '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            formattedDate,
                            style: context.textStyles.captionLargeSemiBold.copyWith(
                              color: context.colors.successOnSuccess,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  style: context.textStyles.captionLargeSemiBold.copyWith(color: context.colors.successOnSuccess),
                  textAlign: TextAlign.end,
                )
              : Builder(
                  builder: (context) {
                    final style = context.textStyles.captionLargeSemiBold.copyWith(
                      color: context.colors.successOnSuccess,
                    );
                    final wordmark = config.trailingWordmark;
                    if (wordmark == null) {
                      return Text(config.getText(context.l10n), style: style);
                    }
                    return Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          config.getText(context.l10n),
                          textDirection: TextDirection.ltr,
                          style: style,
                        ),
                        Text(
                          context.locale.languageCode == 'en' ? ', ' : ' ،',
                          style: style,
                        ),
                        Text(
                          wordmark,
                          textDirection: TextDirection.rtl,
                          style: style,
                        ),
                      ],
                    );
                  },
                ),
            ),
          ),
        ],
      ),
    );
  }
}
