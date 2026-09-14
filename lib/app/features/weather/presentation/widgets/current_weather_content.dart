import 'package:balady_plus/app/features/weather/presentation/widgets/weather_unkown_location.dart';
import 'package:balady_plus/app/features/weather/presentation/widgets/wind_and_vision_card.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              CustomSvgIconWidget(
                state.allWeatherInfo?.current?.condition?.iconPath ?? '',
                iconSize: 56,
                iconColor: AppColor.white,
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 6),
                    child: CustomTextWidget("C", fontSize: 18, fontWeight: AppFontWeight.regular),
                  ),
                  const SizedBox(width: 1),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CustomTextWidget("°", fontSize: 20, fontWeight: AppFontWeight.regular),
                  ),
                  CustomTextWidget(
                    state.allWeatherInfo?.current?.tempC.toString().substring(0, 2) ?? '',
                    fontSize: 20,
                    fontWeight: AppFontWeight.regular,
                  ),
                  const SizedBox(width: 8),
                  CustomTextWidget(
                    state.allWeatherInfo?.current?.condition?.text ?? '',
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                  ),
                ],
              ),
              if (state.showLocationError ?? false)
                UnKownWeatherLocation(
                  onTap: () {
                    context.read<WeatherBloc>().add(GetWeatherForLocation());
                  },
                ),
              Divider(color: AppColor.divider.withValues(alpha: 0.2)),
              const SizedBox(height: 8),
              IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SunriseOrSunsetTime.sunrise(
                        time:
                            state.allWeatherInfo?.forecast?.forecastday?[0].astro?.sunrise?.replaceAll('AM', '') ?? '',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 36),
                        child: VerticalDivider(thickness: 1, color: AppColor.divider.withValues(alpha: 0.2)),
                      ),
                      SunriseOrSunsetTime.sunset(
                        time: state.allWeatherInfo?.forecast!.forecastday?[0].astro?.sunset?.replaceAll('PM', '') ?? '',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              BlocProvider.value(value: context.read<WeatherBloc>(), child: const WindAndWeatherCard()),
            ],
          ),
        );
      },
    );
  }
}
