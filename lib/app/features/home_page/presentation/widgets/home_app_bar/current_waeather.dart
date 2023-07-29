import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/features/weather/weather_exports.dart'
    hide Text;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, WeathherConditions;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show DrawIconBasedTypeWidget;
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
            return state.allWeatherInfoStatus == BlocStatus.success
                ? Container(
                    padding: const EdgeInsetsDirectional.only(
                        start: 16, end: 8, top: 8, bottom: 8),
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(37),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackModern900Light.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "${state.allWeatherInfo?.current?.tempC.toString() ?? ''}",
                          style: AppStyle.mainTextStyle.copyWith(
                            color: AppColor.blackModern900Light,
                          ),
                        ),
                        Image.network(
                          'https:${state.allWeatherInfo?.current?.condition?.icon}',
                          height: 40,
                          width: 40,
                        )
                      ],
                    ),
                  )
                : Container();
          },
        ),
      ),
    );
  }
}
