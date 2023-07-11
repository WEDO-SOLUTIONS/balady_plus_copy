import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget, ElevatedButtonWidget;
import '../../municipal_advisor_exports.dart'
    show
        MunicipalAdvisorBloc,
        MunicipalAdvisorAddMessageEvent,
        MunicipalAdvisorSteps;

class LocationPage extends StatefulWidget {
  final MunicipalAdvisorBloc bloc;

  const LocationPage({
    super.key,
    required this.bloc,
  });

  @override
  State<LocationPage> createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition defaultLocation = CameraPosition(
    target: LatLng(26.289472114068804, 43.912184371764624),
    zoom: 10,
  );
  //Varaibles
  LatLng? coordinates;
  String? address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
        value: widget.bloc,
        child: Stack(
          children: [
            GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: defaultLocation,
              padding: const EdgeInsets.only(bottom: 60),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onCameraIdle: () async {
                if (coordinates == null || !context.mounted) return;
                setState(() {
                  address =
                      '${coordinates!.latitude}, ${coordinates!.longitude}';
                });
              },
              onCameraMove: (position) {
                if (context.mounted) {
                  coordinates = position.target;
                }
              },
            ),
            Positioned(
              bottom: (MediaQuery.of(context).size.height / 2) + 28,
              left: MediaQuery.of(context).size.width / 2 - 12,
              child: const DrawIconBasedTypeWidget(
                icon: IconPath.marker,
                iconSize: 25,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      CustomTextWidget(
                        'location'.tr(),
                        textStyle: AppStyle.locationCardTitleTextStyle,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const DrawIconBasedTypeWidget(
                            icon: IconPath.marker,
                          ),
                          const SizedBox(width: 4),
                          CustomTextWidget(
                            address ?? 'municipalAdvisorLocationHint'.tr(),
                            textStyle: AppStyle.locationCardAddressTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Builder(
                        builder: (context) {
                          return ElevatedButtonWidget.confirmLocation(
                            onPressed: () {
                              if (coordinates == null || address == null) {
                                return;
                              }
                              //postframe
                              context.read<MunicipalAdvisorBloc>().add(
                                    MunicipalAdvisorAddMessageEvent(
                                      message: address!,
                                      step: MunicipalAdvisorSteps.location,
                                      data: coordinates,
                                    ),
                                  );
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
