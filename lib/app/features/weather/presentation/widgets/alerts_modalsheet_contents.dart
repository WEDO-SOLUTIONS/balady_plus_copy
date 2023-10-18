import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../weather_date.dart';

class AlertsModalSheetContent extends StatelessWidget {
  const AlertsModalSheetContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return Container(
            // height: MediaQuery.of(context).size.height * 0.33,
            child: Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 47, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          IconPath.danger,
                          color: AppColor.primary900Light,
                        ),
                        CustomTextWidget(
                          'warning'.tr(),
                          fontColor: AppColor.primary900Light,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextWidget(
                      state.allWeatherInfo?.alerts?.alert?[0].desc ?? '',
                      fontColor: AppColor.blackModern500Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 12,
                      maxLines: 10,
                      textAlign: TextAlign.start,
                      height: 2,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const CustomTextWidget(
                          "المناطق",
                          fontColor: AppColor.blackModern700Light,
                          fontSize: 12,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomTextWidget(
                          state.allWeatherInfo?.alerts?.alert?[0].areas ?? '',
                          fontColor: AppColor.primary800Light,
                          fontSize: 12,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const CustomTextWidget(
                          "الفترة",
                          fontColor: AppColor.blackModern700Light,
                          fontSize: 12,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        CustomTextWidget(
                          WeatherDateFormatter.getDay(state
                                  .allWeatherInfo?.alerts?.alert?[0].effective
                                  .toString() ??
                              ''),
                          fontColor: AppColor.primary800Light,
                          fontSize: 12,
                        ),
                        const CustomTextWidget(
                          ' - ',
                          fontColor: AppColor.primary800Light,
                          fontSize: 12,
                        ),
                        CustomTextWidget(
                          WeatherDateFormatter.getDay(state
                                  .allWeatherInfo?.alerts?.alert?[0].expires
                                  .toString() ??
                              ''),
                          fontColor: AppColor.primary800Light,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    ]);
  }
}
