import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';

class CompleteCompliancePage extends StatefulWidget {
  final ComplianceBloc bloc;
  const CompleteCompliancePage({super.key, required this.bloc});

  @override
  State<CompleteCompliancePage> createState() => _CompleteCompliancePageState();
}

class _CompleteCompliancePageState extends State<CompleteCompliancePage> {
  @override
  void initState() {
    super.initState();
    widget.bloc
      ..add(const GetMainUsagesEvent())
      ..add(const GetOwnerShipTypesEvent())
      ..add(const GetEngOfficesListEvent())
      ..add(GetLicensesEvent());

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      widget.bloc.pageController.jumpToPage(2);
    });
  }

  double currentStep = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocListener<ComplianceBloc, ComplianceState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure ||
              state.detailsStatus == BlocRequestStatus.failure)
            CommonFunctions.showError(state.errorMessage ?? "");
        },
        child: BlocBuilder<ComplianceBloc, ComplianceState>(
          builder: (context, state) {
            return Scaffold(
                backgroundColor: AppColor.scaffoldBackground,
                appBar: ViolationAppBar(
                  stepCounter: context.read<ComplianceBloc>().pages().length,
                  currentStep: state.currentStep + 1,
                  backOnPress: () => context
                      .read<ComplianceBloc>()
                      .add(GoToPreviousPageEvent()),
                ),
                body: Container(
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        PageView.builder(
                            itemCount:
                                context.read<ComplianceBloc>().pages().length,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            controller:
                                context.read<ComplianceBloc>().pageController,
                            itemBuilder: (context, position) {
                              return AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 300),
                                child: context
                                    .read<ComplianceBloc>()
                                    .pages()[position],
                              );
                            }),
                        if (state.status == BlocStatus.loading ||
                            state.detailsStatus ==
                                BlocRequestStatus.submissionGetLoading)
                          const CustomCircularLoadingWidget(),
                      ],
                    )));
          },
        ),
      ),
    );
  }
}
