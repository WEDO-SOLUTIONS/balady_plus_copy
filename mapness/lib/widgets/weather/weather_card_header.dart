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
import 'package:shimmer/shimmer.dart';

double weatherHeaderSize = 300.0;

class WeatherCardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final StatefulBottomSheetController<ThreeStateBottomSheet> bottomSheetController;
  final GlobalKey cardKey;

  const WeatherCardHeaderDelegate({
    required this.bottomSheetController,
    required this.cardKey,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      DashboardHeader(
        cardKey: cardKey,
        bottomSheetController: bottomSheetController,
      );

  @override
  double get maxExtent => weatherHeaderSize;

  @override
  double get minExtent => weatherHeaderSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class DashboardHeader extends ConsumerWidget {
  final StatefulBottomSheetController bottomSheetController;
  final GlobalKey cardKey;

  const DashboardHeader({
    required this.bottomSheetController,
    required this.cardKey,
    super.key,
  });

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
        allWeatherInfo: allWeatherInfo,
        locale: locale,
        cardKey: cardKey,
        onTap: () {
          if (bottomSheetController.state == ThreeStateBottomSheet.expanded) {
            bottomSheetController.setState(ThreeStateBottomSheet.hidden);
          } else {
            bottomSheetController.setState(ThreeStateBottomSheet.expanded);
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

  const Data({
    required this.onTap,
    required this.allWeatherInfo,
    required this.cardKey,
    required this.locale,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTime = DateFormat('h:mm a, d MMMM, E', locale.languageCode).format(DateTime.now());
    final windMph = allWeatherInfo?.current?.windMph?.toStringAsPrecision(2);
    final humidity = allWeatherInfo?.current?.humidity?.toStringAsPrecision(2);
    final pressureMb = allWeatherInfo?.current?.pressureMb?.toStringAsFixed(0);
    final tempC = allWeatherInfo?.current?.tempC?.toStringAsPrecision(2) ?? '-';
    final isDay = allWeatherInfo?.current?.defineIsDay();
    final condition = allWeatherInfo?.current?.condition?.text ?? '';
    final placeName = allWeatherInfo?.location?.name ?? '';

    final textStyle = context.textStyle.caption.copyWith(
      height: 1.4,
      color: context.color.textAndIconsBasePrimary,
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(RadiusBorder.xl),
          topLeft: Radius.circular(RadiusBorder.xl),
        ),
      ),
      child: Column(
        key: cardKey,
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacing.$3x.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///cityname
              Text(
                placeName,
                style: context.textStyle.heading2.copyWith(fontSize: 19, color: Colors.black),
              ),

              ///close
              AppButton.close(
                buttonType: ButtonType.secondary,
                onTap: () async {
                  await ref.read(weatherMapControllerProvider().notifier).switchOffWeatherLayers();
                  context.router.popForced();
                },
              ),
            ],
          ),
          Spacing.$4x.heightBox,
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: context.color.surfaceBaseSecondary,
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
                              ///date
                              Text(
                                dateTime,
                                textAlign: TextAlign.end,
                                style: context.textStyle.caption.copyWith(
                                  color: context.color.textAndIconsBasePrimary.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(height: 16),

                              ///temperature
                              Row(
                                mainAxisAlignment: Directionality.of(context) == TextDirection.rtl
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.ltr,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 70,
                                      minHeight: 65,
                                    ),
                                    child: Text(
                                      tempC,
                                      style: context.textStyle.heading2.copyWith(
                                        height: 1,
                                        fontSize: 64,
                                        fontWeight: FontWeight.w400,
                                        color: context.color.textAndIconsBasePrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '℃',
                                    style: context.textStyle.heading2.copyWith(
                                      fontSize: 27,
                                      height: 1,
                                      fontWeight: FontWeight.w600,
                                      color: context.color.textAndIconsBasePrimary,
                                    ),
                                  ),
                                ],
                              ),

                              ///condition
                              AutoSizeText(
                                condition,
                                maxLines: 1,
                                style: context.textStyle.callout.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: context.color.textAndIconsBasePrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        ///icon
                        SizedBox(
                          height: 100,
                          width: 110,
                          child: Center(
                            child: SvgPicture.asset(
                              isDay == true
                                  ? Assets.icons.svg.weather.sunNew.keyName
                                  : Assets.icons.svg.weather.moon.keyName,
                              height: 75,
                              width: 75,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Spacing.$2x),
                    child: Row(
                      children: [
                        buildButton(
                          desc: Text(
                            '${windMph}Mph',
                            style: textStyle,
                            maxLines: 1,
                          ),
                          assetName: Assets.icons.svg.weather.wind.keyName,
                        ),
                        buildButton(
                          desc: Text(
                            '${pressureMb}Mb',
                            style: textStyle,
                            maxLines: 1,
                          ),
                          assetName: Assets.icons.svg.weather.pressure.keyName,
                        ),
                        buildButton(
                          desc: Text(
                            '$humidity%',
                            style: textStyle,
                            maxLines: 1,
                          ),
                          assetName: Assets.icons.svg.weather.humidity.keyName,
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
    );
  }

  Widget buildButton({
    required String assetName,
    Widget? desc,
    Function()? onTap,
    Color? colorIcon,
    Color? colorButton,
    int flex = 1,
  }) =>
      Builder(
        builder: (context) => Flexible(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$1x),
            child: Container(
              alignment: Alignment.center,
              constraints: const BoxConstraints(
                minHeight: 40,
                maxHeight: 40,
                minWidth: 52,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(RadiusBorder.m),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (desc != null) ...[
                    desc,
                    const SizedBox(
                      width: 2,
                    ),
                  ],
                  SvgPicture.asset(
                    key: ValueKey(assetName),
                    assetName,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                      colorIcon ?? context.color.textAndIconsBasePrimary.withOpacity(0.7),
                      BlendMode.srcIn,
                    ),
                    matchTextDirection: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
