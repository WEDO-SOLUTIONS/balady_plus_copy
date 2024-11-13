import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../../../shared_features/widgets/check_box_item.dart';
import '../../blocs/main_flow_bloc/main_flow_bloc.dart';

class Step8Page extends StatefulWidget {
  static String title = "Step8Page";

  const Step8Page({super.key});

  @override
  State<Step8Page> createState() => _Step8PageState();
}

class _Step8PageState extends State<Step8Page> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(builder: (context, state) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F6FB),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (state.addetionalActivitesStatus == BlocStatus.failure)
                      Align(
                        alignment: Alignment.center,
                        child: ReloadWidget(
                          onTab: () {
                            context
                                .read<MainFlowBloc>()
                                .add(const GetAddetionalActivites());
                          },
                        ),
                      ),
                    if (state.addetionalActivitesStatus == BlocStatus.loading)
                      const Shimmer2VerticalList(),
                    if (state.addetionalActivitesStatus == BlocStatus.success)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "هل ستوفر أي من الأنشطة الإضافية التالية؟",
                                textAlign: TextAlign.center,
                                style: AppStyle.somarSemiBold
                                    .copyWith(color: AppColor.textPrimaryColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "اختر الأنشطة المناسبه من القائمة",
                                textAlign: TextAlign.center,
                                style: AppStyle.textRegularStyle.copyWith(
                                    color: AppColor.textSecondaryColor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              if (state.addetionalActivitesStatus ==
                                  BlocStatus.success)
                                MediaQuery.removePadding(
                                  removeTop: true,
                                  context: context,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(), // const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.addetionalActivitesResponse
                                            ?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return CheckBoxItem(
                                        color: AppColor.white,
                                        currentValue: state
                                                .addetionalActivitesResponse?[
                                                    index]
                                                .isSelected ??
                                            false,
                                        title: state
                                                .addetionalActivitesResponse?[
                                                    index]
                                                .activityName ??
                                            "",
                                        onSelect: (bool? value) {
                                          context.read<MainFlowBloc>().add(
                                              ToggleAddetionalActivity(
                                                  index: index));
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    if ((state.addetionalActivitesResponse?.isEmpty ?? true) &&
                        state.addetionalActivitesStatus ==
                            BlocStatus.success) ...[
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "packages/smart_advisor/smart_advisor_assets/images/searchimg.png",
                              height: 122,
                              width: 150,
                            ),
                            const SizedBox(height: 20),
                            /* Text(
                          'نتائج البحث',
                          style: AppStyle.calloutBoldStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(height: 10),*/
                            Text(
                              "لا يوجد",
                              textAlign: TextAlign.center,
                              style: AppStyle.textRegularRomanStyle
                                  .copyWith(color: const Color(0xFF566069)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
