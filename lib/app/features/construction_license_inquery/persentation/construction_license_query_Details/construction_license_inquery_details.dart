import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../survey_license_inquery_report/domain/entity/survey_inquery_data_entity.dart';
import '../../domain/entity/construction_license_inquery_data_entity.dart';
import '../bloc/construction_license_inquery_details_cubit.dart';

class ConstructionLicenseInqueryDetails extends StatefulWidget {
  const ConstructionLicenseInqueryDetails({super.key});

  @override
  State<ConstructionLicenseInqueryDetails> createState() =>
      _ConstructionLicenseInqueryDetailsState();
}

class _ConstructionLicenseInqueryDetailsState
    extends State<ConstructionLicenseInqueryDetails> {
  ConstructionLicenseInqueryDetailsCubit? bloc;
  bool showDays = false;
  String? licenseNumber;
  DgisMapController? mapController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      setState(() {
        licenseNumber = "${bloc!.licenseNumber}#";
      });
      bloc!.getLicenseQueryDetails(bloc!.licenseNumber, bloc!.licenseDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        bloc = ModalRoute.of(context)!.settings.arguments
            as ConstructionLicenseInqueryDetailsCubit;

        return bloc!;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: DefaultAppBarWidget(
          titleWidget: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: 'query'.tr(), style: AppStyle.complianceTitleStyle),
                const WidgetSpan(
                    child: SizedBox(
                  width: 10,
                )),
                TextSpan(
                    text: licenseNumber, style: AppStyle.listTitleTextStyle),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: getBody(),
        ),
      ),
    );
  }

  Widget getBody() {
    return BlocConsumer<ConstructionLicenseInqueryDetailsCubit,
        ConstructionLicenseInqueryDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) async {
        // if (state.status == BlocRequestStatus.submissionGetFailure) {
        //   MessageDialog.showErrorNotification(msg: state.error);
        // }
      },
      builder: (context, state) {
        if (state.status == BlocRequestStatus.submissionGetLoading) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              height: 200,
              margin: const EdgeInsets.only(top: 16),
              child: const ShimmerEffectWidget(),
            ),
          );
        } else if (state.licenceQueryDetails != null) {
          final licenceQueryDetails = state.licenceQueryDetails!;
          return SingleChildScrollView(
            child: Column(
              children: [
                ExpandableCard(
                  title: 'license_details'.tr(),
                  icon: IconPath.editIcon,
                  isExpandedByDefault: false,
                  children: [
                    CardParameter(
                      title: 'unified_license_number'.tr(),
                      value: licenceQueryDetails.licenseId.toString() ?? '',
                      bgColor: AppColor.mystic,
                    ),
                    licenceQueryDetails.oldLicenseId != null || licenceQueryDetails.oldLicenseId != 0?
                    CardParameter(
                      title: 'license_number_municipality'.tr(),
                      value: licenceQueryDetails.oldLicenseId ?? '',
                      bgColor: AppColor.mystic,
                    ):Container(),
                    CardParameter(
                      title: 'license_issue_date'.tr(),
                      value: licenceQueryDetails.licenseIssueDateDesc ?? "",
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      title: 'license_status'.tr(),
                      value: licenceQueryDetails.statusName ?? '',
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      title: 'building_type'.tr(),
                      value: licenceQueryDetails.buildingTypeName ?? '',
                      bgColor: AppColor.mystic,
                    ),

                    licenceQueryDetails
                        .surveyReport != null && licenceQueryDetails
                        .surveyReport!.mainBuildingClassName != null?
                    CardParameter(
                      // from whats
                      title: 'compliance_main_usage'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.mainBuildingClassName!
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),
                    licenceQueryDetails
                        .surveyReport != null && licenceQueryDetails
                        .surveyReport!.subBuildingClassName != null ?
                    CardParameter(
                      // from whats
                      title: 'compliance_sub_usage'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.subBuildingClassName
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),

                  ],
                ),
                licenceQueryDetails
                    .surveyReport != null ?
                ExpandableCard(
                  title: 'step3Title'.tr(),
                  icon: IconPath.editIcon,
                  children: [
                    licenceQueryDetails
                        .surveyReport!.municipalityName != null?
                    CardParameter(
                      title: 'municipality'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.municipalityName
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),
                    licenceQueryDetails
                        .surveyReport!.subMunicipalityName != null?
                    CardParameter(
                      // from whats
                      title: 'sub_municipality'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.subMunicipalityName
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),


                    licenceQueryDetails
                        .surveyReport!.districtName != null?
                    CardParameter(
                      // from whats
                      title: 'district'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.districtName
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),

                    licenceQueryDetails
                        .surveyReport!.mapNumber != null?
                    CardParameter(
                      // from whats
                      title: 'planNumber'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.mapNumber
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),
                    licenceQueryDetails
                        .surveyReport!.mainBuildingClassName != null?
                    CardParameter(
                      // from whats
                      title: 'compliance_main_usage'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.mainBuildingClassName
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),
                    licenceQueryDetails
                        .surveyReport!.subBuildingClassName
                    != null?
                    CardParameter(
                      // from whats
                      title: 'compliance_sub_usage'.tr(),
                      value: licenceQueryDetails
                          .surveyReport!.subBuildingClassName
                          .toString(),
                      bgColor: AppColor.mystic,
                    ):Container(),


                    const SizedBox(height: 16),
                    licenceQueryDetails.x != null &&
                            licenceQueryDetails.y != null
                        ? SizedBox(
                            height: 250,
                            child: Stack(children: [


                              UrbiMapSection(
                                readOnly: true,
                                currentUserLocation:LatLng(latitude: double.parse(licenceQueryDetails.y!),longitude: double.parse(licenceQueryDetails.x!)),
                                incidentLocation:LatLng(latitude: double.parse(licenceQueryDetails.y!),longitude: double.parse(licenceQueryDetails.x!)),
                                onCameraIdle: (bool isIdle) {
                                  mapController?.moveCamera(
                                    CameraPositionMessage(
                                      point: GeoPointMessage(latitude:  double.parse(licenceQueryDetails.y!), longitude: double.parse(licenceQueryDetails.x!)),
                                      zoom: 16.0,
                                      tilt: 0.0,
                                      bearing: 0.0,
                                    ),
                                    0.3, // duration
                                    CameraAnimationTypeMessage.linear,
                                  );
                                },
                                updateMovedPosition: (LatLng p) {

                                },
                                onMapController: (DgisMapController controller) {
                                  mapController = controller;
                                },
                                showRadius: true,
                              ),
                              // GoogleMap(
                              //   initialCameraPosition: CameraPosition(
                              //       target: LatLng(
                              //         double.parse(
                              //             licenceQueryDetails.y!),
                              //         double.parse(
                              //             licenceQueryDetails.x!),
                              //       ),
                              //       zoom: 16),
                              //   markers: {
                              //     Marker(
                              //       markerId: const MarkerId('position'),
                              //       position: LatLng(
                              //         double.parse(
                              //             licenceQueryDetails.y!),
                              //         double.parse(
                              //             licenceQueryDetails.x!),
                              //       ),
                              //     )
                              //   },
                              //   onMapCreated: (GoogleMapController controller) {
                              //     controller.setMapStyle(
                              //       """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                              //     );
                              //   },
                              //   zoomControlsEnabled: false,
                              //   zoomGesturesEnabled: false,
                              //   scrollGesturesEnabled: false,
                              // ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    navigateTo(
                                        double.parse(
                                            licenceQueryDetails.y!),
                                        double.parse(
                                            licenceQueryDetails.x!));
                                  },
                                  child: const Image(
                                      height: 40,
                                      width: 40,
                                      image: AssetImage(IconPath.direction)),
                                ),
                              ),
                            ]),
                          )
                        : const SizedBox(),


                  ],
                ):Container(),

                (licenceQueryDetails.surveyReport != null&&licenceQueryDetails.surveyReport!.parcels !=
                    null &&
                    licenceQueryDetails
                        .surveyReport!.parcels!.isNotEmpty)?
                ExpandableCard(
                  title: 'land_information'.tr(),
                  icon: IconPath.editIcon,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        ListView.builder(
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: licenceQueryDetails
                              .surveyReport!.parcels!.length,
                          itemBuilder: (_, index) {
                            Parcel activity =
                            licenceQueryDetails
                                .surveyReport!.parcels![index];
                            return ExpandableCard(
                              title: "${"land".tr()} ${index+1}",
                              bgColor: AppColor.lightGray,
                              children: [

                                activity.landNo != null?
                                CardParameter(
                                  title: 'landNo'.tr(),
                                  value: activity.landNo
                                      .toString(),
                                  bgColor: AppColor.lightGray,
                                ):Container(),
                                activity.landNo != null     ?
                                const Divider(
                                  height: 2,
                                  color:
                                  AppColor.blackModern200Light,
                                ):Container(),

                                activity.area != null && activity.area != 0?
                                CardParameter(
                                  // from whats
                                  title: 'area_natural'.tr(),
                                  value: activity.area.toString(),
                                  bgColor: AppColor.lightGray,
                                ):Container(),
                                activity.area != 0?
                                const Divider(
                                  height: 2,
                                  color: AppColor.blackModern200Light,
                                ):Container(),
                                activity.areaAccordingToScheme != null&&activity.areaAccordingToScheme != 0 ?
                                CardParameter(
                                  // from whats
                                  title: 'area_schema'.tr(),
                                  value:
                                  activity.areaAccordingToScheme.toString(),
                                  bgColor: AppColor.lightGray,
                                ):Container(),
                              ],
                            );
                          },
                        ),
                      ],
                    )
                    ,
                  ],
                ):Container(),



                const SizedBox(height: 24),
              ],
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            errorMessage: "no_data_found".tr(),
            onTab: () {
              bloc!.getLicenseQueryDetails(
                  bloc!.licenseNumber, bloc!.licenseDate);
            },
          ),
        );
      },
    );
  }

  static Future<void> navigateTo(double lat, double lng) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      // url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&mode=d';
      url = "google.navigation:q=$lat,$lng&mode=d";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        MessageDialog.showErrorNotification(msg: "cannot_open_google".tr());
      }
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
        await launchUrl(Uri.parse(urlAppleMaps));
      } else {
        MessageDialog.showErrorNotification(msg: "cannot_open_google".tr());
      }
    }
  }
}
