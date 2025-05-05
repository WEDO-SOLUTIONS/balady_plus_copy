import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_title.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';

class EventMapWidget extends StatelessWidget {
  final LatLng? location;
  final String? name;
  const EventMapWidget({super.key, this.location, this.name});

  @override
  Widget build(BuildContext context) {
    return location != null
        ? Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: AppColor.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventsTitleWidget(title: 'event_location_title'.tr()),
                CustomElevatedIconButtonWidget(
                  text: "move_through_balady_map".tr(),
                  btnColor: Colors.transparent,
                  btnBorderColor: AppColor.primary800Light,
                  textStyle: AppStyle.elevatedButtonStyle.copyWith(
                    color: AppColor.primary800Light,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                  icon: const CustomSvgIconWidget(
                    "assets/icons/svg/ic_car_poi.svg",
                    iconColor: AppColor.primary800Light,
                    iconSize: 24.0,
                  ),
                  onPressed: () {
                    // MapnessFunctions.openRoutesScreen(
                    //   finishPoint: MapnessRoutePoint(
                    //     latitude: location!.latitude,
                    //     longitude: location!.longitude,
                    //     label: name ?? "",
                    //   ),
                    // );
                  },
                )
              ],
            ),
          )
        : Container();
  }
}
