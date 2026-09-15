import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../_shared_feature_/shared_feature_exports.dart';
import '../../weather_exports.dart';

class WindAndWeatherCard extends StatelessWidget {
  const WindAndWeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 45,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(9), color: AppColor.divider),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          IconPath.windSpeed,
                          width: 21,
                          height: 21,
                          colorFilter: ColorFilter.mode(AppColor.primary200Light, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        CustomTextWidget(
                          '${state.allWeatherInfo?.current?.windKph.toString() ?? ''} k/h',
                          fontWeight: AppFontWeight.bold,
                          fontSize: 14,
                          fontColor: AppColor.primary200Light,
                        ),
                        /*const SizedBox(
                          width: 10,
                        ),
                        CustomTextWidget(
                          state.allWeatherInfo?.current?.windDir ?? '',
                        ),*/
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          IconPath.humedity,
                          width: 15,
                          height: 15,
                          colorFilter: ColorFilter.mode(AppColor.primary200Light, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: CustomTextWidget(
                            state.allWeatherInfo?.current?.humidity.toString() ?? "",
                            fontWeight: AppFontWeight.bold,
                            fontSize: 14,
                            fontColor: AppColor.primary200Light,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          IconPath.eye,
                          width: 21,
                          height: 21,
                          colorFilter: ColorFilter.mode(AppColor.primary200Light, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        CustomTextWidget(
                          '${state.allWeatherInfo?.current?.visKm.toString() ?? ''} km',
                          fontWeight: AppFontWeight.bold,
                          fontSize: 14,
                          fontColor: AppColor.primary200Light,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
