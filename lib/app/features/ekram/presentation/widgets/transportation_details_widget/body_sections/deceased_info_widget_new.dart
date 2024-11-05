import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_enhanced_expansion_panel_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../data/model/request_details_response_model/deceased_info.dart';

class DeceasedInfoWidget_new extends StatelessWidget {
  final DeceasedInfo? item;
  const DeceasedInfoWidget_new({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomVerticalSpace(height: 10),
        CustomTextWidget(
          "deceasedData".tr(),
          fontSize: 20.0,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern700Light,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),

        Container(
          width: MediaQuery.of(context).size.width - 60,
          decoration: new BoxDecoration(
              color: AppColor.white, borderRadius: BorderRadius.circular(16)),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 15,),
              EkramHeaderAndDescWidget_new(
                  title: ('avaliableNationID').tr(),
                  details: item?.hasIdentity == true ? "Yes".tr():"No".tr(),
              ),

              Row(
                children: [
                  EkramHeaderAndDescWidget_new(
                    title: ('user_data_applicant_type').tr(),
                    details: item?.identityTypeName??"",
                  ),
                  EkramHeaderAndDescWidget_new(
                    title: ('lbl_ID_hint1').tr(),
                    details: item?.identityNumber?? "",
                  ),
                ],
              ),

                  Row(
                    children: [
                      EkramHeaderAndDescWidget_new(
                        title: ('cemetry_dob_gorgian').tr(),
                        details: item?.birthDate??"",
                      ),
                      EkramHeaderAndDescWidget_new(
                        title: ('cemetry_dob_hijri').tr(),
                        details: item?.birthDate??"",
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      EkramHeaderAndDescWidget_new(
                        title: ('ekram_first_name').tr(),
                        details: item?.firstName??"",
                      ),
                      EkramHeaderAndDescWidget_new(
                        title: ('ekram_second_name').tr(),
                        details: item?.secondName??"",
                      ),
                      EkramHeaderAndDescWidget_new(
                        title: ('ekram_third_name').tr(),
                        details: item?.thirdName??"",
                      ),
                      EkramHeaderAndDescWidget_new(
                        title: ('ekram_fourth_name').tr(),
                        details: item?.fourthName??"",
                      ),
                    ],
                  ),


              EkramHeaderAndDescWidget_new(
                title: ('personal_nationality').tr(),
                details: item?.nationalityName??"",
              ),
              EkramHeaderAndDescWidget_new(
                title: ('personal_gender').tr(),
                details: item?.gender ??"",
              ),
              EkramHeaderAndDescWidget_new(
                title: ('ekramReligion').tr(),
                details: item?.isMuslim == true ? "muslim".tr():"non_muslim".tr(),
              ),

            ],
          ),
        )
        
      ],
    );;
  }
}
