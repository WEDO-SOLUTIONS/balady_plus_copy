import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../domain/entities/cemetry_request_details/cemetry_request_details.dart';
import '../widgets/transportation_details_widget/ekram_details_app_bar.dart';

class EkramCemetryDetailsPage extends StatefulWidget {
  const EkramCemetryDetailsPage({Key? key}) : super(key: key);

  @override
  State<EkramCemetryDetailsPage> createState() =>
      _EkramCemetryDetailsPageState();
}

class _EkramCemetryDetailsPageState extends State<EkramCemetryDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.selectAndReserveACemeteryDetails);
  }

  @override
  Widget build(BuildContext context) {
    final CemetryRequestDetails params =
        ModalRoute.of(context)!.settings.arguments as CemetryRequestDetails;

    return Scaffold(
      backgroundColor: AppColor.white2,
      appBar: DetailsHeader(
        titleWidget: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomTextWidget(
              "request".tr(),
              fontSize: 20,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern700Light,
            ),
            const SizedBox(
              width: 16,
            ),
            CustomTextWidget(
              "#${params.requestNumber}",
              fontSize: 14,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: AppFontWeight.medium,
              fontColor: AppColor.blackModern700Light,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        IconPath.calendarIcon,
                        width: 24,
                        height: 24,
                      ),
                      const CustomHorizontalSpace(width: 8),
                      CustomTextWidget(
                        params.requestDate ?? "",
                        fontColor: AppColor.blackModern500Light,
                        fontSize: 12,
                        fontWeight: AppFontWeight.bold,
                      )
                    ],
                  ),
                  HomeTag(
                    title: params.requestStatusName ?? "",
                    backgroundColor: AppColor.secondary100Light,
                  )
                ],
              ),
              ApplicationInfo(
                name: params.submitterName,
                date: params.requestDate,
                mobile: params.submitterMobileNumber,
                //relation: params.rel,
              ),

              DeceasedInfo(
                gender: params.genderName,
                name: params.deceasedName,
                religion: params.religionName,
                nationality: params.nationalityName,
                time: params.burialTime,
                date: params.burialDate,
                hijriDate: params.burialDateHijri,
                cemetryName: params.cemeteryName,
                apologyReason: params.apologyReason,
                deathCityName: params.deathCityName,
                deathCountryName: params.deathCountryName,
                id: params.deceasedIdentityNumber,
                burialCityName: params.burialCityName,
                dobHijri: params.deceasedBirthdateHijri,
                dobGorgian: params.deceasedBirthdate,
                graveTypeName: params.graveTypeName,
                graveSizeName: params.graveSizeName,
                pandemic: params.pandemic,
                deceasedIdentityTypeName: params.deceasedIdentityTypeName,
              ),

              //CemetryInfo(name: params.cemeteryName),

              Constants.verticalSpaceSmall,
            ],
          ),
        ),
      ),
    );
  }
}

class ApplicationInfo extends StatelessWidget {
  final String? date;
  final String? name;
  final String? mobile;
  final String? relation;

  const ApplicationInfo(
      {Key? key, this.date, this.mobile, this.name, this.relation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: Helpers.translatingWord("ApplicantInfo"),
      icon: IconPath.vdSummuryUserInfo,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: Helpers.translatingWord("ekramOrderDate"),
              subTitle: date?.split(" ").firstOrNull,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: Helpers.translatingWord("driver_card_applicant_name"),
              subTitle: name,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: Helpers.translatingWord("driver_card_applicant_mobile"),
              subTitle: mobile,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),

/*CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramRelationShip"),
                subtitle: relation,
              ),*/
          ],
        )
      ],
    );
  }
}

class DeceasedInfo extends StatelessWidget {
  final String? name;
  final String? gender;
  final String? nationality;
  final String? religion;

  final String? city;
  final String? date;
  final String? hijriDate;

  final String? time;
  final String? isEpidamic;
  final String? cemetryName;
  final String? graveTypeName;
  final String? graveSizeName;
  final bool? pandemic;

  final String? apologyReason;
  final String? deathCityName;

  final String? deathCountryName;
  final String? burialCityName;
  final String? dobHijri;
  final String? dobGorgian;

  final String? id;
  final String? deceasedIdentityTypeName;
  const DeceasedInfo(
      {Key? key,
      this.gender,
      this.nationality,
      this.name,
      this.religion,
      this.city,
      this.date,
      this.hijriDate,
      this.time,
      this.isEpidamic,
      this.cemetryName,
      this.apologyReason,
      this.deathCountryName,
      this.deathCityName,
      this.burialCityName,
      this.dobHijri,
      this.dobGorgian,
      this.id,
      this.graveTypeName,
      this.graveSizeName,
      this.pandemic,
      this.deceasedIdentityTypeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: Helpers.translatingWord("deceasedInfo"),
      icon: IconPath.vdSummurySPL,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("cemetry_national_type"),
            subTitle: deceasedIdentityTypeName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("ekram_deceased_id"),
            subTitle: id,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("deceasedName"),
            subTitle: name,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("cemetry_dob_hijri"),
            subTitle: dobHijri,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("cemetry_dob_gorgian"),
            subTitle: dobGorgian,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("ekramGender"),
            subTitle: gender,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("ekramNationality"),
            subTitle: nationality,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("ekramReligion"),
            subTitle: religion,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title:
                Helpers.translatingWord("cemetry_deceassed_burial_date_hijri"),
            subTitle: hijriDate,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),

          FieldData(
            title: Helpers.translatingWord(
                "cemetry_deceassed_burial_date_gorgian"),
            subTitle: date,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),

//
          FieldData(
            title: Helpers.translatingWord("ekram_death_country"),
            subTitle: deathCountryName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),

          FieldData(
            title: Helpers.translatingWord("ekram_death_city"),
            subTitle: deathCityName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),

          FieldData(
            title: Helpers.translatingWord("burial_city"),
            subTitle: burialCityName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),

          FieldData(
            title: Helpers.translatingWord("cemetry_deceassed_burial_time"),
            subTitle: time,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("cemetry_name"),
            subTitle: cemetryName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          if (apologyReason != null) ...[
            FieldData(
              title: Helpers.translatingWord("apology_reason"),
              subTitle: apologyReason,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
          ],
          FieldData(
            title: Helpers.translatingWord("cemetry_type"),
            subTitle: graveTypeName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("cemetry_size"),
            subTitle: graveSizeName,
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: Helpers.translatingWord("cemetry_deceassed_epidamic"),
            subTitle: pandemic! ? 'yes'.tr() : 'no'.tr(),
          ),
        ])
      ],
    );
  }
}
