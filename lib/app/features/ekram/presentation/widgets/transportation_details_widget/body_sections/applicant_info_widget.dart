import 'package:balady_new_app/app/core/core_exports.dart'
    show
        Constants,
        CustomEnhancedExpansionPanelWidget,
        CustomTitleSubtitleCardWidget,
        Helpers;
import 'package:balady_new_app/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicantInfoWidget extends StatelessWidget {
  const ApplicantInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
      builder: (context, state) {
        return CustomEnhancedExpansionPanelWidget(
          underline: false,
          title: Helpers.translatingWord("ApplicantInfo"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
