import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationResultsSelectionListWidget extends StatelessWidget {
  const ViolationResultsSelectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
      builder: (context, state) {
        List<String> options = [
          'violation-result_option1'.tr(),
          'violation-result_option2'.tr(),
        ];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColor.white,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomTextWidget(
              'violation_option_title'.tr(),
              textStyle: AppStyle.violationResultsSectionStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            context
                                .read<ViolationBloc>()
                                .add(CategorySelectedEvent(index));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: state.selectedIndex == index
                                  ? AppColor.blueSkyLight800
                                  : AppColor.grayLight,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomTextWidget(
                                  options[index],
                                  textStyle: state.selectedIndex == index
                                      ? AppStyle
                                          .violationResultSelectedOptionStyle
                                      : AppStyle
                                          .violationResultUnSelectedOptionStyle,
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                CustomSvgIconWidget(
                                  state.selectedIndex == index
                                      ? IconPath.whiteArrow
                                      : IconPath.blackArrow,
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  );
                },
              ),
            )
          ]),
        );
      },
    );
  }
}
