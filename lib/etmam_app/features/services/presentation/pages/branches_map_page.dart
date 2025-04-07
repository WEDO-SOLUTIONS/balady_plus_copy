import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show BranchMapBloc, BranchMapState;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;
import 'package:dgis_map/library.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:collection/collection.dart';

import '../../../../../app/core/utils/constants/constants.dart';
import '../../../../../app/features/_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../../core/utils/utils_exports.dart'
    show CommonFunctions, CommonProperties, IconPath;
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show BtnIconPrimaryIconWidget;
import '../../services_exports.dart' show BranchCard, Branch;

class BranchesMapPage extends StatefulWidget {
  const BranchesMapPage({Key? key}) : super(key: key);

  @override
  State<BranchesMapPage> createState() => _BranchesMapPageState();
}

class _BranchesMapPageState extends State<BranchesMapPage> {
  final int selectedBranch = -1;
  late List<Branch> branches;

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.BranchesInMapPage);
  }

  @override
  Widget build(BuildContext context) {
    branches = ModalRoute.of(context)!.settings.arguments as List<Branch>;

    return Scaffold(
        appBar: null,
        body: BlocProvider(
          create: (context) => BranchMapBloc(branches: branches),
          child: BlocConsumer<BranchMapBloc, BranchMapState>(
            listener: (context, state) {
              if (state.status == BlocStatus.failure) {
                CommonFunctions.showError(state.errorMessage ?? "");
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                  UrbiMapSection(
                    readOnly: false,
                    currentUserLocation:  branches.firstOrNull?.getLatLng() ??CommonProperties.defaultLocation,
                    incidentLocation: branches.firstOrNull?.getLatLng() ??CommonProperties.defaultLocation,
                    marker: context.read<BranchMapBloc>().getMarkers().toList(),
                    onCameraIdle: (bool isIdle) {

                    },
                    updateMovedPosition: (LatLng p) {

                    },
                    onMapController: (DgisMapController controller) {

                    },
                    showRadius: true,
                  ),

                  // GoogleMap(
                  //   zoomControlsEnabled: true,
                  //   // myLocationEnabled: true,
                  //   // myLocationButtonEnabled: true,
                  //   markers: context.read<BranchMapBloc>().getMarkers(),
                  //   onMapCreated:
                  //       (GoogleMapController controller) {
                  //     controller.setMapStyle(
                  //       """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                  //     );
                  //   },
                  //   initialCameraPosition: CameraPosition(
                  //       target: branches.firstOrNull?.getLatLng() ??
                  //           CommonProperties.defaultLocation,
                  //       zoom: 7),
                  // ),



                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(
                            start: 16,
                            top: MediaQuery.of(context).padding.top + 10),
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
                  Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // my location button
                          // Container(
                          //   margin: const EdgeInsetsDirectional.only(
                          //       end: 16, bottom: 16),
                          //   child: CustomIconButtonWidget(
                          //       padding: EdgeInsets.zero,
                          //       btnPressed: () {},
                          //       icon: const CustomSvgIconWidget(
                          //         IconPath.myLocationIcon,
                          //         iconSize: 32,
                          //       )),
                          // ),
                          // branch card
                          if (state.selectedBranch != null)
                            BranchCard(
                              name: state.selectedBranch?.name ?? "",
                              address: state.selectedBranch?.address ?? "",
                              mobile: state.selectedBranch?.contact,
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ));
  }
}
