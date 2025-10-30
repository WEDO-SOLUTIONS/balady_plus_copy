import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card%20copy.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/bottom_buttons.dart';
import 'package:smart_advisor/app/features/self_rating/presentation/pages/rating_item_page.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
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
  final ScrollController _controller = ScrollController();

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
            return Scaffold(
                backgroundColor: AppColor.backgroundColor,
                body: Stack(
                  children: [
                    if (state.status != BlocStatus.loading)
                      Column(
                        children: [
                          ClausesAppBar(
                            title: "تقييم منشأتي",
                          ),
                          //  if (widget.args.isFromHome == true)

                          StepperWidget(
                            currentStep: _currentPage,
                            totalSteps: state.sortedItems?.length ?? 1,
                          ),
                          if (state.itemsStatus == BlocStatus.failure)
                            Align(
                                alignment: Alignment.center,
                                child: ReloadWidget(
                                  onTab: () {
                                    context
                                        .read<RatingBloc>()
                                        .add(const GetRatings());
                                  },
                                )),
                          if (state.itemsStatus == BlocStatus.loading)
                            const Shimmer2VerticalList(),
                          if (state.itemsStatus == BlocStatus.success &&
                              state.status != BlocStatus.loading)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Text(
                                      "حدد حالة امتثالك للبنود الاساسية التالية",
                                      style: AppStyle.accentBoldStyle.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: ListView.builder(
                                        itemCount:
                                            state.sortedItems?.keys.length ?? 0,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (ctx, index) {
                                          final key = state.sortedItems?.keys
                                              .elementAt(index);
                                          final items =
                                              state.sortedItems?[key] ?? [];
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          RatingItemPage(
                                                            items: items,
                                                            title: key ??
                                                                "" /*state
                                                                .getClausesName(
                                                                    key ?? 0)*/
                                                            ,
                                                          ))).then((v) {
                                                if (v != null) {
                                                  context
                                                      .read<RatingBloc>()
                                                      .add(UpdateItemsRatings(
                                                        items: v,
                                                        key: key ?? "",
                                                      ));
                                                }
                                              });
                                            },
                                            child: ClauseNameGroupItem(
                                                clauseName: key ??
                                                    "" /*state
                                                    .getClausesName(key ?? 0)*/
                                                ,
                                                totalSubClauses: items
                                                    .where((e) =>
                                                        e.isDuplicated != true)
                                                    .length,
                                                noOfNonComplianceItem: state
                                                    .getNoOfNonCompliaanceReason(
                                                        items)),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                          /*  Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PageView.builder(
                                itemCount: state.sortedItems?.length ?? 0,
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, i) {
                                  // Access the key and value at the current index
                      
                                  return SingleChildScrollView(
                                    controller: _controller,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //state.getClausesName(key ?? 0)
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
                          ),*/

                          Container(
                            height: 100,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColor.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: CustomButton(
                                btnHeight: 52,
                                isDisabled:
                                    state.itemsStatus == BlocStatus.loading ||
                                        isNextDisabled(state.sortedItems?.values
                                                .expand((e) => e)
                                                .toList() ??
                                            []),
                                onPress: () {
                                  context
                                      .read<RatingBloc>()
                                      .add(SubmitRatings());
                                },
                                text: "النتيجة"),
                          )
                        ],
                      ),
                    if (state.status == BlocStatus.loading)
                      Align(
                        alignment: Alignment.center,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColor.statusAccentColor,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                "جاري إحتساب درجة الإمتثال",
                                style: AppStyle.somarSemiBold.copyWith(
                                    color: Color(0xff465463), fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      )
                  ],
                ));
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

class ClauseNameGroupItem extends StatelessWidget {
  final int? noOfNonComplianceItem;
  final int totalSubClauses;

  final String clauseName;

  const ClauseNameGroupItem(
      {this.noOfNonComplianceItem,
      required this.clauseName,
      required this.totalSubClauses});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      "packages/smart_advisor/smart_advisor_assets/icons/png/clause_icon.png",
                      height: 45,
                      width: 45,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clauseName ?? "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Row(
                            children: [
                              Text(
                                '${totalSubClauses} بنود',
                                style: AppStyle.footNoteMediumStyle.copyWith(
                                    color: Color(
                                      0xff637381,
                                    ),
                                    fontSize: 14),
                              ),
                              SizedBox(width: 8.0),
                              if (noOfNonComplianceItem != null)
                                Text(
                                  '${noOfNonComplianceItem} بنود غير ممتثله',
                                  style:
                                      AppStyle.textRegularRomanStyle.copyWith(
                                          color: Color(
                                            0xffFB923C,
                                          ),
                                          fontSize: 14),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff1C252E),
                size: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClausesAppBar extends StatelessWidget {
  final String title;
  const ClausesAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0x3398FCFF), // 20% opacity
            Color(0x00ADC587), // 0% opacity
          ],
          radius:
              1.0, // Adjust the radius to control the spread of the gradient
          center: Alignment.topLeft, // Set the center of the gradient
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          bottom: 12,
          left: 12,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    NavigationService.navigatorKey.currentState!.pop(context);
                  },
                  icon: SvgPicture.asset(
                    IconPath.newBackIcon,
                    width: 24,
                    height: 24,
                    color: AppColor.textPrimaryColor, //statusAccentColor,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          style: AppStyle.callout1BoldStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
