import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/details/data/models/violation_details_vd_model.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../../../../_shared_feature_/presentation/widgets/shimmer_card.dart';
import '../../../../../home_page/presentation/widgets/filter_dialog.dart';
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
  int violationSelection = 0;
  bool? filterViolation;
  bool? filterVDViolation;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            List<EntityViolationActivityModel>? violations;
            List<ViolationDetailsVdModel>? vdViolations;

            // Map<String, List<EntityViolationActivityModel>> violations =
            //     state.getViolations();

            violations = state.violations?.where((e) {
              if (filterViolation != null) {
                return e.isCritical == filterViolation.toString();
              } else {
                return true;
              }
            }).toList();

            vdViolations = state.vdViolationList?.where((e) {
              if (filterVDViolation != null) {
                return e.isCritical == filterVDViolation.toString();
              } else {
                return true;
              }
            }).toList();

            return Stack(
              children: [
                if (state.violationStatus == BlocStatus.loading ||
                    state.vdViolationStatus == BlocStatus.loading)
                  const Shimmer2VerticalList(
                    height: 50,
                  ),
                if (state.violationStatus == BlocStatus.failure &&
                    violationSelection == 0)
                  ReloadWidget(
                    onTab: () {
                      context.read<DetailsBloc>().add(GetViolationsListEvent());
                    },
                  ),
                if (state.vdViolationStatus == BlocStatus.failure &&
                    violationSelection == 1)
                  ReloadWidget(
                    onTab: () {
                      context.read<DetailsBloc>().add(GetViolationVD());
                    },
                  ),
                if (state.violationStatus == BlocStatus.success)
                  SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* Selection(
                            currentSelect: violationSelection,
                            onSelect: (int index) {
                              setState(() {
                                violationSelection = index;
                              });
                            },
                          ),*/
                          /*  const SizedBox(
                            height: 24,
                          ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "جميع القوائم",
                                style: AppStyle.somarSemiBold,
                              ),
                              FilterButton(
                                isCritical: violationSelection == 0
                                    ? filterViolation
                                    : filterVDViolation,
                                onTap: () async {
                                  int? v = await showModalBottomSheet(
                                    backgroundColor: const Color(0xff000000),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        FilterDialog(
                                            selection: violationSelection == 0
                                                ? filterViolation == true
                                                    ? 1
                                                    : filterViolation == false
                                                        ? 2
                                                        : 0
                                                : filterVDViolation == true
                                                    ? filterViolation == true
                                                        ? 1
                                                        : filterViolation ==
                                                                false
                                                            ? 2
                                                            : 0
                                                    : null),
                                  );
                                  if (v != null) {
                                    if (violationSelection == 0) {
                                      filterViolation = v == 1
                                          ? true
                                          : v == 2
                                              ? false
                                              : null;
                                    } else {
                                      filterVDViolation = v == 1
                                          ? true
                                          : v == 2
                                              ? false
                                              : null;
                                    }
                                  }

                                  setState(() {});
                                },
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (violationSelection == 0)
                            MediaQuery.removePadding(
                              removeTop: true,
                              removeBottom: true,
                              context: context,
                              child: ListView.builder(
                                itemCount: violations?.length ?? 0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<DetailsBloc>().add(
                                          GetViolationDetailsEvent(
                                              item: violations![index]));
                                    },
                                    child: ViolatingCommercialActivities(
                                      dataModel: violations![index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (violationSelection == 1)
                            MediaQuery.removePadding(
                              removeTop: true,
                              removeBottom: true,
                              context: context,
                              child: ListView.builder(
                                itemCount: vdViolations?.length ?? 0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.read<DetailsBloc>().add(
                                          GetViolationDetailsEvent(
                                              item: vdViolations![index]
                                                  .toViolationModel()));
                                    },
                                    child: ViolatingCommercialActivities(
                                      dataModel: vdViolations![index]
                                          .toViolationModel(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(
                            height: 32,
                          ),
                        ]),
                  ),
                if (state.violationDetailsStatus == BlocStatus.loading)
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColor.statusAccentColor,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
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

class Selection extends StatelessWidget {
  final int currentSelect;
  final Function onSelect;
  const Selection({super.key, this.currentSelect = 0, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onSelect(0),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                  color: currentSelect == 0
                      ? AppColor.statusAccentColor
                      : AppColor.white,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(
                "المخالفات",
                maxLines: 1,
                // overflow:
                //     TextOverflow.ellipsis,
                style: AppStyle.footNoteRomanStyle.copyWith(
                    color: currentSelect == 0
                        ? Colors.white
                        : AppColor.textSecondaryColor),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onSelect(1),
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: currentSelect == 1
                    ? AppColor.statusAccentColor
                    : AppColor.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
              ),
              child: Text(
                "مخالفات التشوه البصري",
                //style: AppStyle.heading2BoldStyle .copyWith(color: AppColor.textPrimaryColor),
                style: AppStyle.footNoteRomanStyle.copyWith(
                  color: currentSelect == 1
                      ? Colors.white
                      : AppColor.textSecondaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final Function onTap;
  final bool? isCritical;
  const FilterButton({super.key, this.isCritical, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // Rounded corners
          border: Border.all(
              color: Colors.grey[300]!, width: 1.5), // Border color and width
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Adjust to content size
          children: [
            SvgPicture.asset(
              IconPath.filterIcon, // Filter icon
            ),
            const SizedBox(width: 8), // Space between text and icon

            Text(
              'تصفية النتائج', // Text
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textSecondaryColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
