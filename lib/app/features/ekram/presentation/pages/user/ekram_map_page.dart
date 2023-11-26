import 'package:balady_new_app/app/core/shared_local_services/constants.dart';
import 'package:balady_new_app/app/core/shared_local_services/map_utils.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EkramMapPage extends StatelessWidget {
  final LatLng location;
  const EkramMapPage({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
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
