import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/steps/step1.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '../blocs/main_flow_bloc/main_flow_bloc.dart';
import '../widgets/bottom_buttons.dart';

class MainFlowPageManageLicense extends StatefulWidget {
  final Widget? child;
  final bool isGuest;
  final bool isNextText;
  final String? nextText;
  const MainFlowPageManageLicense(
      {super.key,
      required this.isGuest,
      this.isNextText = true,
      this.nextText,
      this.child});

  @override
  State<MainFlowPageManageLicense> createState() =>
      _MainFlowPageManageLicenseState();
}

class _MainFlowPageManageLicenseState extends State<MainFlowPageManageLicense> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageMainFlowBloc(isGuest: widget.isGuest),
      child: BlocListener<ManageMainFlowBloc, ManageMainFlowState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure ||
              state.licenseStatus == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        child: BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
          builder: (context, state) {
            List<Widget> pages =
                context.read<ManageMainFlowBloc>().getPageContent();

            print("DDDFFFFF ${state.currentPages}");
            return Scaffold(
              backgroundColor: AppColor.backgroundColor,
              body: Stack(
                children: [
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'packages/smart_advisor/smart_advisor_assets/images/backshadow.png'), // Correct way to reference the asset image
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const NewAppBar(
                        title: "إدارة رخصة",
                        showClose: true,
                      ),
                      StepperWidget(
                        steps: pages.length,
                        currentStep: state.currentPages,
                      ),
                      Expanded(
                          child: PageView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: pages.length,
                              controller:
                                  context.read<ManageMainFlowBloc>().controller,
                              itemBuilder: (ctx, index) {
                                return pages[index];
                              })),
                      CustomBottomButtons(
                        nextText: pages.length - 1 == state.currentPages
                            ? "عرض النتيجة"
                            : widget.nextText ?? "التالي",
                        isNextOnly: false,
                        isNextDisabled: state.isNextDisabled(),
                        onNext: () {
                          context
                              .read<ManageMainFlowBloc>()
                              .add(const NextScreenEvent());
                        },
                        onPrev: () {
                          context
                              .read<ManageMainFlowBloc>()
                              .add(const PrevScreenEvent());
                        },
                      ),
                    ],
                  ),
                  if (state.status == BlocStatus.loading ||
                      state.licenseDetailsStatus == BlocStatus.loading ||
                      state.activityDetailsStatus == BlocStatus.loading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColor.statusAccentColor,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class StepperWidget extends StatefulWidget {
  final int steps;
  final int currentStep;
  const StepperWidget(
      {super.key, required this.steps, required this.currentStep});

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (int i = 0; i < widget.steps; i++) ...[
            StepIcon(
              isCompleted: i < widget.currentStep,
              isCurrent: i == widget.currentStep,
            ),
            const SizedBox(
              width: 8,
            ),
            StepBar(step: i < widget.currentStep ? 1 : 0)
          ],
        ],
      ),
    );
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
            value: step == 0 ? 0 : 1, // Value between 0.0 and 1.0
            minHeight: 10, // Customize height
            backgroundColor: const Color(0xffDDE1EC), // Background color
            color: const Color(0xff568F64), // Active progress color
          ),
        ),
      ),
    );
  }
}
