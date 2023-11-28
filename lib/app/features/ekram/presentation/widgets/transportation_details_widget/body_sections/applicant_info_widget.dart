
import 'package:balady_plus/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';

class ApplicantInfoWidget extends StatelessWidget {
  const ApplicantInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        return CustomEnhancedExpansionPanelWidget(
          underline: false,
          title: Helpers.translatingWord("ApplicantInfo"),
          children: 
       [
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramFullName"),
                subtitle: state.details.submitterName,
              ),
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramApplicantType"),
                subtitle: state.details.submitterTypeName,
              ),
              GestureDetector(
                onTap: () {
                  if (state.details.submitterMobileNumber != null)
                    CommonFunctions.call(state.details.submitterMobileNumber);
                },
                child: CustomTitleSubtitleCardWidget(
                  horizontalPadding: Constants.smallPadding,
                  title: Helpers.translatingWord("ekramMobile"),
                  subtitle: state.details.submitterMobileNumber,
                ),
              ),
              CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramRelationShip"),
                subtitle: state.details.relationship,
              ),
            ],
          ),
        );
      },
    );
  }
}
