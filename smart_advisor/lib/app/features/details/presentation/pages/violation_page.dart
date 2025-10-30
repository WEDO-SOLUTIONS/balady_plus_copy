import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_event.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

import '../../../select_activity/domain/entities/activity_details_page_params.dart';
import '../widgets/tabs/third/violations_view.dart';

class ViolationPage extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const ViolationPage({super.key, required this.args});

  @override
  State<ViolationPage> createState() => _ViolationPageState();
}

class _ViolationPageState extends State<ViolationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsBloc(args: widget.args)
        ..add(GetViolationsListEvent())
        ..add(GetViolationVD()),
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(
                  image: AssetImage(
                      'packages/smart_advisor/smart_advisor_assets/images/backshadow.png'), // Correct way to reference the asset image
                  fit: BoxFit.cover, // Adjust the fit of the image if needed
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Column(
              children: [
                NewAppBar(title: "قوائم التفحص"),
                ViolationsView(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
