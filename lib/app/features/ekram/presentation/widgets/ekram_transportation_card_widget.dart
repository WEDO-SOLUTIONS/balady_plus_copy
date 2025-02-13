import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../objectable_transactions/presentation/widgets/request_parameter.dart';
import '../../data/model/driver/transport_request_item_model.dart';
import '../../domain/entities/deceased_transport_requests/transport_request_item.dart';
import 'driver/request_card_widget.dart';
import 'ekram_status_widget.dart';

class EkramTransporationCardWidget extends StatelessWidget {
  final TransportRequestItemModel ekramTransportationItem;
  final Function OnDetailsPress;
  const EkramTransporationCardWidget(
      {super.key,
      required this.ekramTransportationItem,
      required this.OnDetailsPress});

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
                    '${'request'.tr()} ${ekramTransportationItem.requestId.toString()}#',
                    textStyle: AppStyle.requestNumberTextStle,
                    textAlign: TextAlign.start,
                  ),
                ),
                HomeTag(
                  title: ekramTransportationItem.requestStatusName ?? "",
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
                    title: 'decased_name'.tr(),
                    value: ekramTransportationItem.deceasedName ?? "",
                  ),
                  RequestParameter(
                    title: 'nationality'.tr(),
                    value:
                        ekramTransportationItem.deceasedNationalityName ?? "",
                  ),
                  RequestParameter(
                    title: 'sex'.tr(),
                    value: ekramTransportationItem.genderName ?? "",
                  ),
                  RequestParameter(
                    title: 'ekramReligion'.tr(),
                    value: ekramTransportationItem.isMuslim == true
                        ? 'muslim'.tr()
                        : ekramTransportationItem.isMuslim == false
                            ? 'non_muslim'.tr()
                            : "",
                  ),
                  RequestParameter(
                    title: 'ekramHospital'.tr(),
                    value: ekramTransportationItem.hospitalName ?? "",
                  ),
                  RequestParameter(
                    title: 'burialDate'.tr(),
                    value: ekramTransportationItem.burialDate ?? "",
                  ),
                  RequestParameter(
                    title: 'ekram_orgnization_name'.tr(),
                    value: ekramTransportationItem.hospitalName ?? "",
                  ),
                  RequestParameter(
                    title: 'driver_name'.tr(),
                    value: ekramTransportationItem.driverName ?? "",
                  ),
                  RequestParameter(
                    title: 'driverMobile'.tr(),
                    value: ekramTransportationItem.driverMobile ?? "",
                  ),

                  /* RequestParameter(
                    title: 'transportationStatus'.tr(),
                    value: ekramTransportationItem
                            .deceasedTransportRequestStatus ??
                        "",
                  ),
                  RequestParameter(
                    title: 'transportationDestination'.tr(),
                    value: ekramTransportationItem.currentStationName ?? "",
                  ),*/
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
