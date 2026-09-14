import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    show AlertsModalSheetContent, CurrentWeatherContent, DayCardShimmer, SunriseOrSunsetTime, WeatherDayCard;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/utils_exports.dart';
import '../widgets/weather_appbar.dart';

class WeatherMainPage extends StatefulWidget {
  const WeatherMainPage({super.key});

  @override
  State<WeatherMainPage> createState() => _WeatherMainPageState();
}

class _WeatherMainPageState extends State<WeatherMainPage> {
  int selectedTile = -1;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      sl<WeatherBloc>().add(RefreshWeatherForLocation());
    });

    CommonFunctions.sendEventToAnalytics(AppEvents.weather);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Size size = mediaQuery.size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return BlocProvider.value(
      value: sl<WeatherBloc>()
        ..add(GetWeatherForLocation())
        ..add(ChangeIndexEvent(index: -1)),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state.allWeatherInfoStatus == BlocStatus.failure) {
            return Center(
              child: ReloadWidget(
                onTab: () {
                  context.read<WeatherBloc>().add(GetWeatherForLocation());
                },
              ),
            );
          } else {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: PreferredSize(preferredSize: const Size.fromHeight(56), child: const WeatherAppbar()),
              body: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage(ImagePath.weatherBackground3x), fit: BoxFit.cover),
                        ),
                        height: (state.showLocationError ?? false) ? screenHeight * 0.5 : screenHeight * 0.4,
                        width: double.infinity,
                      ),
                      const CurrentWeatherContent(),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: state.allWeatherInfoStatus == BlocStatus.success
                          ? ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 24),
                              itemCount: state.allWeatherInfo?.forecast?.forecastday?.length ?? 0,
                              itemBuilder: (context, index) {
                                var forecastDay = state.allWeatherInfo?.forecast?.forecastday?[index];
                                return WeatherDayCard(
                                  forecastDay: forecastDay,
                                  isExpanded: state.selectedTile == index,
                                  onExpansionChanged: (bool expanded) {
                                    context.read<WeatherBloc>().add(ChangeIndexEvent(index: expanded ? index : -1));
                                  },
                                );
                              },
                            )
                          : CustomShimmerListWidget(height: 50, itemCount: 7),
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
