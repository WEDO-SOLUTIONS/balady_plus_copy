import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_event.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationApprovedHortizantalList extends StatelessWidget {
  const ViolationApprovedHortizantalList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
      builder: (context, state) {
        List<String> numbers = ['0', '1', '2', '3'];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff155f75),
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            CustomTextWidget(
              'approved_violation_text_1'.tr(),
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                width: 1,
                                color: state.selectedIndex == index
                                    ? const Color(0xffA7C587)
                                    : const Color(0xffA1BFC8)),
                            color: state.selectedIndex == index
                                ? const Color(0xffA7C587)
                                : const Color(0xff155F75),
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
