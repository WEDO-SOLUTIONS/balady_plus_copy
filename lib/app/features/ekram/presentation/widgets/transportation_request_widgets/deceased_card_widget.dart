import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';

class DeceasedCardWidget extends StatelessWidget {
  final DeceasedInfoDto deceasedItem;
  final Function onDelete;
  final Function onEdit;

  const DeceasedCardWidget(
      {Key? key,
      required this.deceasedItem,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 318,
        height: 290,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        decoration: new BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(4),
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
                IconButton(
                  iconSize: 18,
                  splashRadius: 1,
                  onPressed: () => onEdit(),
                  icon: CustomSvgIconWidget(
                    "assets/icons/ekram_edit.svg",
                    iconHeight: 18,
                    iconWidth: 18,
                  ),
                ),
                IconButton(
                  iconSize: 18,
                  splashRadius: 1,
                  onPressed: () => onDelete(),
                  icon: CustomSvgIconWidget(
                    "assets/icons/ekram_delete.svg",
                    iconHeight: 18,
                    iconWidth: 18,
                  ),
                ),
              ],
            ),
            CustomVerticalSpace(height: 20),
            DrawLineWidget(
              lineColor: AppColor.black200.withOpacity(0.2000000029802322),
            ),
            CustomVerticalSpace(height: 20),
            Container(
              padding: EdgeInsetsDirectional.only(start: 24, end: 11),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('deceasedName3'),
                        details: deceasedItem.name ?? "",
                      )),
                      CustomHorizontalSpace(width: 12),
                      Expanded(
                          child: EkramHeaderAndDescWidget(
                        title: trans('ekramGender'),
                        details: deceasedItem.genderId?.name ?? "",
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
                        title: trans('ekramReligion'),
                        details: deceasedItem.getReligion() ?? "",
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
                ],
              ),
            ),
          ],
        ));
  }
}
