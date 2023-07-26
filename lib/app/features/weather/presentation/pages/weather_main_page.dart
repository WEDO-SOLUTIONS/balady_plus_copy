import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    show AlertsModalSheetContent, SunriseOrSunsetTime, WeatherDayCard;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/utils_exports.dart';

class WeatherMainPage extends StatelessWidget {
  const WeatherMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WeatherBloc>(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state.allWeatherInfoStatus == BlocStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
                actions: [
                  state.allWeatherInfo?.alerts?.alert?.isEmpty ?? true
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  // <-- SEE HERE
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(32.0),
                                  ),
                                ),
                                isScrollControlled: true,
                                context: context,
                                builder: (_) => BlocProvider.value(
                                      value: context.read<WeatherBloc>(),
                                      child: const AlertsModalSheetContent(),
                                    ));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                                color: Color(0x1FCDE0E0),
                                shape: BoxShape.circle),
                            child: Center(
                                child: SvgPicture.asset(IconPath.danger)),
                          ),
                        ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: CustomTextWidget(
                  state.allWeatherInfo?.location?.name ?? 'الرياض',
                  fontSize: 20,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              body: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(ImagePath.weatherBackground3x),
                          fit: BoxFit.cover),
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top),
                          SvgPicture.asset(
                            IconPath.partlyClouded,
                            width: 56,
                            height: 56,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextWidget(
                            state.allWeatherInfo?.current?.tempC.toString() ??
                                '0',
                            fontSize: 20,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Divider(
                            color: AppColor.divider.withOpacity(0.2),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          IntrinsicHeight(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SunriseOrSunsetTime.sunrise(
                                      time: state.allWeatherInfo?.forecast
                                              ?.forecastday?[0].astro?.sunrise
                                              ?.replaceAll('AM', '') ??
                                          ''),
                                  VerticalDivider(
                                    thickness: 1,
                                    color: AppColor.divider.withOpacity(0.2),
                                  ),
                                  SunriseOrSunsetTime.sunset(
                                      time: state.allWeatherInfo?.forecast!
                                              .forecastday?[0].astro?.sunset
                                              ?.replaceAll('PM', '') ??
                                          ''),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          Container(
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: AppColor.divider,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(IconPath.wind_speed),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          CustomTextWidget(
                                            '${state.allWeatherInfo?.current?.windKph.toString()} k/h',
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          CustomTextWidget(
                                            state.allWeatherInfo?.current
                                                    ?.windDir ??
                                                '',
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(IconPath.eye),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          CustomTextWidget(
                                            '${state.allWeatherInfo?.current?.visKm.toString()} km',
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.allWeatherInfo?.forecast?.forecastday
                                ?.length ??
                            0,
                        itemBuilder: (context, index) {
                          var forecastDay = state
                              .allWeatherInfo?.forecast?.forecastday?[index];
                          return WeatherDayCard(forecastDay: forecastDay);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
