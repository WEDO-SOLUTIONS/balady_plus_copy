import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Height of the collapsed weather sheet, written during layout by [WeatherSheetHeader].
///
/// A plain holder rather than state: the sheet reads it while computing its snap offsets, right after laying out
/// the header, so no rebuild is involved.
class WeatherSheetPeek {
  /// Used until the title row has been laid out once.
  static const fallback = 72.0;

  double _height = 0;

  /// Bottom safe area the collapsed and open heights are lifted by; set by the sheet on build.
  double bottomInset = 0;

  /// Dragger and title row.
  double get height => _height > 0 ? _height : fallback;
}

/// Sheet header of the weather page: place name and the "today" card.
///
/// It keeps the same height in every sheet state, so dragging never re-lays out or re-snaps the sheet, and it is
/// independent of the sheet position, so it is built once instead of on every drag frame.
class WeatherSheetHeader extends ConsumerWidget {
  const WeatherSheetHeader({
    required this.forecast,
    required this.peek,
    required this.draggerHeight,
    required this.onClose,
    required this.onTodayTap,
    super.key,
  });

  final AllWeatherInfoEntity forecast;
  final WeatherSheetPeek peek;

  /// Height of the dragger above this header; part of the collapsed height.
  final double draggerHeight;
  final VoidCallback onClose;
  final VoidCallback onTodayTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageCode = ref.watch(appLanguageProvider.select((language) => language.locale.languageCode));
    final colors = context.colors;

    return ColoredBox(
      // Opaque: the day list scrolls underneath the header once the sheet is expanded.
      color: colors.backgroundSurface4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ReportHeight(
            onLayout: (height) => peek._height = draggerHeight + height,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Spacing.$4x, Spacing.$1x, Spacing.$4x, Spacing.$3x),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      forecast.location?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.h3SemiBold.copyWith(color: colors.foregroundDefault),
                    ),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  AppButton.close(onTap: onClose, padding: EdgeInsets.zero),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(Spacing.$4x, 0, Spacing.$4x, Spacing.$4x),
            child: _TodayCard(current: forecast.current, languageCode: languageCode, onTap: onTodayTap),
          ),
        ],
      ),
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.current, required this.languageCode, required this.onTap});

  final Current? current;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final current = this.current;
    final temperature = current?.tempC?.round();
    final condition = current?.condition?.text ?? '';
    final date = DateFormat('EEEE, d MMMM', languageCode).format(DateTime.now());
    final bigNumberStyle = TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w600,
      fontSize: 56,
      height: 1.1,
      color: colors.foregroundDefault,
    );

    return Material(
      color: colors.backgroundSurface1,
      borderRadius: BorderRadius.circular(RadiusBorder.xl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: temperature == null ? '–' : '$temperature',
                            children: [
                              TextSpan(
                                text: '°C',
                                style: bigNumberStyle.copyWith(fontSize: 24, height: 1),
                              ),
                            ],
                          ),
                          style: bigNumberStyle,
                          textDirection: TextDirection.ltr,
                        ),
                        if (condition.isNotEmpty)
                          Text(
                            condition,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textStyles.bodySmallSemiBold.copyWith(color: colors.foregroundDefault),
                          ),
                        const SizedBox(height: Spacing.$0_5x),
                        Text(date, style: textStyles.captionMediumRegular.copyWith(color: colors.foregroundSoft)),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  SvgPicture.asset(
                    current?.defineIsDay() == false
                        ? Assets.icons.svg.weather.moon.keyName
                        : Assets.icons.svg.weather.sunNew.keyName,
                    height: 75,
                    width: 75,
                  ),
                ],
              ),
              const SizedBox(height: Spacing.$4x),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      value: current?.humidity?.toString(),
                      unit: '%',
                      assetName: Assets.icons.svg.weather.humidity.keyName,
                    ),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  Expanded(
                    child: _Metric(
                      value: current?.pressureMb?.round().toString(),
                      unit: 'hPa',
                      assetName: Assets.icons.svg.weather.pressure.keyName,
                    ),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  Expanded(
                    child: _Metric(
                      value: current?.windKph?.round().toString(),
                      unit: 'km/h',
                      assetName: Assets.icons.svg.weather.wind.keyName,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.unit, required this.assetName});

  final String? value;
  final String unit;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.textStyles.captionMediumRegular;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.accentSecondaryContainerDefault,
        borderRadius: BorderRadius.circular(RadiusBorder.ml),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$1x, vertical: Spacing.$2x),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetName,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(colors.accentSecondaryOnContainer, BlendMode.srcIn),
              matchTextDirection: true,
            ),
            const SizedBox(width: Spacing.$1x),
            Flexible(
              child: Text.rich(
                TextSpan(
                  text: value ?? '–',
                  style: style.copyWith(color: colors.accentSecondaryOnContainer),
                  children: [
                    TextSpan(
                      text: ' $unit',
                      style: style.copyWith(color: colors.staticMutedBlue),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reports its child's height during layout, before the parent (the sheet) uses it for its snap offsets.
class _ReportHeight extends SingleChildRenderObjectWidget {
  const _ReportHeight({required this.onLayout, required super.child});

  final ValueChanged<double> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderReportHeight(onLayout);

  @override
  void updateRenderObject(BuildContext context, _RenderReportHeight renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderReportHeight extends RenderProxyBox {
  _RenderReportHeight(this.onLayout);

  ValueChanged<double> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size.height);
  }
}
