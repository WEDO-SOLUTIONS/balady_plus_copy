import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../data/models/rating_self_success_result.dart';
import '../widgets/self_rating_result_widgets/self_rataing_result_completed.dart';
import '../widgets/self_rating_result_widgets/self_rataing_result_not_completed.dart';
import '../widgets/self_rating_result_widgets/self_rating_result_app_bar.dart';
import '../widgets/self_rating_result_widgets/self_rating_result_section.dart';
import '../widgets/self_rating_result_widgets/self_rating_result_violation.dart';

class SelfRatingResultPage extends StatefulWidget {
  const SelfRatingResultPage({super.key});

  @override
  State<SelfRatingResultPage> createState() => _SelfRatingResultPageState();
}

class _SelfRatingResultPageState extends State<SelfRatingResultPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.selfRatingSuccess);
    CommonFunctions.sendUXCamEvent(UXCamEvents.finishServicePremisesAssessment);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.PremisesAssessment_Check_Result_Event);
  }

  @override
  Widget build(BuildContext context) {
    RatingSelfSuccessResult result =
        ModalRoute.of(context)!.settings.arguments as RatingSelfSuccessResult;

    return Scaffold(
      appBar: SelfRatingResultAppBar(),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
            child: result.totalViolation == 0
                ? SelfRatingResultCompleted(
                    result: result,
                  )
                : SelfRatingResultNotCompleted(
                    result: result,
                  )),
      ),
    );
  }
}
