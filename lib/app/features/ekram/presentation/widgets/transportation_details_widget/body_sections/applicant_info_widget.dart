import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/request_details_bloc/request_details_bloc_bloc.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';

class ApplicantInfoWidget extends StatelessWidget {
  const ApplicantInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailsBloc, RequestDetailsState>(
        builder: (context, state) {
      return ExpandableCard(
        title: Helpers.translatingWord("ekram_order_info"),
        icon: IconPath.vdSummuryDesc,
        children: [
          //MM Ekram

          FieldData(
            title: Helpers.translatingWord("submitterName"),
            subTitle: state.details.submitterName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("ekramApplicantType"),
            subTitle: state.details.submitterTypeName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),

          GestureDetector(
            onTap: () {
              //if (state.details.submitterMobileNumber != null)
              //  CommonFunctions.call(state.details.submitterMobileNumber);
            },
            child: FieldData(
              title: Helpers.translatingWord("driver_card_applicant_mobile"),
              subTitle: state.details.submitterMobileNumber,
            ),
          ),
          const CustomVerticalSpace(
            height: 16,
          ),

          FieldData(
            title: Helpers.translatingWord("ekramRelationShip"),
            subTitle: state.details.relationship,
          ),

          const CustomVerticalSpace(
            height: 16,
          ),

          FieldData(
            title: Helpers.translatingWord("burialCity"),
            subTitle: state.details.deathCityName,
          ),

          const CustomVerticalSpace(
            height: 16,
          ),

          FieldData(
            title: Helpers.translatingWord("transportationStatus"),
            subTitle: state.details.deathTransferStatusDesc,
          ),
        ],
      );
    });
  }
}
