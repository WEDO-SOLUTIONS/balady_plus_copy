import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:mapness/_features/weather/data/models/weather_model.dart';
import 'package:mapness/_features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/_features/weather/wiidget_ref_extension.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:shimmer/shimmer.dart';

const colorPrimary = Color(0xff1E2A36);
final borderRadius = BorderRadius.circular(16);
const weatherHeaderSize = 300.0;

class WeatherCardHeaderDelegate extends SliverPersistentHeaderDelegate {
  WeatherCardHeaderDelegate({
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return DashboardHeader(
      draggableScrollableController: draggableScrollableController,
    );
  }

  @override
  double get maxExtent => weatherHeaderSize;

  @override
  double get minExtent => weatherHeaderSize;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({
    super.key,
    required this.draggableScrollableController,
  });

  final DraggableScrollableController draggableScrollableController;

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
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        child: Data(
          allWeatherInfo: allWeatherInfo,
          locale: locale,
          onTap: () {
            var size = draggableScrollableController.size;
            draggableScrollableController.animateTo(
              size < 1 ? 1 : .1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
        ),
      ),
    );
  }
}

class Data extends ConsumerWidget {
  final AllWeatherInfoModel? allWeatherInfo;
  final Locale locale;
  final Function()? onTap;

  const Data({
    required this.onTap,
    super.key,
    required this.allWeatherInfo,
    required this.locale,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // "4:35pm, 20 November, Mon",
    final dateTime = (DateFormat('h:mm a, d MMMM, E', locale.languageCode)
        .format(DateTime.now()));
    final windMph = allWeatherInfo?.current?.windMph?.toStringAsPrecision(2);
    final humidity = allWeatherInfo?.current?.humidity?.toStringAsPrecision(2);
    final pressureMb = allWeatherInfo?.current?.pressureMb?.toStringAsFixed(0);
    final tempC = allWeatherInfo?.current?.tempC?.toStringAsPrecision(2) ?? '-';
    final isDay = allWeatherInfo?.current?.defineIsDay();
    final condition = allWeatherInfo?.current?.condition?.text ?? '';
    final placeName = allWeatherInfo?.location?.name ?? '';

    final textStyle = context.textStyle.accentXS.copyWith(
      height: 1.4,
      color: colorPrimary,
    );

    return Container(
      // padding: EdgeInsets.only(left: 16,right: 16,bottom: 16,),
      height: weatherHeaderSize,
      decoration: const BoxDecoration(
        // color: Color(0xffF4F4F5),
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          topLeft: Radius.circular(16.0),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 8,
            ),
            _scrollHandle(),
            const SizedBox(
              height: 6,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///close
                  _closeButton(onTap: ()async {
                   await ref.switchOffWeatherLayers();
                    context.pop();
                  }),

                  ///settings
                  ///cityname
                  Text(
                    placeName,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .accentL
                        .copyWith(fontSize: 19, color: Colors.black),
                  ),
                ]),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          top: 16,
                          right: 16,
                        ),
                        child: Row(
                          textDirection: TextDirection.rtl,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///weather info
                            Column(
                              textDirection: TextDirection.rtl,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ///date
                                Text(
                                  dateTime,
                                  style: Theme.of(context)
                                      .extension<ThemeTextStyles>()!
                                      .textXS
                                      .copyWith(
                                        color: colorPrimary.withOpacity(0.5),
                                      ),
                                ),
                                SizedBox(height: 16),

                                ///temperature
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 70,
                                        minHeight: 65,
                                      ),
                                      child: Text(
                                        tempC,
                                        style: Theme.of(context)
                                            .extension<ThemeTextStyles>()!
                                            .textL
                                            .copyWith(
                                              height: 1,
                                              fontSize: 64,
                                              fontWeight: FontWeight.w400,
                                              color: colorPrimary,
                                            ),
                                      ),
                                    ),
                                    Text(
                                      '℃',
                                      style: context.textStyle.textL.copyWith(
                                        fontSize: 27,
                                        height: 1,
                                        fontWeight: FontWeight.w600,
                                        color: colorPrimary,
                                      ),
                                    ),
                                  ],
                                ),

                                ///condition
                                Text(condition,
                                    style: context.textStyle.accentM.copyWith(
                                      // height: 1,
                                      fontWeight: FontWeight.w700,
                                      color: colorPrimary,
                                    )),
                              ],
                            ),

                            ///icon
                            SizedBox(
                              height: 100,
                              width: 110,
                              child: Center(
                                child: SvgPicture.asset(
                                  isDay == true
                                      ? 'assets/icons/svg/weather/Sun_new.svg'
                                      : 'assets/icons/svg/weather/Moon.svg',
                                  package: PackageConfig.packageName,
                                  height: 75,
                                  width: 75,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          buildButton(
                              desc: Text(
                                '${windMph}Mph',
                                style: textStyle,
                                maxLines: 1,
                              ),
                              assetName: 'assets/icons/svg/weather/wind.svg'),
                          buildButton(
                              desc: Text(
                                '${pressureMb}Mb',
                                style: textStyle,
                                maxLines: 1,
                              ),
                              assetName:
                                  'assets/icons/svg/weather/pressure.svg'),
                          buildButton(
                              desc: Text(
                                '$humidity%',
                                style: textStyle,
                                maxLines: 1,
                              ),
                              assetName:
                                  'assets/icons/svg/weather/humidity.svg'),
                        ]),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _closeButton({Function()? onTap}) {
    return Material(
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            // color: Colors.white,
            color: Color(0xffF4F4F5),
          ),
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            "assets/icons/svg/ic_search_close.svg",
            semanticsLabel: 'MinApps Screen',
            package: "mapness",
            color: colorPrimary.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _scrollHandle() {
    return Center(
        child: Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: colorPrimary.withOpacity(0.1),
      ),
      height: 4,
      width: 40,
    ));
  }

  Widget buildButton({
    required String assetName,
    Widget? desc,
    Function()? onTap,
    Color? colorIcon,
    Color? colorButton,
    int flex = 1,
  }) {
    BorderRadius borderRadius = BorderRadius.circular(8);

    return Flexible(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minHeight: 40,
            maxHeight: 40,
            minWidth: 52,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
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
                color: colorPrimary.withOpacity(0.7),
                package: PackageConfig.packageName,
                matchTextDirection: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
