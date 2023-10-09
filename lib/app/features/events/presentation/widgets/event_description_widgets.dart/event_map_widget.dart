import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/map_utils.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_title.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class EventMapWidget extends StatelessWidget {
  final LatLng? location;
  const EventMapWidget({super.key, this.location});

  @override
  Widget build(BuildContext context) {
    return location != null
        ? GestureDetector(
            onTap: () {
              CommonFunctions.openMap(location!.latitude, location!.longitude);
            },
            child: Container(
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
                  Container(
                    child: SizedBox(
                      height: 178,
                      child: GoogleMap(
                          myLocationButtonEnabled: false,
                          markers: {
                            Marker(
                              markerId: MarkerId("location"),
                              position: location!,
                            )
                          },
                          initialCameraPosition: CameraPosition(
                            target: location!,
                            zoom: 15,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    onPressed: () {
                      CommonFunctions.openMap(
                          location!.latitude, location!.longitude);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          ("event_location_with_google").tr(),
                          fontSize: 17,
                          fontWeight: AppFontWeight.medium,
                          fontColor: AppColor.black,
                          textAlign: TextAlign.start,
                        ),
                        CustomSvgIconWidget(IconPath.qrOpenLinkIcon)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
