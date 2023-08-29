import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_approved_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_number_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_result_title_section.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violation_results_selection_widget.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_results_widgets/violations_not_approved_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ViolationResultsPage extends StatelessWidget {
  const ViolationResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViolationBloc(),
      child: Scaffold(
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
            'result-1'.tr(),
            style: AppStyle.violationCreateAppBarTitle,
          ),
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ViolationNumberResultWidget(),
              SizedBox(
                height: 16,
              ),
              ViolationResultsSelectionListWidget(),
              SizedBox(
                height: 24,
              ),
              ViolationResultsSectionTitle(),
              SizedBox(
                height: 14,
              ),
              ViolationApprovedWidget(),
              SizedBox(
                height: 5,
              ),
              ViolationsNotApprovedWidget(),
            ]),
          ),
        ),
      ),
    );
  }
}
