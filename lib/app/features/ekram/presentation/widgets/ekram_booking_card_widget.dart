import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    show EkramBookingItem, EkramHeaderAndDescWidget_With_Background, EkramStatusWidget;
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../objectable_transactions/presentation/widgets/request_parameter.dart';
import '../../domain/entities/cemetry_requests/cemetry_request_item.dart';
import 'driver/request_card_widget.dart';

class EkramBookingCardWidget extends StatelessWidget {
  final CemetryRequestItem item;
  final Function OnDetailsPress;
  const EkramBookingCardWidget(
      {Key? key, required this.item, required this.OnDetailsPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OnDetailsPress(),
      child: Container(
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
        ),
        child: Column(
          children: [
            Row(
              children: [
                const DrawIconBasedTypeWidget(icon: IconPath.requests),
                const CustomHorizontalSpace(
                  width: 4,
                ),
                Expanded(
                  child: CustomTextWidget(
                    '#${item.requestNumber.toString()}'.tr(),
                    textStyle: AppStyle.requestNumberTextStle,
                    textAlign: TextAlign.start,
                  ),
                ),
                HomeTag(
                  title: item.requestStatusName ?? "",
                  backgroundColor: AppColor.secondary100Light,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                children: [
                  RequestParameter(
                    title: 'deceasedName'.tr(),
                    value: item.deceasedName ?? "",
                  ),
                  RequestParameter(
                    title: 'cemeteryName'.tr(),
                    value: item.cemeteryName ?? "",
                  ),
                  RequestParameter(
                    title: 'burialDate'.tr(),
                    value: item.burialDate ?? "",
                  ),
                  RequestParameter(
                    title: 'cemetry_deceassed_burial_time'.tr(),
                    value: item.burialTime ?? "",
                  ),
                ],
              ),
            ),
            ElevatedButtonWidget.primaryCustom(
                height: 40,
                onPressed: () => OnDetailsPress(),
                text: "details".tr())
          ],
        ),
      ),
    );
  }
}
