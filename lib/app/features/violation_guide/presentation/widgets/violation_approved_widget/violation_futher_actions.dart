import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_state.dart';

class ViolationFurtherAction extends StatelessWidget {
  const ViolationFurtherAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: AppColor.white),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomTextWidget(
            'action_taken'.tr(),
            textStyle: AppStyle.approvedViolationLabelStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
              itemCount: state.details?.listofPenalities?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return Container(
                  height: 56,
                  margin: EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: ShapeDecoration(
                    color: AppColor.primary100Light,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomTextWidget(
                            state.details?.listofPenalities?[index]
                                    .penalityName ??
                                "",
                            fontColor: Color(0xCC292929),
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: AppFontWeight.medium,
                            maxLines: 20,
                          ),
                        ),
                        if (state.details?.listofPenalities?[index]
                                .penalityPeriod !=
                            null)
                          Container(
                            alignment: Alignment.center,
                            height: 24,
                            width: 60,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: ShapeDecoration(
                              color: Color(0xFF145E75),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: CustomTextWidget(
                              "${state.details?.listofPenalities?[index].penalityPeriod} ${"lbl_day".tr()}"
                              "",
                              fontColor: AppColor.white,
                              fontSize: 12,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          )
                      ]),
                );
              }))
        ]),
      );
    });
  }
}
