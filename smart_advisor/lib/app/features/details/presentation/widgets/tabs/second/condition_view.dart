import '../../../../../_shared_feature_/presentation/widgets/custom_widgets/general_items_dialog.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_widgets/general_items_html_dialog.dart';
import '../../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/location_condition.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/details/presentation/bloc/details_bloc.dart';
import '/app/features/details/presentation/bloc/details_event.dart';
import '/app/features/details/presentation/bloc/details_state.dart';
import '/app/features/details/presentation/widgets/tabs/second/genral_condetion_list.dart';
import '/app/features/details/presentation/widgets/tabs/second/municipality_condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';
import 'special_condtion.dart';

class ConditionView extends StatelessWidget {
  const ConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<DetailsBloc, DetailsState>(
            builder: (context, state) {
              return Stack(
                children: [
                  if (state.regulationStatus == BlocStatus.loading)
                    const Shimmer2VerticalList(
                      height: 50,
                    ),
                  if (state.regulationStatus == BlocStatus.failure)
                    ReloadWidget(
                      onTab: () {
                        context.read<DetailsBloc>().add(GetRegulationsEvent());
                      },
                    ),
                  if (state.regulationStatus == BlocStatus.success)
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ("general_requirements").tr(),
                                style: AppStyle.heading2BoldStyle
                                    .copyWith(color: AppColor.textPrimaryColor),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: const Color(0xff000000),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        GeneralItemsDialog(
                                      title: ("general_requirements").tr(),
                                      items: state.regulationResponse
                                              ?.generalRules ??
                                          [],
                                    ),
                                  );
                                },
                                child: Text(
                                  "جميع الإشتراطات",
                                  style: AppStyle.footNoteBoldStyle.copyWith(
                                      color: AppColor.statusAccentColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GeneralConditionsWidget(
                            items: state.regulationResponse?.generalRules ?? [],
                            title: ("general_requirements").tr(),
                          ),

                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ("location_requirements").tr(),
                                style: AppStyle.heading2BoldStyle
                                    .copyWith(color: AppColor.textPrimaryColor),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: const Color(0xff000000),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        GeneralItemsDialog(
                                      title: ("location_requirements").tr(),
                                      items: state.regulationResponse
                                              ?.locationRules ??
                                          [],
                                    ),
                                  );
                                },
                                child: Text(
                                  "جميع الإشتراطات",
                                  style: AppStyle.footNoteBoldStyle.copyWith(
                                      color: AppColor.statusAccentColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GeneralConditionsWidget(
                            items:
                                state.regulationResponse?.locationRules ?? [],
                            title: ("location_requirements").tr(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ("specialـrequirements").tr(),
                                style: AppStyle.heading2BoldStyle
                                    .copyWith(color: AppColor.textPrimaryColor),
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor: const Color(0xff000000),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        GeneralItemsHtmlDialog(
                                            title: "specialـrequirements".tr(),
                                            items: state.regulationResponse
                                                    ?.specialRules ??
                                                []),
                                  );
                                },
                                child: Text(
                                  "جميع الإشتراطات",
                                  style: AppStyle.footNoteBoldStyle.copyWith(
                                      color: AppColor.statusAccentColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),

                          // add list here
                          const SpecialCondtion(),

                          const SizedBox(
                            height: 32,
                          ),

                          /*  Text(
                        ("اشتراطات الامانه"),
                        style: AppStyle.heading2BoldStyle
                            .copyWith(color: AppColor.textPrimaryColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                                
                      const MunicipalityCondition(),*/
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
