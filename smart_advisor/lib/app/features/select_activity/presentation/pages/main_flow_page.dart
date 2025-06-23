import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '../blocs/main_flow_bloc/main_flow_bloc.dart';
import '../widgets/bottom_buttons.dart';

class MainFlowPage extends StatefulWidget {
  const MainFlowPage({super.key});

  @override
  State<MainFlowPage> createState() => _MainFlowPageState();
}

class _MainFlowPageState extends State<MainFlowPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainFlowBloc(),
      child: BlocListener<MainFlowBloc, MainFlowState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure ||
              state.detailsStatus == BlocStatus.failure ||
              state.workFlowStatus == BlocStatus.failure ||
              state.isicsStatus == BlocStatus.failure ||
              state.detailsStatus == BlocStatus.failure ||
              state.addetionalActivitesStatus == BlocStatus.failure ||
              state.activityDetailsStatus == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        child: BlocBuilder<MainFlowBloc, MainFlowState>(
          builder: (context, state) {
            List<Widget> steps = context.read<MainFlowBloc>().getStepsPages();
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColor.backgroundColor,
                  body: Stack(
                    children: [
                      Container(
                        height: 400,
                        decoration: const BoxDecoration(
                          // color: Colors.red,
                          image: DecorationImage(
                            image: AssetImage(
                                'packages/smart_advisor/smart_advisor_assets/images/backshadow.png'), // Correct way to reference the asset image
                            fit: BoxFit
                                .cover, // Adjust the fit of the image if needed
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            NewAppBar(
                              title: context.read<MainFlowBloc>().getTitle(),
                              showClose: true,
                            ),
                            StepperWidget(
                              currentPartStep: state.currentPage,
                              currentStep: state.currentPage,
                            ),
                            Expanded(
                              child: PageView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: steps.length,
                                  controller:
                                      context.read<MainFlowBloc>().controller,
                                  itemBuilder: (ctx, index) {
                                    return steps[index];
                                  }),
                            ),
                            CustomBottomButtons(
                              isNextOnly: state.currentPage == 0,
                              isNextDisabled: state.isNextDisabled(),
                              onNext: () {
                                context
                                    .read<MainFlowBloc>()
                                    .add(const NextPageEvent());
                              },
                              onPrev: () {
                                context
                                    .read<MainFlowBloc>()
                                    .add(const PrevPageEvent());
                              },
                            ),
                          ],
                        ),
                      ),
                      if (state.districtsStatus == BlocStatus.loading ||
                          state.status == BlocStatus.loading ||
                          state.workFlowStatus == BlocStatus.loading ||
                          state.addetionalActivitesStatus ==
                              BlocStatus.loading ||
                          state.activityDetailsStatus == BlocStatus.loading)
                        Center(
                          child: CircularProgressIndicator(
                            color: AppColor.statusAccentColor,
                          ),
                        ),
                    ],
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

class StepperWidget extends StatefulWidget {
  final int currentPartStep;
  final int currentStep;
  const StepperWidget(
      {super.key, required this.currentPartStep, required this.currentStep});

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  @override
  Widget build(BuildContext context) {
    int step = getStep(widget.currentStep);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          StepIcon(
            isCompleted: step > 1,
            isCurrent: step == 1,
          ),
          const SizedBox(
            width: 8,
          ),
          StepBar(
            step: step > 1
                ? 3
                : step == 1
                    ? getValue(widget.currentPartStep)
                    : 0,
          ),
          const SizedBox(
            width: 8,
          ),
          StepIcon(
            isCompleted: step > 2,
            isCurrent: step == 2,
          ),
          const SizedBox(
            width: 8,
          ),
          StepBar(
            step: step > 2
                ? 3
                : step == 2
                    ? getValue(widget.currentPartStep)
                    : 0,
          ),
          const SizedBox(
            width: 8,
          ),
          StepIcon(
            isCompleted: step == 3,
            isCurrent: step == 3,
          ),
          StepBar(
            step: step > 3
                ? 3
                : step == 3
                    ? getValue(widget.currentPartStep)
                    : 0,
          ),
          const SizedBox(
            width: 8,
          ),
          StepIcon(
            isCompleted: step > 4,
            isCurrent: step == 4,
          ),
        ],
      ),
    );
  }

  int getValue(int currentIndex) {
    print("current Step $currentIndex");
    switch (currentIndex) {
      case 0:
      case 1:
      case 2:
        return 1;
      case 3:
      case 4:
        return 2;
      case 5:
        return 3;

      case 6:
        return 2;

      case 7:
        return 2;

      case 8:
        return 2;
      case 9:
        return 3;

      default:
        return 3;
    }
  }

  int getStep(int currentIndex) {
    switch (currentIndex) {
      case 0:
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        return 1;

      case 6:
      case 7:
      case 8:
        return 2;
      case 9:
        return 3;

      default:
        return 3;
    }
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
  // final int currentStep;
  // final int totalStep;
  const StepBar({
    super.key,
    required this.step,
    // required this.currentStep,
    //required this.totalStep
  });

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
            value: step == 0
                ? 0
                : step == 1
                    ? 0.3
                    : step == 2
                        ? 0.6
                        : step == 3
                            ? 1
                            : 0, // Value between 0.0 and 1.0
            minHeight: 10, // Customize height
            backgroundColor: const Color(0xffDDE1EC), // Background color
            color: const Color(0xff568F64), // Active progress color
          ),
        ),
      ),
    );
  }
}
