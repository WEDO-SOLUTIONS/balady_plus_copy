import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
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
                      CustomHorizontalSpace(width: 8),
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
                  nationality: params.nationalityName),

              BurialInfo(
                time: params.burialTime,
                date: params.burialDate,
                cemetryName: params.cemeteryName,
                apologyReason: params.apologyReason,
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
              title: Helpers.translatingWord("ekramFullName"),
              subTitle: name,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: Helpers.translatingWord("ekramMobile"),
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

  const DeceasedInfo(
      {Key? key, this.gender, this.nationality, this.name, this.religion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: Helpers.translatingWord("deceasedInfo"),
      icon: IconPath.vdSummurySPL,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        )
      ],
    );
  }
}

class BurialInfo extends StatelessWidget {
  final String? city;
  final String? date;
  final String? time;
  final String? isEpidamic;
  final String? cemetryName;
  final String? apologyReason;

  const BurialInfo(
      {Key? key,
      this.city,
      this.date,
      this.time,
      this.isEpidamic,
      this.cemetryName,
      this.apologyReason})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: Helpers.translatingWord("burialInfo"),
      icon: IconPath.vdSummuryDesc,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: Helpers.translatingWord("burialDate"),
              subTitle: date,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: Helpers.translatingWord("burialTime"),
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
          ],
        )
      ],
    );
  }
}

class CemetryInfo extends StatelessWidget {
  final String? type;
  final String? size;
  final String? name;

  const CemetryInfo({Key? key, this.type, this.size, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomEnhancedExpansionPanelWidget(
      underline: false,
      title: Helpers.translatingWord("cemetry_info"),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadOnlyField(
              title: Helpers.translatingWord("cemetry_type"),
              subTitle: type,
            ),
            /* CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("cemetry_size"),
                subtitle: size,
              ),
            CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("cemetry_name"),
                subtitle: name,
              ),*/ /*
CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramReligion"),
                subtitle: religion,
              ), */
          ],
        )
      ],
    );
  }
}
