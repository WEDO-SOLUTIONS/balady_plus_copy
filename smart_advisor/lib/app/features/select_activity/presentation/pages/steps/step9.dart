import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../../domain/entities/permits_activites_response.dart';
import '../../widgets/permit_item_card.dart';
import '../../widgets/title_subtitle_widget.dart';

class Step9Page extends StatefulWidget {
  static String title = "Step9Page";
  const Step9Page({super.key});

  @override
  State<Step9Page> createState() => _Step9PageState();
}

class _Step9PageState extends State<Step9Page> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
      //buildWhen: (previous, current) =>
      //previous.permitsStatus != current.permitsStatus ||
      //     previous.status != current.status,
      builder: (context, state) {
        Map<String, List<PermitItem>> permits = state.getPermits();

        return Container(
          color: AppColor.surfaceSecondaryColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
            child: SizedBox(
              // height: MediaQuery.of(context).size.height / 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'هل ترغب في تقديم أي من الخدمات التالية؟',
                      textAlign: TextAlign.center,
                      style: AppStyle.somarSemiBold
                          .copyWith(color: AppColor.textPrimaryColor),
                    ),
                    // const SizedBox(height: 4),
                    Text(
                      'تمثل الخدمات التصاريح الإضافية للرخصة',
                      textAlign: TextAlign.center,
                      style: AppStyle.textRegularStyle
                          .copyWith(color: AppColor.textSecondaryColor),
                    ),
                    //  const SizedBox(height: 24),
                    if (state.permitsStatus == BlocStatus.success) ...[
                      MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: permits.keys.length,
                            itemBuilder: (context, index) {
                              String key = permits.keys.toList()[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    permits[key]![0].detailedActivityName ?? "",
                                    style: AppStyle.textRegularRomanStyle,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: permits[key]!.length,
                                          itemBuilder: (context, index) {
                                            return PermitItemCard(
                                              currentValue: permits[key]![index]
                                                      .isSelected ??
                                                  false,
                                              isFreeOfCharge:
                                                  permits[key]![index]
                                                          .isFreeOfCharge ??
                                                      false,
                                              title:
                                                  permits[key]![index].name ??
                                                      "",
                                              onSelect: (bool? value) {
                                                context
                                                    .read<MainFlowBloc>()
                                                    .add(TogglePermitEvent(
                                                        index:
                                                            permits[key]![index]
                                                                .order!));
                                              },
                                            );
                                          }))
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                    if (state.permitsStatus == BlocStatus.failure ||
                        state.activityDetailsStatus == BlocStatus.failure)
                      Align(
                        alignment: Alignment.center,
                        child: ReloadWidget(
                          onTab: () {
                            if (state.permitsStatus == BlocStatus.failure) {
                              context
                                  .read<MainFlowBloc>()
                                  .add(const GetPermitsEvent());
                            }

                            if (state.activityDetailsStatus ==
                                BlocStatus.failure) {
                              context
                                  .read<MainFlowBloc>()
                                  .add(const GetActivityInfoDetails());
                            }
                          },
                        ),
                      ),
                    if (state.permitsStatus == BlocStatus.loading)
                      const Expanded(child: Shimmer2VerticalList()),

                    if ((state.permits?.isEmpty ?? true) &&
                        state.permitsStatus == BlocStatus.success) ...[
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
                  ]),
            ),
          ),
        );
      },
    );
  }
}
