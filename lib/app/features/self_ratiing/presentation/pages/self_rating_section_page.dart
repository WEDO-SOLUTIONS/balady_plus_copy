import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_bloc.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_event.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/bloc/self_rating_state.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/first_section_rating.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/second_section_rationg.dart';
import 'package:collection/collection.dart';

import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/self_rating_appbar.dart';
import 'package:balady_plus/app/features/self_ratiing/presentation/widgets/self_rating_sections_widgets/third_section_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/common_functions.dart';
import '../../data/models/rating_self_success_result.dart';

class SelfRatingSectionPage extends StatefulWidget {
  const SelfRatingSectionPage({super.key});

  @override
  State<SelfRatingSectionPage> createState() => _SelfRatingSectionPageState();
}

class _SelfRatingSectionPageState extends State<SelfRatingSectionPage> {
  PageController pageController = PageController(initialPage: 0);
  double currentStep = 1;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelfRatingBloc(),
      child: BlocBuilder<SelfRatingBloc, SelfRatingState>(
        builder: (context, state) {
          return Scaffold(
            appBar: SelfRatingAppBar(
              currentStep: state.currentStep,
              stepCounter: 1,
              backOnPress: () {},
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: FirstSectionRatingWidget(
                onPressed: () {
                  bool valid = state.items?.firstWhereOrNull(
                          (element) => element.compliance == null) ==
                      null;

                  if (valid) {
                    NavigationService.navigatorKey.currentState!
                        .pushReplacementNamed(RouteName.selfRatingResultPage,
                            arguments: RatingSelfSuccessResult(
                                totalViolation: state.totalViolation,
                                percentage: state.percentage,
                                complianes: state.complianes));
                  } else {
                    CommonFunctions.showError(
                        "الرجاء اختيار جميع بنود الإمتثال");
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
