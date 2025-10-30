import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_details_section_approved.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_horizantal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../data/models/regualation_cluses_details.dart';
import '../bloc/violation_state.dart';

class ApprovedViolationPage extends StatefulWidget {
  const ApprovedViolationPage({super.key});

  @override
  State<ApprovedViolationPage> createState() => _ApprovedViolationPageState();
}

class _ApprovedViolationPageState extends State<ApprovedViolationPage> {
  @override
  Widget build(BuildContext context) {
    ViolationBloc bloc =
        ModalRoute.of(context)!.settings.arguments as ViolationBloc;

    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<ViolationBloc, ViolationState>(
          listener: (context, state) {
        if (state.ViolatorsStatus == BlocStatus.failure ||
            state.classificationStatus == BlocStatus.failure ||
            state.status == BlocStatus.failure)
          CommonFunctions.showError(state.errorMessage ?? "");
      }, builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.scaffoldBackground,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            backgroundColor: AppColor.scaffoldBackground,
            title: Text(
              'approved_violation_title'.tr(),
              style: AppStyle.violationCreateAppBarTitle,
            ),
          ),
          body: Stack(
            children: [
              const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(children: [
                    ViolationApprovedHortizantalList(),
                    SizedBox(
                      height: 24,
                    ),
                    ApprovedViolationDetails(),
                  ]),
                ),
              ),
              if (state.ViolatorsStatus == BlocStatus.loading ||
                  state.establishmentStatus == BlocStatus.loading ||
                  state.status == BlocStatus.loading)
                CustomCircularLoadingWidget()
            ],
          ),
        );
      }),
    );
  }
}
