import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import '../../../../data/model/request_details_response_model/main_info.dart';
import '../../ekram_status_widget.dart';

class ApplicantInfoWidget extends StatelessWidget {
  final MainInfo? item;
   ApplicantInfoWidget({Key? key,this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return
      Container(
        width: MediaQuery.of(context).size.width - 30,
        decoration: new BoxDecoration(
            color: AppColor.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomVerticalSpace(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomTextWidget(
              "ekram_order_info".tr(),
              fontSize: 20.0,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern700Light,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('ekramApplicantType').tr(),
            details: item?.submitterTypeName??"",
          ),

          //
          // EkramHeaderAndDescWidget_With_Background(
          //   title: ('requestSource').tr(),
          //   details: item?.submitterInfo?.ekramDepartment == true?"":"",
          // ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('submitterName').tr(),
            details: item?.submitterInfo?.fullName??"",
          ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('driver_card_applicant_mobile').tr(),
            details: item?.submitterInfo?.mobileNumber??"",
          ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('ekramRelationShip').tr(),
            details: item?.submitterInfo?.relationship??"-",
          ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('transportationStatus').tr(),
            details: item?.transportCaseName??"",
          )

        ],
            ),
      );




  }
}
