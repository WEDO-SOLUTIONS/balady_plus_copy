import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../data/model/request_details_response_model/burial_info.dart';
import '../../../../data/model/request_details_response_model/cemetery_data.dart';
import '../../../../data/model/request_details_response_model/death_info.dart';
import '../../../../data/model/request_details_response_model/transport_info.dart';
import '../../ekram_status_widget.dart';

class BurialInfoWidget extends StatelessWidget {
  DeathInfo? deathInfo;
  BurialInfo? burialInfo;
  CemeteryData? cemeteryData;
  TransportInfo? transportInfo;
  BurialInfoWidget(
      {Key? key,
      this.deathInfo,
      this.burialInfo,
      this.cemeteryData,
      this.transportInfo})
      : super(key: key);

  String getBurialDestinationName(String? burialDestination) {
    switch (burialDestination) {
      case 'DEATH_CITY':
        return ('BurialInDeathCity'.tr());
      case 'CORPSE_ARRIVAL_CITY':
        return ('BurialInCorpseArrivalCity'.tr());
      case 'OTHER_CITY':
        return ('BurialInOtherCity'.tr());
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
          color: AppColor.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomVerticalSpace(height: 10),
          Padding(
            padding: const EdgeInsets.all(
              10,
            ),
            child: CustomTextWidget(
              "deathInfo".tr(),
              fontSize: 20.0,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern700Light,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('death_date_gorgian').tr(),
            details: deathInfo?.gregorianDeathDate ?? "",
          ),

          // EkramHeaderAndDescWidget_With_Background(
          //   title: ('raflyAge').tr(),
          //   details: deathInfo?.age?.year != null
          //       ? "${deathInfo?.age?.year} ${"ageYear".tr()}"
          //       : "",
          // ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('ekram_death_country').tr(),
            details: deathInfo?.countryName ?? "",
          ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('ekram_death_city').tr(),
            details: deathInfo?.cityName ?? "",
          ),
          EkramHeaderAndDescWidget_With_Background(
            title: ('ekramHospital').tr(),
            details: deathInfo?.hospitalName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('burialDestination').tr(),
            details: getBurialDestinationName(burialInfo?.burialDestination),
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('burial_city').tr(),
            details: burialInfo?.cityName ?? "",
          ),

          Container(
            decoration: BoxDecoration(
                color: AppColor.greenOptacty.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: EkramHeaderAndDescWidget_With_Background(
                      title: ('cemetry_deceassed_burial_date_gorgian').tr(),
                      details: burialInfo?.gregorianBurialDate ?? "",
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(0)),
                ),
                Expanded(
                  child: EkramHeaderAndDescWidget_With_Background(
                      title: ('cemetry_deceassed_burial_date_hijri').tr(),
                      details: burialInfo?.burialDate ?? "",
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(0)),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('cemetry_deceassed_burial_time').tr(),
            details: burialInfo?.prayName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('is_deaceased_requrie_special_transfer').tr(),
            details: transportInfo?.needSpecialTransport == true
                ? "Yes".tr()
                : "No".tr(),
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('cemetry_type').tr(),
            details: cemeteryData?.graveTypeName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('cemetry_size').tr(),
            details: cemeteryData?.graveSizeName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('cemeteryName').tr(),
            details: cemeteryData?.cemeteryName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('transportation_orgnization').tr(),
            details: transportInfo?.charityName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('driver_name').tr(),
            details: transportInfo?.driverName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('driverMobile').tr(),
            details: transportInfo?.driverMobile ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('carModel').tr(),
            details: transportInfo?.vehicleName ?? "",
          ),

          // EkramHeaderAndDescWidget_With_Background(
          //   title: ('vichleAssignDate').tr(),
          //   details: cemeteryData?.graveSizeName??"",
          // ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('driverAssignDate').tr(),
            details: transportInfo?.assignDriverDate ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('ekram_laundry').tr(),
            details: transportInfo?.ghuslPlaceName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('the_mosque').tr(),
            details: transportInfo?.mosqueName ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('ekram_permit_no').tr(),
            details: burialInfo?.permitNumber ?? "",
          ),

          EkramHeaderAndDescWidget_With_Background(
            title: ('ekram_baquie_approval_status').tr(),
            details: burialInfo?.approvalStatusName ?? "-",
          ),

          Container(
            decoration: BoxDecoration(
                color: AppColor.greenOptacty.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                Expanded(
                  child: EkramHeaderAndDescWidget_With_Background(
                      title: ('baquie_approval_date').tr(),
                      details: burialInfo?.approvalDate != null &&
                              CommonFunctions.hijriToGregorian(
                                      burialInfo?.approvalDate) !=
                                  null
                          ? CommonFunctions.hijriToGregorian(
                              burialInfo?.approvalDate)!
                          : "-",
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(0)),
                ),
                Expanded(
                  child: EkramHeaderAndDescWidget_With_Background(
                      title: ('hrjii_baquie_approval_date').tr(),
                      details: burialInfo?.approvalDate ?? "",
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(0)),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
