import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../municipal_advisor_exports.dart';

class SelectedAdditionalActivities extends StatelessWidget {
  const SelectedAdditionalActivities({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '3. ${"municipalAdvisorActivitiesTitle".tr()}\n',
                style: AppStyle.lightTitleTextStyle.copyWith(fontSize: 12),
              ),
              for (final activity in state.selectedAdditionalActivities) ...[
                TextSpan(
                  text: '${"municipalAdvisorMainActivity".tr()}:\n',
                  style: AppStyle.lightTitleTextStyle,
                ),
                TextSpan(
                  text: '${activity.masterActivityName}\n',
                  style: AppStyle.lightTextStyle,
                ),
                TextSpan(
                  text: '${"municipalAdvisorIsicCode".tr()}:\n',
                  style: AppStyle.lightTitleTextStyle,
                ),
                TextSpan(
                  text: '${activity.isicNumber}\n',
                  style: AppStyle.lightTextStyle,
                ),
                if (activity.homogeneous != null) ...[
                  TextSpan(
                    text: '${"municipalAdvisorHomogeneityStatus".tr()}:\n',
                    style: AppStyle.lightTitleTextStyle,
                  ),
                  TextSpan(
                    text:
                        '${activity.homogeneous! ? "municipalAdvisorHomogeneous".tr() : "municipalAdvisorNonHomogeneous".tr()}\n',
                    style: AppStyle.lightTextStyle,
                  ),
                ],
              ],
              if (state.selectedAdditionalActivities.isEmpty)
                TextSpan(
                  text: '${"noData".tr()}\n',
                  style: AppStyle.lightTextStyle,
                ),
            ],
          ),
        );
      },
    );
  }
}
