import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/map_utils.dart';

class EkramMapPage extends StatelessWidget {
  const EkramMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    LatLng location = ModalRoute.of(context)!.settings.arguments as LatLng;

    return Scaffold(
        appBar: null,
        body: Stack(
          children: [
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
            GoogleMap(
              zoomControlsEnabled: true,
              // myLocationEnabled: true,
              // myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(
                  """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                );
              },
              markers: {
                Marker(
                    markerId: MarkerId("1"),
                    icon: MapUtils.pinMarkerDarkGreen ??
                        BitmapDescriptor.defaultMarker,
                    position: location),
              },
              initialCameraPosition: CameraPosition(target: location, zoom: 7),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsetsDirectional.only(
                      start: 16, top: MediaQuery.of(context).padding.top + 10),
                  child: /*BtnIconPrimaryIconWidget(
                          iconSize: 20,
                          iconPath: IconPath.close,
                          onPressed: () => Navigator.of(context).pop(),
                        )*/
                      Image.asset(
                    Constants.imgPath + 'exit@3x.png',
                    height: 38,
                    width: 38,
                  ),
                ),
              ),
            ),
            /* Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.selectedBranch != null)
                      BranchCard(
                        name: state.selectedBranch?.name ?? "",
                        address: state.selectedBranch?.address ?? "",
                        mobile: state.selectedBranch?.contact,
                      )
                  ],
                ),
              ),
            ),*/
          ],
        ));
  }
}
