import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../domain/entities/cemetry_request_details/cemetry_request_details.dart';
import '../widgets/transportation_details_widget/ekram_details_app_bar.dart';

class EkramCemetryDetailsPage extends StatefulWidget {
  final CemetryRequestDetails params;
  const EkramCemetryDetailsPage({Key? key, required this.params})
      : super(key: key);

  @override
  State<EkramCemetryDetailsPage> createState() =>
      _EkramCemetryDetailsPageState();
}

class _EkramCemetryDetailsPageState extends State<EkramCemetryDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white2,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // header
          EkramDetailsAppBar(
            title: Helpers.translatingWord("cemetry_booking_request"),
            status: widget.params.requestStatusName ?? "",
            orderNo: widget.params.requestNumber.toString(),
          ),
          // body
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Constants.verticalSpaceSmall,
                // TransferInfo
                ApplicationInfo(
                  name: widget.params.submitterName,
                  date: widget.params.requestDate,
                  mobile: widget.params.submitterMobileNumber,
                  //relation: widget.params.rel,
                ),

                DeceasedInfo(
                    gender: widget.params.genderName,
                    name: widget.params.deceasedName,
                    religion: widget.params.religionName,
                    nationality: widget.params.nationalityName),

                BurialInfo(
                  time: widget.params.burialTime,
                  date: widget.params.burialDate,
                  cemetryName: widget.params.cemeteryName,
                  apologyReason: widget.params.apologyReason,
                ),

                //CemetryInfo(name: widget.params.cemeteryName),

                Constants.verticalSpaceSmall,
              ],
            ),
          )
        ],
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
    return CustomEnhancedExpansionPanelWidget(
      underline: false,
      title: Helpers.translatingWord("ApplicantInfo"),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadOnlyField(
              title: Helpers.translatingWord("ekramOrderDate"),
              subTitle: date?.split(" ").firstOrNull,
            ),
            ReadOnlyField(
              title: Helpers.translatingWord("ekramFullName"),
              subTitle: name,
            ),
            ReadOnlyField(
              title: Helpers.translatingWord("ekramMobile"),
              subTitle: mobile,
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
    return CustomEnhancedExpansionPanelWidget(
      underline: false,
      title: Helpers.translatingWord("deceasedInfo"),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadOnlyField(
              title: Helpers.translatingWord("deceasedName"),
              subTitle: name,
            ),
            ReadOnlyField(
              title: Helpers.translatingWord("ekramGender"),
              subTitle: gender,
            ),
            ReadOnlyField(
              title: Helpers.translatingWord("ekramNationality"),
              subTitle: nationality,
            ),
            ReadOnlyField(
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
    return CustomEnhancedExpansionPanelWidget(
      underline: false,
      title: Helpers.translatingWord("burialInfo"),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadOnlyField(
              title: Helpers.translatingWord("burialDate"),
              subTitle: date,
            ),
            ReadOnlyField(
              title: Helpers.translatingWord("burialTime"),
              subTitle: time,
            ),
            ReadOnlyField(
              title: Helpers.translatingWord("cemetry_name"),
              subTitle: cemetryName,
            ),
            if (apologyReason != null)
              ReadOnlyField(
                title: Helpers.translatingWord("apology_reason"),
                subTitle: apologyReason,
              ),

            /* CustomTitleSubtitleCardWidget(
                horizontalPadding: Constants.smallPadding,
                title: Helpers.translatingWord("ekramNationality"),
                subtitle: nationality,
              ),
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
