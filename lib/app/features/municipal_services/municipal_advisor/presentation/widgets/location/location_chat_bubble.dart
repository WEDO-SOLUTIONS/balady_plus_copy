import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

import '../../../../../_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';


class LocationChatBubble extends StatefulWidget {
  final LatLng latLng;
  const LocationChatBubble({
    super.key,
    required this.latLng,
  });

  @override
  State<LocationChatBubble> createState() => _LocationChatBubbleState();
}

class _LocationChatBubbleState extends State<LocationChatBubble> {
  final Completer<DgisMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: IgnorePointer(
          child:

          UrbiMapSection(
            readOnly: true,
            currentUserLocation: widget.latLng,
            incidentLocation: widget.latLng,
            onCameraIdle: (bool isIdle) {

            },
            updateMovedPosition: (LatLng p) {

            },
            onMapController: (DgisMapController controller) {
              if (_controller.isCompleted) return;
                  _controller.complete(controller);

            },
            showRadius: true,
          ),

          // GoogleMap(
          //   buildingsEnabled: false,
          //   myLocationButtonEnabled: false,
          //   compassEnabled: false,
          //   tiltGesturesEnabled: false,
          //   zoomControlsEnabled: false,
          //   mapToolbarEnabled: false,
          //   scrollGesturesEnabled: false,
          //   zoomGesturesEnabled: false,
          //   rotateGesturesEnabled: false,
          //   minMaxZoomPreference: const MinMaxZoomPreference(0, 15),
          //   initialCameraPosition: CameraPosition(
          //     target: widget.latLng,
          //     zoom: 15,
          //   ),
          //   onMapCreated: (GoogleMapController controller) {
          //     controller.setMapStyle(
          //       """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
          //     );
          //     if (_controller.isCompleted) return;
          //     _controller.complete(controller);
          //   },
          // ),




        ),
      ),
    );
  }
}
