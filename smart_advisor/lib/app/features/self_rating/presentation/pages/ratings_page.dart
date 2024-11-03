import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card%20copy.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/bottom_buttons.dart';

import '../../../shared_features/new_app_bar.dart';
import '../../data/models/rating_items_response.dart';
import '../bloc/rating_bloc.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RatingItemsPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const RatingItemsPage({super.key, required this.args});

  @override
  State<RatingItemsPage> createState() => _RatingItemsPageState();
}

class _RatingItemsPageState extends State<RatingItemsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RatingBloc(args: widget.args),
      child: BlocListener<RatingBloc, RatingState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        child: BlocBuilder<RatingBloc, RatingState>(
          builder: (context, state) {
            final key = state.sortedItems?.keys.elementAt(_currentPage);
            final items = state.sortedItems?[key] ?? [];

            return Stack(
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF8FFEC)
                            .withOpacity(0.73), // Lightest color with opacity
                        const Color(0xFFEBE9FF)
                            .withOpacity(0.52), // Mid color with opacity
                        const Color(0xFFEAF6D8).withOpacity(0.73),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [
                        0.0,
                        0.5,
                        1.0
                      ], // Adjust the stop points for smooth gradient transition
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: AppColor.backgroundColor,
                  body: Column(
                    children: [
                      NewAppBar(
                        title: "تقييم منشأتى",
                        showClose: true,
                      ),
                      //  if (widget.args.isFromHome == true)
                      StepperWidget(
                        currentStep: _currentPage,
                        totalSteps: state.sortedItems?.length ?? 1,
                      ),
                      if (state.itemsStatus == BlocStatus.loading)
                        const Shimmer2VerticalList(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: PageView.builder(
                            itemCount: state.sortedItems?.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              // Access the key and value at the current index

                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.getClausesName(key ?? 0),
                                      style: AppStyle.accentBoldStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                        itemCount: items.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (ctx, j) {
                                          return RatingWidgetItem(
                                            item: items[j],
                                            onSelect: (value) {
                                              context.read<RatingBloc>().add(
                                                  ChangeItemRating(
                                                      ratnig: value,
                                                      i: key ?? 0,
                                                      j: j));
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      CustomBottomButtons(
                        isNextOnly: _currentPage == 0,
                        isNextDisabled: isNextDisabled(items),
                        onNext: () {
                          int temp = _currentPage + 1;
                          try {
                            final key = state.sortedItems?.keys.elementAt(temp);
                            if (key != null) {
                              _currentPage++;
                              setState(() {});
                            } else {
                              context.read<RatingBloc>().add(SubmitRatings());
                            }
                          } catch (ex) {
                            context.read<RatingBloc>().add(SubmitRatings());
                          }
                        },
                        onPrev: () {
                          int temp = _currentPage - 1;
                          try {
                            final key = state.sortedItems?.keys.elementAt(temp);
                            if (key != null) {
                              _currentPage--;
                              setState(() {});
                            }
                          } catch (ex) {}
                        },
                      ),
                    ],
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColor.statusAccentColor,
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  bool isNextDisabled(List<RatingItemsResponseItem> items) {
    bool isValid = false;

    for (var e in items) {
      if (e.isClausesValidated == null) {
        isValid = true;
        break;
      }
    }

    return isValid;
  }
}

class RatingWidgetItem extends StatelessWidget {
  final RatingItemsResponseItem item;
  final Function(int value) onSelect;

  const RatingWidgetItem({
    super.key,
    required this.item,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 16),
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: const Color(0xffE2E9F0),
        ),
      ),
      child: Column(
        children: [
          Text(
            item.subClauseName ?? "",
            style: AppStyle.textRegularRomanStyle.copyWith(
              color: const Color(0xA1465463),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ComponentItem(
                isClauseValidated: item.isClausesValidated == 0,
                index: 0,
                onTap: () => onSelect(0),
                text: "ممتثل",
                icon:
                    'packages/smart_advisor/smart_advisor_assets/icons/svg/user-smile-fill@2x.svg',
              ),
              ComponentItem(
                isClauseValidated: item.isClausesValidated == 2,
                index: 2,
                onTap: () => onSelect(2),
                text: "غير ممتثل",
                icon:
                    'packages/smart_advisor/smart_advisor_assets/icons/svg/emotion-sad-fill.svg',
              ),
              ComponentItem(
                isClauseValidated: item.isClausesValidated == 1,
                index: 1,
                onTap: () => onSelect(1),
                text: "لا ينطبق",
                icon:
                    'packages/smart_advisor/smart_advisor_assets/icons/svg/Info.svg',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ComponentItem extends StatelessWidget {
  final bool? isClauseValidated;
  final String text;
  final String icon;
  final Function onTap;
  final int index;

  const ComponentItem(
      {super.key,
      this.isClauseValidated,
      required this.text,
      required this.onTap,
      required this.index,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 38,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: getColorBg(index, isClauseValidated ?? false),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: getColorBorder(index, isClauseValidated ?? false),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              color: getColorBorder(index, isClauseValidated ?? false),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              text,
              style: AppStyle.textRegularRomanStyle.copyWith(
                fontSize: 12,
                color: isClauseValidated == true
                    ? getTextColor(index)
                    : const Color(0xA1465463),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to determine border color based on selection
  Color getColorBorder(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected ? const Color(0xFF568F64) : const Color(0xFFD7DEE4);
      case 1:
        return isSelected ? const Color(0x9E1E2A36) : const Color(0xFFD7DEE4);
      case 2:
        return isSelected ? const Color(0xFFFFA726) : const Color(0xFFD7DEE4);
      default:
        return const Color(0xFFE2E9F0);
    }
  }

  // Function to determine background color based on selection
  Color getColorBg(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected
            ? const Color(0x15568F64)
            : const Color(0xFFF8FAFC); // Light Green
      case 1:
        return isSelected
            ? const Color(0x10568F64)
            : const Color(0xFFF8FAFC); // Light Gray
      case 2:
        return isSelected ? const Color(0x1AFA8B64) : const Color(0xFFF8FAFC);

      /// Light Orange
      default:
        return const Color(0xFFF8FAFC);
    }
  }

  // Function to determine text color based on selection
  Color getTextColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF568F64); // Green
      case 1:
        return const Color(0xFFA7A7A7); // Gray
      case 2:
        return const Color(0xFFFFA726); // Orange
      default:
        return const Color(0xFFA7A7A7);
    }
  }
}

class StepperWidget extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  const StepperWidget(
      {super.key, required this.currentStep, required this.totalSteps});

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          StepIcon(
            isCompleted: true,
            isCurrent: false,
          ),
          const SizedBox(
            width: 8,
          ),
          StepBar(
            step: widget.totalSteps,
            totalSteps: widget.totalSteps,
          ),
          const SizedBox(
            width: 8,
          ),
          StepIcon(
            isCompleted: true,
            isCurrent: false,
          ),
          const SizedBox(
            width: 8,
          ),
          StepBar(
            step: widget.totalSteps,
            totalSteps: widget.totalSteps,
          ),
          const SizedBox(
            width: 8,
          ),
          StepIcon(
            isCompleted: true,
            isCurrent: false,
          ),
          StepBar(
            step: widget.currentStep,
            totalSteps: widget.totalSteps,
          ),
          const SizedBox(
            width: 8,
          ),
          StepIcon(
            isCompleted: widget.currentStep == widget.totalSteps,
            isCurrent: true,
          ),
        ],
      ),
    );
  }

  int getValue(int currentIndex) {
    print("current Step ${currentIndex}");
    return currentIndex;
  }

  int getStep(int currentIndex) {
    return 3;
  }
}

class StepIcon extends StatelessWidget {
  final bool isCurrent;
  final bool isCompleted;
  const StepIcon(
      {super.key, required this.isCurrent, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    if (isCompleted) return SvgPicture.asset(IconPath.stepCompleted);

    if (isCurrent) return SvgPicture.asset(IconPath.stepActive);
    return SvgPicture.asset(IconPath.stepInActive);
  }
}

class StepBar extends StatelessWidget {
  final int step;
  final int totalSteps;
  const StepBar({super.key, required this.step, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(800),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: step / totalSteps, // Value between 0.0 and 1.0
            minHeight: 10, // Customize height
            backgroundColor: Color(0xffDDE1EC), // Background color
            color: const Color(0xff568F64), // Active progress color
          ),
        ),
      ),
    );
  }
}
