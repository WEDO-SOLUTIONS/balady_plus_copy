import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class ViolationApprovedHortizantalList extends StatelessWidget {
  const ViolationApprovedHortizantalList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
      builder: (context, state) {
        List<String> numbers = ['1', '2', '3', '4'];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.primary900Light,
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CustomTextWidget(
              state.selectedRegulationClauseItem?.regulationClauseText ?? "",
              maxLines: 20,
              height: 1.4,
              textStyle: AppStyle.approvedViolationSectiontitleStyle,
            ),
            CustomTextWidget(
              'approved_repeated'.tr(),
              textStyle: AppStyle.approvedViolationSectionSubtitleStyle,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              child: ListView.builder(
                itemCount: numbers.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context
                              .read<ViolationBloc>()
                              .add(CategorySelectedEvent(index));
                        },
                        child: Container(
                          width: 72,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                width: 1,
                                color: state.selectedIndex == index
                                    ? AppColor.secondary900Light
                                    : const Color(0xffA1BFC8)),
                            color: state.selectedIndex == index
                                ? const Color(0xffA7C587)
                                : AppColor.primary900Light,
                          ),
                          child: CustomTextWidget(
                            numbers[index],
                            textStyle: AppStyle.approvedViolationSelectedNumber,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  );
                },
              ),
            ),
          ]),
        );
      },
    );
  }
}
