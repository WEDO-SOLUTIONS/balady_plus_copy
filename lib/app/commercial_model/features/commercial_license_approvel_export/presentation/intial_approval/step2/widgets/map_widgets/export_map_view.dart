
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import '../../../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../../../../features/_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../bloc/step2_activity_data_export_cubit.dart';
import 'map_address_card.dart';

class ExportMapView extends StatefulWidget {
  final bool showSearch;
  final bool showSearchPaddingScreen;
  final bool showRadius;
  final bool readOnly;

  ExportMapView(
      {this.showSearch = true,
      this.showSearchPaddingScreen = false,
      this.showRadius = false,
      this.readOnly = false});

  @override
  _ExportMapViewState createState() => _ExportMapViewState();
}

class _ExportMapViewState extends State<ExportMapView> {
  bool mapLoading = true;
  bool locationLoading = false;
  LatLng? movedPosition;
  bool isconfirm=false;
  @override
  void initState() {
    super.initState();
    isconfirm = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Step2ActivityDataExportCubit, Step2ActivityDataExportState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            // google map section
            UrbiMapSection(
              readOnly: widget.readOnly,
              currentUserLocation: state.userLocation?.getLatLng(),
              incidentLocation: state.location?.getLatLng() ??
                  state.userLocation?.getLatLng(),
              onCameraIdle: (bool isIdle) {
                if (widget.readOnly != true) {
                  if (movedPosition != null)
                    context
                        .read<Step2ActivityDataExportCubit>()
                        .add(SelectLocationEvent(location: movedPosition!));
                }
              },
              updateMovedPosition: (LatLng p) {
                movedPosition = p;
              },
              onMapController: (DgisMapController controller) {
                context.read<Step2ActivityDataExportCubit>().mapController = controller;
                context.read<Step2ActivityDataExportCubit>().add(InitMapEvent());
              },
              showRadius: widget.showRadius,
            ),

            PinMarkerSection(
              isLocationAllowed: state.isLocationAllowed ?? true,
            ),
            // current location button and address card
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // current location button
                  GestureDetector(
                    onTap: () async {
                      bool isSuccess =
                          await CommonFunctions.checkLocationSettings(context);
                      if (isSuccess)
                        context.read<Step2ActivityDataExportCubit>().add(GetCurentLocationEvent());
                    },
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(end: 12),
                      alignment: AlignmentDirectional.topEnd,
                      child: Image.asset(
                        IconPath.vdlocationIcon,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  //  address card
                  if (widget.readOnly != true)
                    MapAddressCard(
                      address: state.gisResponse?.getFullAddress(),
                      submitLocation: () async{

                        await Future.delayed(const Duration(seconds: 2));
                          context
                              .read<Step2ActivityDataExportCubit>()
                              .add(GetGISDataExportEvent(
                              params: state.location!,
                              gisResponse: state.gisResponse));

                      },
                      isValidLocation: true,
                    ),
                ],
              ),
            ),
            // search section
            if (widget.showSearch && (widget.readOnly != true))
              MapSearchSection(
                showBigPaddingScreen: widget.showSearchPaddingScreen,
                 currentUserLocation: state.userLocation?.getLatLng(),
                onSearchResult: (LatLng location) {


                  context.read<Step2ActivityDataExportCubit>().mapController.moveCamera(
                    CameraPositionMessage(
                      point: GeoPointMessage(latitude: location.latitude, longitude: location.longitude),
                      zoom: 16.0,
                      tilt: 0.0,
                      bearing: 0.0,
                    ),
                    0.3, // duration
                    CameraAnimationTypeMessage.linear,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}


