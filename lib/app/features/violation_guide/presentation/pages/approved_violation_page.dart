import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/bloc/violation_bloc.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_details_section_approved.dart';
import 'package:balady_plus/app/features/violation_guide/presentation/widgets/violation_approved_widget/violation_horizantal_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ApprovedViolationPage extends StatelessWidget {
  const ApprovedViolationPage({super.key});

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
            'approved_violation_title'.tr(),
            style: AppStyle.violationCreateAppBarTitle,
          ),
        ),
        body: const SingleChildScrollView(
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
      ),
    );
  }
}
