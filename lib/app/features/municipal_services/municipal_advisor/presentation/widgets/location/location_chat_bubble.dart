import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 138,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: IgnorePointer(
          child: GoogleMap(
            buildingsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: false,
            tiltGesturesEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            scrollGesturesEnabled: false,
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            minMaxZoomPreference: const MinMaxZoomPreference(0, 15),
            initialCameraPosition: CameraPosition(
              target: widget.latLng,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(
                """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
              );
              if (_controller.isCompleted) return;
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}
