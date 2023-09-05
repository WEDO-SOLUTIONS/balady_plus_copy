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
                    title: ('بيانات الموقع').tr(),
                    leading: SvgPicture.asset(IconPath.vdSummuryPhoto),
                    children: [
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "الأمانة".tr(),
                          subTitle: state.gisResponse?.amanaName ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "البلدية".tr(),
                          subTitle: state.gisResponse?.municipalityName ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "المدينة".tr(),
                          subTitle: state.gisResponse?.city ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "الحي".tr(),
                          subTitle: state.gisResponse?.districtName ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "رقم المخطط".tr(),
                          subTitle: state.gisResponse?.planNo ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "اسم المخطط".tr(),
                          subTitle: state.gisResponse?.planName ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "اسم الشارع".tr(),
                          subTitle: state.gisResponse?.streetName ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "اسم الشارع".tr(),
                          subTitle: state.gisResponse?.streetName ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "رقم قطعة الأرض".tr(),
                          subTitle: state.gisResponse?.parcelNo ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "مساحة الارض".tr(),
                          subTitle: state.gisResponse?.area ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "الاحداثي السيني".tr(),
                          subTitle: state.gisParams?.x.toString() ?? ""),
                      CustomVerticalSpace(height: 16),
                      FieldData(
                          title: "الاحداثي الصادي".tr(),
                          subTitle: state.gisParams?.y.toString() ?? ""),
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
          text: ("عنوان الطلب").tr(),
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
