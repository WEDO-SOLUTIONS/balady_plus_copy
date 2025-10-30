import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';
import 'package:balady_plus/etmam_app/features/providers/presentation/blocs/provider_details_bloc/provider_details_bloc.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:collection/collection.dart';

import '../../../../../../app/features/_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, PrimaryIcons, trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, SectionTitleWidget;

class ProviderBranchesWidget extends StatelessWidget {
  const ProviderBranchesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
      builder: (context, state) {
        return state.args.branches != null && state.args.branches!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(top: 16, right: 16, left: 16),
                      child: SectionTitleWidget(
                        title: trans('provider_branches'),
                        primaryIcon: PrimaryIcons.locationSectionIcon,
                      )),
                  Container(
                    height: 160,
                    width: double.infinity,
                    color: AppColor.greyShadow,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child:

                    UrbiMapSection(
                      readOnly: true,
                      currentUserLocation: state.args.branches?.firstOrNull?.getLatLng() ?? CommonProperties.defaultLocation,
                      incidentLocation: state.args.branches?.firstOrNull?.getLatLng() ?? CommonProperties.defaultLocation,
                      marker:context.read<ProviderDetailsBloc>().getMarkers().toList(),
                      onCameraIdle: (bool isIdle) {

                      },
                      updateMovedPosition: (LatLng p) {

                      },
                      onMapController: (DgisMapController controller) {

                      },
                      showRadius: true,
                    ),

                    // GoogleMap(
                    //     zoomControlsEnabled: false,
                    //     markers:
                    //         context.read<ProviderDetailsBloc>().getMarkers(),
                    //     onMapCreated:
                    //         (GoogleMapController controller) {
                    //       controller.setMapStyle(
                    //         """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                    //       );
                    //     },
                    //     initialCameraPosition: CameraPosition(
                    //         target:
                    //             state.args.branches?.firstOrNull?.getLatLng() ??
                    //                 CommonProperties.defaultLocation,
                    //         zoom: 7)),




                  ),
                  CustomVerticalSpace(height: 12),
                ],
              )
            : Container();
      },
    );
  }
}
