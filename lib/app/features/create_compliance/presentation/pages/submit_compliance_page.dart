import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/fifth_submit_step.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/first_submit_step_compliance.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/fourth_step_compliance.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/license_page.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/second_submit_step_compliance.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/third_submit_step_compliance.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/details_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitCompliancePage extends StatefulWidget {
  const SubmitCompliancePage({super.key});

  @override
  State<SubmitCompliancePage> createState() => _SubmitCompliancePageState();
}

class _SubmitCompliancePageState extends State<SubmitCompliancePage> {
  PageController pageController = PageController(initialPage: 0);
  double currentStep = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ComplianceBloc(),
      child: BlocBuilder<ComplianceBloc, ComplianceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.scaffoldBackground,
            appBar: ViolationAppBar(
              backOnPress: () {},
              stepCounter: 6,
              currentStep: state.currentStep,
            ),
            body: Container(
                padding: const EdgeInsets.all(8),
                child: PageView(
                  onPageChanged: (int index) {
                    context
                        .read<ComplianceBloc>()
                        .add(ChangePageEvent(index.toDouble()));
                  },
                  controller: pageController,
                  children: [
                    FirstComplianceSubmissionWidget(
                      onPressed: () {
                        pageController.jumpToPage(1);
                        context.read<ComplianceBloc>().add(ChangePageEvent(2));
                      },
                    ),
                    SecondSubmissonCompliance(
                      onPressed: () {
                        pageController.jumpToPage(2);
                        context.read<ComplianceBloc>().add(ChangePageEvent(3));
                      },
                    ),
                    ThirdSubmissionCompliance(
                      onPressed: () {
                        pageController.jumpToPage(3);
                        context.read<ComplianceBloc>().add(ChangePageEvent(4));
                      },
                    ),
                    ComplianceLicensePage(
                      onPressed: () {
                        pageController.jumpToPage(4);
                        context.read<ComplianceBloc>().add(ChangePageEvent(5));
                      },
                    ),
                    FourthStepCompliance(
                      onPressed: () {
                        pageController.jumpToPage(5);
                        context.read<ComplianceBloc>().add(ChangePageEvent(6));
                      },
                    ),
                    FifthComplianceSubmitStep(),
                  ],
                )),
          );
        },
      ),
    );
  }
}
