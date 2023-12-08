import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:timelines/timelines.dart';

import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_text_widget.dart';
import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/header_with_view_all_widget.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../data/models/request_details_response.dart';

class RequestStatusCard extends StatefulWidget {
  final AuditInformation auditInformation;
  final String municipalityName;
  final String status;
  final RequestsType type;

  const RequestStatusCard({
    Key? key,
    required this.auditInformation,
    required this.municipalityName,
    required this.type,
    required this.status,
  }) : super(key: key);

  @override
  _RequestStatusCardState createState() => _RequestStatusCardState();
}

class _RequestStatusCardState extends State<RequestStatusCard> {
  bool showInfo = true;
  bool showImages = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
                color: Color(0x26000000),
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 0)
          ],
          color: Colors.white),
      // padding: const EdgeInsets.all(18),
      padding: const EdgeInsets.only(top: 18, right: 18, left: 18),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  ('order_status').tr(),
                  fontColor: AppColor.blackModern900Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 20,
                ),
                HomeTag(
                  title: widget.status,
                  backgroundColor: AppColor.secondary100Light,
                ),
              ],
            ),
            CustomVerticalSpace(height: 12),

            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount:
                  !showInfo ? 1 : widget.auditInformation.auditList!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                String desc = widget.auditInformation.auditList![index].getDesc(
                    widget.municipalityName,
                    incidentType: widget.type);
                return TimelineTile(
                  nodeAlign: TimelineNodeAlign.start,
                  contents: Container(
                    margin: const EdgeInsetsDirectional.only(
                        start: 16,
                        top: /*desc != null &&
                        widget.auditInformation.auditList[index]
                            .getDesc(widget.municipalityName)
                            .isNotEmpty
                        ?*/
                            20 /*: 5*/),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              widget.auditInformation.auditList![index]
                                  .getTypeTitle(incidentType: widget.type),
                              fontColor: Color(0xFF292929),
                              fontWeight: AppFontWeight.bold,
                              fontSize: 14,
                              textAlign: TextAlign.start,
                            ),
                            const CustomVerticalSpace(height: 10),
                            /*     desc != null &&
                                    widget.auditInformation.auditList[index]
                                        .getDesc(widget.municipalityName)
                                        .isNotEmpty
                                ?*/
                            CustomTextWidget(
                              /*widget.auditInformation.auditList[index].getTypeTitle()*/
                              desc,
                              fontColor: AppColor.blackModern500Light,
                              fontSize: 11,
                              fontWeight: AppFontWeight.bold,
                              textAlign: TextAlign.start,
                            ),
                            const CustomVerticalSpace(height: 20),
                          ],
                        ),
                        CustomTextWidget(
                          widget.auditInformation.auditList?[index]
                                  .getDate(incidentType: widget.type) ??
                              " ",
                          fontColor: AppColor.primary600Light,
                          fontWeight: AppFontWeight.bold,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                  node: TimelineNode(
                    indicator: const DotIndicator(
                      color: AppColor.primary900Light,
                      size: 10,
                    ),
                    startConnector:
                        index == 0 && !widget.auditInformation.isResolved()
                            ? const SolidLineConnector(
                                color: AppColor.primary50Light,
                              )
                            : index == 0 && widget.auditInformation.isResolved()
                                ? const SolidLineConnector(
                                    color: Colors.transparent)
                                : const SolidLineConnector(
                                    color: AppColor.primary50Light,
                                  ),
                    endConnector: index ==
                            widget.auditInformation.auditList!.length - 1
                        ? const SolidLineConnector(color: Colors.transparent)
                        : const SolidLineConnector(
                            color: AppColor.primary50Light,
                          ),
                  ),
                );
              },
            ),
            //    if (showMoreDetails()) showMoreButton(),
          ],
        ),
      ),
    );
  }

  bool showMoreDetails() {
    if (widget.auditInformation != null &&
        widget.auditInformation.auditList!.isNotEmpty) {
      if (widget.auditInformation.auditList!.length > 1) {
        return true;
      }
      return false;
    }

    return false;
  }
/*
  Widget showMoreButton() {
    return Column(
      children: [
        const CustomVerticalSpace(height: 16),
        const DrawLineWidget(),
        CustomTextButtonWithIconWidget(
          btnPressed: () {
            setState(() {
              showInfo = !showInfo;
            });
          },
          btnText: !showInfo
              ? Helpers.translatingWord("show_info")
              : Helpers.translatingWord("hide_info"),
          btnTextSize: 16,
          btnTextWeight: FONT_WEIGHT.medium,
          btnTextColor: const Color(0xff757575),
          icon: Image.asset(
            !showInfo
                ? Constants.imgPath + 'arrowDown@3x.png'
                : Constants.imgPath + 'arrowUpShow@3x.png',
            height: 16,
            width: 16,
          ),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          padding:
              const EdgeInsets.symmetric(vertical: Constants.mediumPadding),
        ),
      ],
    );
  }

*/
}
