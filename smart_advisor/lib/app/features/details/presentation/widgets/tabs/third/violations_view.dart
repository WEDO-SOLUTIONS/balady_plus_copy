import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../../../../_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/features/details/presentation/bloc/details_bloc.dart';
import '/app/features/details/presentation/bloc/details_event.dart';
import '/app/features/details/presentation/bloc/details_state.dart';
import '/app/features/home2/widgets/objection_card.dart';
import '/app/features/home2/widgets/violating_commercial_activities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../data/models/entity_violation_activity_model.dart';

class ViolationsView extends StatefulWidget {
  const ViolationsView({super.key});

  @override
  State<ViolationsView> createState() => _ViolationsViewState();
}

class _ViolationsViewState extends State<ViolationsView> {
  int currentExpandedItem = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        Map<String, List<EntityViolationActivityModel>> violations =
            state.getViolations();

        return Stack(
          children: [
            if (state.violationStatus == BlocStatus.loading)
              const Shimmer2VerticalList(
                height: 50,
              ),
            if (state.violationStatus == BlocStatus.failure)
              ReloadWidget(
                onTab: () {
                  context.read<DetailsBloc>().add(GetViolationsListEvent());
                },
              ),
            if (state.violationStatus == BlocStatus.success)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                MediaQuery.removePadding(
                  removeTop: true,
                  removeBottom: true,
                  context: context,
                  child: ListView.builder(
                    itemCount: violations.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          NonExpandableItem(
                            dataModel:
                                violations[violations.keys.elementAt(index)] ??
                                    [],
                            title: violations.keys.elementAt(index),
                            /*  onChangedExpansion: () {
                              if (currentExpandedItem == index) {
                                currentExpandedItem = -1;
                              } else {
                                currentExpandedItem = index;
                              }
                              setState(() {});
                            },
                            currentExpandedItem: currentExpandedItem,*/
                            currentIndex: index,
                          )
                        ],
                      );
                    },
                  ),
                ),
                /* ExpandableItem(
            dataModel: list[1],
            currentExpandedItem: currentExpandedItem,
            currentIndex: 1,
            onChangedExpansion: () {
              setState(() {
                currentExpandedItem = 1;
              });
            },
          ),*/
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "الاعتراضات",
                    style: AppStyle.heading2BoldStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    //   BaladyServices.openObjections();
                  },
                  child: Container(
                    height: 116,
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(6)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "التقديم علي اعتراض",
                          style: AppStyle.textRegularStyle
                              .copyWith(color: const Color(0xff18182D)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "لمعرفة التقديم على الإعتراضات الخاصة بالمخالفات",
                          style: AppStyle.textRegularStyle
                              .copyWith(color: AppColor.textSecondaryColor),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                /* CustomButton(
                    btnColor: AppColor.surfaceAccentSecondaryColor,
                    textColor: AppColor.statusAccentColor,
                    onPress: () {
                      //    BaladyServices.openObjections();
                    },
                    text: "التقديم على اعتراض"),*/
                /*const ObjectionCard(
            title: "التقديم على أعتراض",
            details: "",
          ),*/
                const SizedBox(
                  height: 5,
                ),
              ]),
            if (state.violationDetailsStatus == BlocStatus.loading)
              Center(
                child: CircularProgressIndicator(
                  color: AppColor.statusAccentColor,
                ),
              ),
          ],
        );
      },
    );
  }
}

class ExpandableItem extends StatefulWidget {
  final List<EntityViolationActivityModel> dataModel;
  final String title;
  final int currentExpandedItem;
  final Function onChangedExpansion;
  final int currentIndex;
  const ExpandableItem(
      {super.key,
      required this.title,
      required this.dataModel,
      required this.currentExpandedItem,
      required this.onChangedExpansion,
      required this.currentIndex});

  @override
  State<ExpandableItem> createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<ExpandableItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChangedExpansion();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: AppColor.surfaceSecondaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: AppStyle.textRegularRomanStyle,
                ),
                if (widget.currentIndex == widget.currentExpandedItem)
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColor.textTertiaryColor,
                  ),
                if (widget.currentIndex != widget.currentExpandedItem)
                  RotatedBox(
                    quarterTurns: 3,
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColor.textTertiaryColor,
                    ),
                  )
              ],
            ),
            if (widget.currentIndex == widget.currentExpandedItem)
              ListView.builder(
                itemCount: widget.dataModel.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: () {
                      context.read<DetailsBloc>().add(
                          GetViolationDetailsEvent(item: widget.dataModel[i]));
                    },
                    child: ViolatingCommercialActivities(
                      dataModel: widget.dataModel[i],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class NonExpandableItem extends StatefulWidget {
  final List<EntityViolationActivityModel> dataModel;
  final String title;
  final int currentIndex;
  const NonExpandableItem(
      {super.key,
      required this.title,
      required this.dataModel,
      required this.currentIndex});

  @override
  State<NonExpandableItem> createState() => _NonExpandableItemState();
}

class _NonExpandableItemState extends State<NonExpandableItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //   widget.onChangedExpansion();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: AppColor.surfaceSecondaryColor,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  style: AppStyle.textRegularRomanStyle,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              itemCount: widget.dataModel.length ?? 0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onTap: () {
                    context.read<DetailsBloc>().add(
                        GetViolationDetailsEvent(item: widget.dataModel[i]));
                  },
                  child: ViolatingCommercialActivities(
                    dataModel: widget.dataModel[i],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
