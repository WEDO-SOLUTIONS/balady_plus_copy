import 'package:smart_advisor/app/features/select_activity/presentation/widgets/button_bottom.dart';

import '../../../_shared_feature_/presentation/widgets/no_data_found.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/select_activity/domain/entities/permits_page_params.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';

import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../../../shared_features/widgets/app_bar.dart';
import '../../../shared_features/widgets/check_box_item.dart';
import '../../domain/entities/addetional_activites_page_params.dart';
import '../blocs/addetional_activity_bloc/addetional_activity_bloc.dart';
import '../widgets/title_subtitle_widget.dart';

class AddetionalActivitesPage extends StatefulWidget {
  final ActivityDetailsPageParams params;
  const AddetionalActivitesPage({super.key, required this.params});

  @override
  State<AddetionalActivitesPage> createState() =>
      _AddetionalActivitesPageState();
}

class _AddetionalActivitesPageState extends State<AddetionalActivitesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddetionalActivityBloc>(
      create: (context) => AddetionalActivityBloc(args: widget.params),
      child: BlocBuilder<AddetionalActivityBloc, AddetionalActivityState>(
        buildWhen: (previous, current) =>
            previous.addetionalActivitesStatus !=
                current.addetionalActivitesStatus ||
            previous.status != current.status,
        builder: (context, state) {
          print("FFFFFF ${state.status}");
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(
                title: "addetional_activities".tr(),
              ),
              body: Container(
                color: AppColor.surfaceSecondaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                      child: SizedBox(
                        height: 430,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.addetionalActivitesStatus ==
                                BlocStatus.success)
                              const TitleSubTitleWidget(
                                title: "اختر الأنشطة الإضافية",
                                subTitle: "",
                              ),
                            if (state.addetionalActivitesStatus ==
                                BlocStatus.success)
                              const SizedBox(
                                height: 16,
                              ),
                            // const Textfield(),
                            /* const SizedBox(
                              height: 16,
                            ),*/
                            if (state.addetionalActivitesStatus ==
                                BlocStatus.success)
                              MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: Expanded(
                                  child: ListView.builder(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(), // const NeverScrollableScrollPhysics(),
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
                                          print(value);
                                          context
                                              .read<AddetionalActivityBloc>()
                                              .add(ToggleAddetionalActivity(
                                                  index: index));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            if (state.addetionalActivitesStatus ==
                                BlocStatus.failure)
                              ReloadWidget(
                                onTab: () {
                                  context
                                      .read<AddetionalActivityBloc>()
                                      .add(const GetAddetionalActivites());
                                },
                              ),
                            if (state.addetionalActivitesStatus ==
                                BlocStatus.loading)
                              const Expanded(child: Shimmer2VerticalList()),
                            if (state.addetionalActivitesStatus ==
                                    BlocStatus.success &&
                                (state.addetionalActivitesResponse?.isEmpty ??
                                    true)) ...[
                              const SizedBox(
                                height: 50,
                              ),
                              const Expanded(
                                  child: Center(child: NoDataFound()))
                            ]
                          ],
                        ),
                      ),
                    ),
                    ButtonBottomWidget(
                      text: "next".tr(),
                      onPress: () {
                        Navigator.pushNamed(context, RouteName.permitsPage,
                            arguments: widget.params.copyWith(
                                addetionalActivites:
                                    state.addetionalActivitesResponse
                                            ?.map((e) {
                                              if (e.isSelected == true) {
                                                return e;
                                              }
                                            })
                                            .toList()
                                            .nonNulls
                                            .toList() ??
                                        []));
                      },
                    ),
                    // Container(
                    //   alignment: AlignmentDirectional.bottomCenter,
                    //   padding: const EdgeInsets.only(top: 6),
                    //   decoration: const BoxDecoration(
                    //       color: AppColor.white,
                    //       borderRadius: BorderRadius.only(
                    //           topLeft: Radius.circular(10),
                    //           topRight: Radius.circular(10))),
                    //   child: Column(
                    //     children: [
                    //       Center(
                    //         child: Padding(
                    //           padding: const EdgeInsets.only(
                    //             bottom: 8.0,
                    //           ),
                    //           child: Container(
                    //             width: 40,
                    //             height: 4,
                    //             decoration: BoxDecoration(
                    //               color: AppColor.textPrimaryColor
                    //                   .withOpacity(.10),
                    //               borderRadius: const BorderRadius.all(
                    //                   Radius.circular(6)),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(16.0),
                    //         child: CustomButton(
                    //             onPress: () {
                    //               Navigator.pushNamed(
                    //                   context, RouteName.permitsPage,
                    //                   arguments: widget.params.copyWith(
                    //                       addetionalActivites: state
                    //                               .addetionalActivitesResponse
                    //                               ?.map((e) {
                    //                                 if (e.isSelected == true) {
                    //                                   return e;
                    //                                 }
                    //                               })
                    //                               .toList()
                    //                               .nonNulls
                    //                               .toList() ??
                    //                           []));
                    //             },
                    //             btnColor: AppColor.primary,
                    //             btnHeight: 45,
                    //             text: "next".tr()),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
