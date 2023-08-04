import 'package:balady_plus/app/features/weather/presentation/widgets/weather_unkown_location.dart';
import 'package:balady_plus/app/features/weather/presentation/widgets/wind_and_vision_card.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class CurrentWeatherContent extends StatelessWidget {
  const CurrentWeatherContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              SvgPicture.asset(
                IconPath.partlyClouded,
                width: 56,
                height: 56,
              ),
              SizedBox(height: 8),
              CustomTextWidget(
                state.allWeatherInfo?.current?.tempC.toString() ?? '',
                fontSize: 20,
              ),
              UnKownWeatherLocation(
                onTap: () {
                  context.read<WeatherBloc>().add(GetWeatherForLocation());
                },
              ),
              Divider(
                color: AppColor.divider.withOpacity(0.2),
              ),
              SizedBox(
                height: 8,
              ),
              IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SunriseOrSunsetTime.sunrise(
                          time: state.allWeatherInfo?.forecast?.forecastday?[0]
                                  .astro?.sunrise
                                  ?.replaceAll('AM', '') ??
                              ''),
                      VerticalDivider(
                        thickness: 1,
                        color: AppColor.divider.withOpacity(0.2),
                      ),
                      SunriseOrSunsetTime.sunset(
                          time: state.allWeatherInfo?.forecast!.forecastday?[0]
                                  .astro?.sunset
                                  ?.replaceAll('PM', '') ??
                              ''),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              BlocProvider.value(
                value: context.read<WeatherBloc>(),
                child: const WindAndWeatherCard(),
              ),
            ],
          ),
        );
      },
    );
  }
}
