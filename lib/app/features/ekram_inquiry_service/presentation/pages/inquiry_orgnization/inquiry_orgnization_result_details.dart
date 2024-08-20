import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../vd/presentation/widgets/summery_widgets/field_data.dart';
import '../../../data/models/orgnization_charity_list.dart';

class InquiryOrgnizationResultsDetailsPage extends StatefulWidget {
  const InquiryOrgnizationResultsDetailsPage({super.key});

  @override
  State<InquiryOrgnizationResultsDetailsPage> createState() =>
      _InquiryOrgnizationResultsDetailsPageState();
}

class _InquiryOrgnizationResultsDetailsPageState
    extends State<InquiryOrgnizationResultsDetailsPage> {
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.detailsServiceFuneralServiceInquiry);
  }

  @override
  Widget build(BuildContext context) {
    EkramCharityOrgnizationItem item = ModalRoute.of(context)!
        .settings
        .arguments as EkramCharityOrgnizationItem;
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "details".tr(),
        x: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
          children: [
            OrgnizationDetails(
              item: item,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            /* ContactInfo(
              item: item,
            )*/
          ],
        )),
      ),
    );
  }
}

class OrgnizationDetails extends StatelessWidget {
  final EkramCharityOrgnizationItem item;
  const OrgnizationDetails({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: "ekram_entity_details".tr(),
      icon: IconPath.vdSummuryDesc,
      isExpandedByDefault: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "ekram_city_name".tr(),
              subTitle: item.cityName,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "ekram_orgnization_charity_name".tr(),
              subTitle: item.orgName,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "district".tr(),
              subTitle: item.districtName,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            /* FieldData(
              title: "municipality".tr(),
              subTitle: item.municipalityName,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "sub_municipality".tr(),
              subTitle: item.submunicipalityName,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),*/
            FieldData(
              title: "street".tr(),
              subTitle: item.streetName,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "mobile_no_1".tr(),
              subTitle: item.mobileNo1,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "mobile_no_2".tr(),
              subTitle: item.mobileNo2,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            FieldData(
              title: "email".tr(),
              subTitle: item.email,
            ),
            const CustomVerticalSpace(
              height: 16,
            ),
            InkWell(
                onTap: () {
                  Navigator.of(NavigationService.navigatorKey.currentContext!)
                      .pushNamed(
                    RouteName.inappWebview,
                    arguments: (
                      requestNum: ''.tr(),
                      url: item.locationViewerUrl,
                      isObjections: false
                    ),
                  );
                },
                child: Row(
                  children: [
                    CustomSvgIconWidget(
                      IconPath.location,
                      iconSize: 24,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CustomTextWidget(
                      ("ekram_orgnization_location").tr(),
                      fontSize: 17,
                      fontWeight: AppFontWeight.medium,
                      fontColor: AppColor.black,
                      textAlign: TextAlign.start,
                    ),
                  ],
                )),
          ],
        )
      ],
    );
  }
}

class ContactInfo extends StatelessWidget {
  final EkramCharityOrgnizationItem item;
  const ContactInfo({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      title: "personal_contact_info".tr(),
      icon: IconPath.vdSummuryDesc,
      isExpandedByDefault: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomVerticalSpace(
              height: 16,
            ),
          ],
        )
      ],
    );
  }
}
