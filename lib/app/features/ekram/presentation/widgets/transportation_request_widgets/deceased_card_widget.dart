import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';

class DeceasedCardWidget extends StatelessWidget {
  final DeceasedInfoDto deceasedItem;
  final Function onDelete;
  final Function onEdit;
  final bool showDelete;

  const DeceasedCardWidget(
      {Key? key,
      required this.deceasedItem,
      required this.onDelete,
      required this.onEdit,
      this.showDelete = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 340,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Color(0x19000000),
                offset: Offset(0, 2),
                blurRadius: 10,
                spreadRadius: 0)
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /* IconButton(
                  iconSize: 18,
                  splashRadius: 1,
                  onPressed: () => onEdit(),
                  icon: CustomSvgIconWidget(
                    "assets/icons/svg/ekram_edit.svg",
                    iconHeight: 18,
                    iconWidth: 18,
                  ),
                ),*/
                if (showDelete)
                  IconButton(
                    iconSize: 18,
                    splashRadius: 1,
                    onPressed: () => onDelete(),
                    icon: CustomSvgIconWidget(
                      "assets/icons/svg/ekram_delete.svg",
                      iconHeight: 18,
                      iconWidth: 18,
                    ),
                  ),
                if (!showDelete)
                  const SizedBox(
                    height: 18,
                  )
              ],
            ),
            Container(
              padding: EdgeInsetsDirectional.only(start: 24, end: 11),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('name'),
                        details: deceasedItem.firstName ?? "",
                      )),
                      CustomHorizontalSpace(width: 12),
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('ekramReligion'),
                        details: deceasedItem.isMuslim == false
                            ? "non_muslim".tr()
                            : deceasedItem.isMuslim == true
                                ? "muslim".tr()
                                : "",
                      ))
                    ],
                  ),
                  const CustomVerticalSpace(height: 24),
                  Row(
                    children: [
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('ekramNationality'),
                        details: deceasedItem.nationalityId?.name ?? "",
                      )),
                      CustomHorizontalSpace(width: 12),
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('ekramGender'),
                        details: deceasedItem.gender == 1
                            ? "male".tr()
                            : "female".tr(),
                      ))
                    ],
                  ),
                  const CustomVerticalSpace(height: 24),
                  Row(
                    children: [
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('burialDestination'),
                        details: deceasedItem.multipleCityRequest == false
                            ? "burial_in_death_city".tr()
                            : "burial_in_other_city".tr(),
                      )),
                      CustomHorizontalSpace(width: 12),
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('burialCity'),
                        details: deceasedItem.multipleCityRequest == false
                            ? deceasedItem.deathCity?.name ?? ""
                            : deceasedItem.burialCityId?.name ?? "",
                      ))
                    ],
                  ),
                  const CustomVerticalSpace(height: 24),
                  Row(
                    children: [
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('needSpecialTransfer'),
                        details: deceasedItem.specialTransferNeeded ?? false
                            ? trans('yes')
                            : trans('no'),
                      )),
                      CustomHorizontalSpace(width: 12),
                      if (deceasedItem.specialTransferReasonId != null)
                        Expanded(
                            child: EkramHeaderAndDescWidget(
                          title: trans('reasonForSpecialTransfer'),
                          details:
                              deceasedItem.specialTransferReasonId?.name ?? "",
                        )),
                      if (deceasedItem.specialTransferOtherReason != null &&
                          deceasedItem.specialTransferOtherReason!.isNotEmpty)
                        Expanded(
                            child: EkramHeaderAndDescWidget(
                          title: trans('reasonForSpecialTransfer'),
                          details:
                              deceasedItem.specialTransferOtherReason ?? "",
                        ))
                    ],
                  ),
                  CustomVerticalSpace(height: 20),
                  Row(
                    children: [
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                              title: trans('cemetry_name'),
                              details:
                                  deceasedItem.selectedCemetry?.name ?? "")),
                    ],
                  ),
                  const CustomVerticalSpace(height: 24),
                ],
              ),
            ),
          ],
        ));
  }
}
