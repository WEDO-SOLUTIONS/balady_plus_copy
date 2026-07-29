import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:sheetify/sheetify.dart';
import 'package:shimmer/shimmer.dart';

double weatherHeaderSize = 300.0;

class WeatherCardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;
  final GlobalKey cardKey;

  const WeatherCardHeaderDelegate({required this.bottomSheetController, required this.cardKey});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) =>
      DashboardHeader(cardKey: cardKey, bottomSheetController: bottomSheetController);

  @override
  double get maxExtent => weatherHeaderSize;

  @override
  double get minExtent => weatherHeaderSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class DashboardHeader extends ConsumerWidget {
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;
  final GlobalKey cardKey;

  const DashboardHeader({required this.bottomSheetController, required this.cardKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allWeatherInfo = ref.watch(forecastWeatherProvider);
    final locale = ref.watch(appLanguageProvider).locale;

    if (allWeatherInfo == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(RadiusBorder.xl),
              topLeft: Radius.circular(RadiusBorder.xl),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Data(
        bottomSheetController: bottomSheetController,
        allWeatherInfo: allWeatherInfo,
        locale: locale,
        cardKey: cardKey,
        onTap: () {
          if (bottomSheetController.state == ThreeStateSheet.expanded) {
            bottomSheetController.setState(ThreeStateSheet.hidden);
          } else {
            bottomSheetController.setState(ThreeStateSheet.expanded);
          }
        },
      ),
    );
  }
}

class Data extends ConsumerWidget {
  final AllWeatherInfoEntity? allWeatherInfo;
  final Locale locale;
  final Function()? onTap;
  final GlobalKey cardKey;
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  const Data({
    required this.onTap,
    required this.allWeatherInfo,
    required this.cardKey,
    required this.locale,
    required this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTime = context.digits(DateFormat('d MMMM, EEEE', locale.languageCode).format(DateTime.now()));
    final windMph = context.digitsOrNull(allWeatherInfo?.current?.windMph?.toStringAsPrecision(2));
    final humidity = context.digitsOrNull(allWeatherInfo?.current?.humidity?.toStringAsPrecision(2));
    final pressureMb = context.digitsOrNull(allWeatherInfo?.current?.pressureMb?.toStringAsFixed(0));
    final tempC = context.digits(allWeatherInfo?.current?.tempC?.toStringAsPrecision(2) ?? '-');
    final isDay = allWeatherInfo?.current?.defineIsDay();
    final condition = allWeatherInfo?.current?.condition?.text ?? '';
    final placeName = allWeatherInfo?.location?.name ?? '';

    return ListenableBuilder(
      listenable: bottomSheetController,
      builder: (_, _) => Container(
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface4,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(RadiusBorder.xl),
            topLeft: Radius.circular(RadiusBorder.xl),
          ),
        ),
        child: Column(
          key: cardKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(placeName, style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault)),
                AppButton.close(
                  onTap: () async {
                    await ref.read(weatherMapControllerProvider().notifier).switchOffWeatherLayers();
                    context.router.pop();
                  },
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            Spacing.$4x.heightBox,
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, axisAlignment: -1.0, child: child),
              ),
              child: (bottomSheetController.closestState == ThreeStateSheet.hidden)
                  ? const SizedBox(height: Spacing.$8x, key: ValueKey('hiddenHeader'))
                  : GestureDetector(
                      key: const ValueKey('weatherToday'),
                      onTap: onTap,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: context.colors.backgroundSurface1,
                              borderRadius: BorderRadius.circular(RadiusBorder.xl),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.$4x,
                                    vertical: Spacing.$4x,
                                  ).copyWith(bottom: Spacing.$4x),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ///weather info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ///temperature
                                            Row(
                                              mainAxisAlignment: Directionality.of(context) == TextDirection.rtl
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              textDirection: TextDirection.ltr,
                                              children: [
                                                Text(
                                                  tempC,
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 64,
                                                    height: 1.3,
                                                    letterSpacing: 0,
                                                    color: context.colors.foregroundDefault,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 11.5),
                                                  child: Text(
                                                    '℃',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 27,
                                                      height: 1.2,
                                                      letterSpacing: 0,
                                                      color: context.colors.foregroundDefault,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            ///date
                                            Text(
                                              dateTime,
                                              textAlign: TextAlign.end,
                                              style: context.textStyles.captionMediumRegular.copyWith(
                                                color: context.colors.foregroundSoft,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///icon
                                      SizedBox(
                                        height: 100,
                                        width: 110,
                                        child: Stack(
                                          children: [
                                            SvgPicture.asset(
                                              isDay == true
                                                  ? Assets.icons.svg.weather.sunNew.keyName
                                                  : Assets.icons.svg.weather.moon.keyName,
                                              height: 75,
                                              width: 75,
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional.topEnd,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: Spacing.$3x,
                                                  vertical: Spacing.$1x,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: context.colors.accentSecondaryDefault,
                                                  borderRadius: BorderRadius.circular(RadiusBorder.full),
                                                ),
                                                child: AutoSizeText(
                                                  condition,
                                                  maxLines: 1,
                                                  style: context.textStyles.bodySmallSemiBold.copyWith(
                                                    color: context.colors.staticWhite,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  switchInCurve: Curves.easeOut,
                                  switchOutCurve: Curves.easeIn,
                                  transitionBuilder: (child, animation) => FadeTransition(
                                    opacity: animation,
                                    child: SizeTransition(sizeFactor: animation, axisAlignment: -1.0, child: child),
                                  ),
                                  child: bottomSheetController.closestState == ThreeStateSheet.open
                                      ? const SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
                                          child: Row(
                                            children: [
                                              buildButton(
                                                withoutLeftPadding: true,
                                                desc: '$humidity',
                                                counter: '%',
                                                assetName: Assets.icons.svg.weather.humidity.keyName,
                                              ),
                                              buildButton(
                                                desc: '$pressureMb',
                                                counter: 'Mb',
                                                assetName: Assets.icons.svg.weather.pressure.keyName,
                                              ),
                                              buildButton(
                                                withoutRightPadding: true,
                                                desc: '$windMph',
                                                counter: 'Mph',
                                                assetName: Assets.icons.svg.weather.wind.keyName,
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton({
    required String assetName,
    required String desc,
    required String counter,
    bool withoutLeftPadding = false,
    bool withoutRightPadding = false,
    Function()? onTap,
    Color? colorIcon,
    Color? colorButton,
    int flex = 1,
  }) => Builder(
    builder: (context) => Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.$1x,
        ).copyWith(left: withoutLeftPadding ? 0 : null, right: withoutRightPadding ? 0 : null),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
          decoration: BoxDecoration(
            color: context.colors.accentSecondaryContainerDefault,
            borderRadius: BorderRadius.circular(RadiusBorder.ml),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    desc,
                    style: context.textStyles.captionMediumRegular.copyWith(
                      color: context.colors.accentSecondaryOnContainer,
                    ),
                  ),
                  const SizedBox(width: Spacing.$0_5x),
                  Text(
                    counter,
                    style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.staticMutedBlue),
                  ),
                ],
              ),
              const SizedBox(width: 2),
              SvgPicture.asset(
                key: ValueKey(assetName),
                assetName,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(colorIcon ?? context.colors.accentSecondaryOnContainer, BlendMode.srcIn),
                matchTextDirection: true,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
