import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    hide Text;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, WeathherConditions;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomSvgIconWidget, DrawIconBasedTypeWidget;
import '../../../../../core/dependency_injection/injection_container.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<WeatherBloc>(),
      child: GestureDetector(
        onTap: () {
          context.pushNamedRoute(RouteName.weatherMainPage);
        },
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state.allWeatherInfo?.current != null) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: Row(
                  children: [
                    CustomSvgIconWidget(
                      state.allWeatherInfo?.current?.condition?.iconPath ?? '',
                      iconSize: 28,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      children: [
                        Text(
                          "${state.allWeatherInfo?.current?.tempC.toString().substring(0, 2) ?? ''}°",
                          style: AppStyle.mainTextStyle.copyWith(
                              color: AppColor.blackModern600Light,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              height: 1),
                        ),
                        Text(
                          state.allWeatherInfo?.current?.condition?.text ?? '',
                          style: AppStyle.mainTextStyle.copyWith(
                            color: AppColor.blackModern600Light,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
