import 'package:balady_plus/app/features/weather/weather_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class AlertsModalSheetContent extends StatelessWidget {
  const AlertsModalSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 30, right: 16, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 53,
                        height: 5.46,
                        decoration: ShapeDecoration(
                          color: Color(0xFFE5E5E5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ],
                  ),
                  CustomVerticalSpace(height: 24),
                  Row(
                    children: [
                      SvgPicture.asset(
                        IconPath.danger,
                        colorFilter: ColorFilter.mode(AppColor.primary900Light, BlendMode.srcIn),
                      ),
                      CustomHorizontalSpace(width: 8),
                      CustomTextWidget(
                        'warning'.tr(),
                        fontColor: AppColor.primary900Light,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.allWeatherInfo?.alerts?.alert?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextWidget(
                            state.allWeatherInfo?.alerts?.alert?[index].desc ?? '',
                            fontColor: AppColor.blackModern500Light,
                            fontWeight: AppFontWeight.bold,
                            fontSize: 12,
                            maxLines: 10,
                            textAlign: TextAlign.start,
                            height: 2,
                          ),
                          const SizedBox(height: 12),
                          if (state.allWeatherInfo?.alerts?.alert?[index].areas?.isNotEmpty ?? false)
                            Row(
                              children: [
                                const CustomTextWidget(
                                  "المناطق",
                                  fontColor: AppColor.blackModern700Light,
                                  fontSize: 12,
                                ),
                                const SizedBox(width: 8),
                                CustomTextWidget(
                                  state.allWeatherInfo?.alerts?.alert?[index].areas ?? '',
                                  fontColor: AppColor.primary800Light,
                                  fontSize: 12,
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget("period".tr(), fontColor: AppColor.blackModern700Light, fontSize: 12),
                              const SizedBox(width: 8),
                              Flexible(
                                child: CustomTextWidget(
                                  WeatherDateFormatter.getAlertDay(
                                    state.allWeatherInfo?.alerts?.alert?[index].effective.toString() ?? '',
                                  ),
                                  fontColor: AppColor.primary800Light,
                                  fontSize: 12,
                                  maxLines: 4,
                                ),
                              ),
                              const CustomTextWidget(' - ', fontColor: AppColor.primary800Light, fontSize: 12),
                              CustomTextWidget(
                                WeatherDateFormatter.getAlertDay(
                                  state.allWeatherInfo?.alerts?.alert?[index].expires.toString() ?? '',
                                ),
                                fontColor: AppColor.primary800Light,
                                fontSize: 12,
                              ),
                            ],
                          ),
                          CustomVerticalSpace(height: 24),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
