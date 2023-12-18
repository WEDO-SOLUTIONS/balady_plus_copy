import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/date_form.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/map_page/data/model/excavations.dart';
import 'package:balady_plus/app/features/map_page/presentation/widgets/map_details_header.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/investment_details_response.dart';
import '../mvvm/point_view_model.dart';
import '../widgets/map_details_field.dart';
import '../widgets/map_details_section.dart';
import '../widgets/map_details_sub_header.dart';

class InvestmentMapDetailsPage extends StatefulWidget {
  const InvestmentMapDetailsPage({
    super.key,
  });

  @override
  State<InvestmentMapDetailsPage> createState() =>
      _InvestmentMapDetailsPageState();
}

class _InvestmentMapDetailsPageState extends State<InvestmentMapDetailsPage> {
  @override
  Widget build(BuildContext context) {
    InvestmentDetailsResponse item =
        ModalRoute.of(context)!.settings.arguments as InvestmentDetailsResponse;
    return Scaffold(
        body: Stack(
      children: [
        MapDetailsHeader(
          name: "",
          address: "",
          type: "",
          image: "assets/images/invetment_map_card.png",
        ),
        Container(
          margin: const EdgeInsets.only(top: 190),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: ShapeDecoration(
            color: AppColor.primary50Light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            // image: DecorationImage(image: AssetImage())
          ),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(
                  top: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: CustomTextWidget(
                            item.data?.result?.opportunityDescription ?? "",
                            fontColor: AppColor.blackModern800Light,
                            fontWeight: AppFontWeight.bold,
                            textAlign: TextAlign.start,
                            fontSize: 18,
                            maxLines: 7,
                          ),
                        ),
                      ],
                    ),
                    CustomVerticalSpace(height: 16),
                    CustomTextWidget(
                      item.data?.result?.subMunicipality ?? "",
                      fontColor: AppColor.blackModern500Light,
                      fontWeight: AppFontWeight.semiBold,
                      textAlign: TextAlign.start,
                      fontSize: 14,
                    )
                  ],
                ),
              ),
              MapDetailsSubHeader(
                firstTitle: "سعر الكراسة".tr(),
                firstSubTitle:
                    item.data?.result?.documentValue.toString() ?? "",
                secondTitle: "مساحة الموقع",
                secondSubTitle:
                    "${item.data?.result?.getTotalSiteArea()} م٢" ?? "",
              ),
              CustomVerticalSpace(height: 16),
              Container(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
                child: Column(
                  children: [
                    MapDetailsSection(
                      title: "investment_space".tr(),
                      icon: IconPath.investmentIcon,
                    ),
                    MapDetailsField(
                      title: "investment_number".tr(),
                      subTitle: item.data?.result?.opportunityNumber ?? "",
                    ),
                    MapDetailsField(
                      title: "investement_type".tr(),
                      subTitle: item.data?.result?.mainActivity ?? "",
                    ),
                    MapDetailsField(
                      title: "investment_price".tr(),
                      subTitle:
                          item.data?.result?.documentValue.toString() ?? "",
                    ),
                    MapDetailsField(
                      title: "investemnt_duration".tr(),
                      subTitle: item.data?.result
                              ?.getContractDurationYearsAndMonth() ??
                          "",
                    ),
                  ],
                ),
              ),
              CustomVerticalSpace(height: 16),
              Container(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
                child: Column(
                  children: [
                    MapDetailsSection(
                      title: "investemnt_state".tr(),
                      icon: IconPath.investmentIcon,
                    ),
                    MapDetailsField(
                      title: "investment_delivery".tr(),
                      subTitle:
                          item.data?.result?.submittingEnvelopesLocation ?? "",
                    ),
                    MapDetailsField(
                      title: "investement_open".tr(),
                      subTitle:
                          item.data?.result?.envelopeOpeningLocation ?? "",
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    ));
  }
}
