import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/components/texts/label_icon_subtitle_component.dart';
import '../../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../bloc/compliance_bloc.dart';
import '../../bloc/compliance_state.dart';

class LocationSummuryWidget extends StatelessWidget {
  const LocationSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return state.requestDetails?.locationResponseInfoDto?.municipalityId !=
                null
            ? Column(
                children: [
                  CustomExpansionPanelWidget(
                    title: ('location_data').tr(),
                    leading: SvgPicture.asset(IconPath.vdSummuryPhoto),
                    children: [
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "municipality".tr(),
                          subTitle: state.requestDetails
                                  ?.locationResponseInfoDto?.municipalityName ??
                              ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "sub_municipality".tr(),
                          subTitle: state
                                  .requestDetails
                                  ?.locationResponseInfoDto
                                  ?.subMunicipalityName ??
                              ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "city".tr(),
                          subTitle: state.requestDetails
                                  ?.locationResponseInfoDto?.cityName ??
                              ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "district".tr(),
                          subTitle: state.requestDetails
                                  ?.locationResponseInfoDto?.districtName ??
                              ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "planNumber".tr(),
                          subTitle: state.requestDetails
                                  ?.locationResponseInfoDto?.mapNumber ??
                              ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "plan_name".tr(),
                          subTitle: state.requestDetails
                                  ?.locationResponseInfoDto?.mapName ??
                              ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "street_name".tr(),
                          subTitle: state.requestDetails
                                  ?.locationResponseInfoDto?.streetName ??
                              ""),
                      CustomVerticalSpace(height: 16),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state
                                  .requestDetails
                                  ?.locationResponseInfoDto
                                  ?.landsInfo
                                  ?.landsInfo
                                  ?.length ??
                              0,
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                FieldData(
                                    title: "parcel_number".tr(),
                                    subTitle: state
                                            .requestDetails
                                            ?.locationResponseInfoDto
                                            ?.landsInfo
                                            ?.landsInfo?[index]
                                            .landNumber ??
                                        ""),
                                const CustomVerticalSpace(height: 16),
                                FieldData(
                                    title: "land_area".tr(),
                                    subTitle: state
                                            .requestDetails
                                            ?.locationResponseInfoDto
                                            ?.landsInfo
                                            ?.landsInfo?[index]
                                            .landArea ??
                                        ""),
                                const CustomVerticalSpace(height: 16),
                              ],
                            );
                          }),
                      CustomVerticalSpace(height: 16),
                      /* FieldData(
                          title: "الاحداثي السيني".tr(),
                          subTitle: state.gisParams?.x.toString() ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "الاحداثي الصادي".tr(),
                          subTitle: state.gisParams?.y.toString() ?? ""),*/
                    ],
                  ),
                  CustomVerticalSpace(
                    height: 16,
                  ),
                ],
              )
            : Container();
      },
    );
  }
}

class LocationSection extends StatelessWidget {
  bool? hideAutomaticLocationdetected;
  bool showOnly;
  LocationSection({this.hideAutomaticLocationdetected, this.showOnly = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return LabelIconSubtitleComponent(
          text: ("order_address").tr(),
          subWidget: GestureDetector(
            onTap: () {},
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CustomSvgIconWidget(
                          IconPath.qrLocationIcon,
                        ),
                        CustomHorizontalSpace(width: 8),
                        Flexible(
                          child: CustomTextWidget(
                            state.gisResponse?.getFullAddress() ??
                                ("lbl_locate_report_from_here").tr(),
                            fontColor: AppColor.blackModern500Light,
                            fontSize: 14,
                            textAlign: TextAlign.start,
                            height: 1.3,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        );
      },
    );
  }
}
