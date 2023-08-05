import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    show
        AlertsModalSheetContent,
        CurrentWeatherContent,
        DayCardShimmer,
        SunriseOrSunsetTime,
        WeatherDayCard;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/dependency_injection/injection_container.dart';
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
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final Size _size = _mediaQuery.size;
    final screenWidth = _size.width;
    final screenHeight = _size.height;

    return BlocProvider.value(
      value: sl<WeatherBloc>(),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          // if (state.allWeatherInfoStatus == BlocStatus.loading) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
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
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: BlocProvider.value(
                  value: context.read<WeatherBloc>(),
                  child: const WeatherAppbar(),
                ),
              ),
              body: Stack(children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ImagePath.weatherBackground3x),
                        fit: BoxFit.cover),
                  ),
                  height: MediaQuery.sizeOf(context).height * 0.44,
                  width: double.infinity,
                ),
                BlocProvider.value(
                    value: context.read<WeatherBloc>(),
                    child: const CurrentWeatherContent()),
                Positioned(
                  //make it in the middle of the screen
                  top: screenHeight * 0.4,

                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    width: screenWidth,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: state.allWeatherInfoStatus == BlocStatus.success
                          ? ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.allWeatherInfo?.forecast
                                      ?.forecastday?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                var forecastDay = state.allWeatherInfo?.forecast
                                    ?.forecastday?[index];
                                return WeatherDayCard(
                                  forecastDay: forecastDay,
                                  isExpanded: selectedTile == index,
                                  onExpansionChanged: (bool expanded) {
                                    setState(() {
                                      selectedTile = expanded ? index : -1;
                                    });
                                  },
                                );
                              },
                            )
                          : CustomShimmerListWidget(
                              height: 50,
                              itemCount: 7,
                            ),
                    ),
                  ),
                ),
              ]),
            );
          }
        },
      ),
    );
  }
}
