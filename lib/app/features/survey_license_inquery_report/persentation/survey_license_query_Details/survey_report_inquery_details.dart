import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/no_data_widget.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../domain/entity/survey_inquery_data_entity.dart';
import '../bloc/survey_report_inquery_details_cubit.dart';

class SurveyReportInqueryDetails extends StatefulWidget {
  const SurveyReportInqueryDetails({super.key});

  @override
  State<SurveyReportInqueryDetails> createState() =>
      _SurveyReportInqueryDetailsState();
}

class _SurveyReportInqueryDetailsState
    extends State<SurveyReportInqueryDetails> {
  SurveyReportInqueryDetailsCubit? bloc;
  bool showDays = false;
  String? licenseNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        bloc = ModalRoute.of(context)!.settings.arguments
            as SurveyReportInqueryDetailsCubit;

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
          child: BlocBuilder<SurveyReportInqueryDetailsCubit,
              SurveyReportInqueryDetailsState>(
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
                        title: 'survey_inquery_details'.tr(),
                        icon: IconPath.editIcon,
                        isExpandedByDefault: false,
                        children: [
                          CardParameter(
                            title: 'survey_number'.tr(),
                            value:
                                licenceQueryDetails.licenseId.toString() ?? '',
                            bgColor: AppColor.mystic,
                          ),
                          licenceQueryDetails.oldLicenseId != null
                              ? CardParameter(
                                  title: 'old_survey_number'.tr(),
                                  value: licenceQueryDetails.oldLicenseId ?? '',
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          CardParameter(
                            title: 'survey_date'.tr(),
                            value:
                                licenceQueryDetails.licenseIssueDateDesc ?? "",
                            bgColor: AppColor.mystic,
                          ),
                          licenceQueryDetails.purposeName != null
                              ? CardParameter(
                                  title: 'survey_propose'.tr(),
                                  value: licenceQueryDetails.purposeName ?? '',
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          CardParameter(
                            title: 'survey_source'.tr(),
                            value: licenceQueryDetails.source ?? '',
                            bgColor: AppColor.mystic,
                          ),
                        ],
                      ),
                      ExpandableCard(
                        title: 'step3Title'.tr(),
                        icon: IconPath.editIcon,
                        children: [
                          licenceQueryDetails.municipalityName != null
                              ? CardParameter(
                                  title: 'municipality'.tr(),
                                  value: licenceQueryDetails.municipalityName
                                      .toString(),
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          licenceQueryDetails.subMunicipalityName != null
                              ? CardParameter(
                                  // from whats
                                  title: 'sub_municipality'.tr(),
                                  value: licenceQueryDetails.subMunicipalityName
                                      .toString(),
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          licenceQueryDetails.districtName != null
                              ? CardParameter(
                                  // from whats
                                  title: 'district'.tr(),
                                  value: licenceQueryDetails.districtName
                                      .toString(),
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          licenceQueryDetails.mapNumber != null
                              ? CardParameter(
                                  // from whats
                                  title: 'planNumber'.tr(),
                                  value:
                                      licenceQueryDetails.mapNumber.toString(),
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          licenceQueryDetails.mainBuildingClassName != null
                              ? CardParameter(
                                  // from whats
                                  title: 'compliance_main_usage'.tr(),
                                  value: licenceQueryDetails
                                      .mainBuildingClassName
                                      .toString(),
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          licenceQueryDetails.subBuildingClassName != null
                              ? CardParameter(
                                  // from whats
                                  title: 'compliance_sub_usage'.tr(),
                                  value: licenceQueryDetails
                                      .subBuildingClassName
                                      .toString(),
                                  bgColor: AppColor.mystic,
                                )
                              : Container(),
                          const SizedBox(height: 16),
                          licenceQueryDetails.x != null &&
                                  licenceQueryDetails.y != null
                              ? SizedBox(
                                  height: 250,
                                  child: Stack(children: [

                                    UrbiMapSection(
                                      readOnly: true,
                                      marker:  [
                                        Marker(
                                        id: "Location",
                                        options: MarkerOptionsMessage(
                                          position: GeoPointWithElevationMessage(
                                            latitude: double.parse(licenceQueryDetails.y!),
                                            longitude: double.parse(licenceQueryDetails.x!),
                                            elevation: 0,
                                          ),
                                          icon: MarkerIconMessage(
                                            width: 28,
                                            pngPath:  Constants.mapMarkerLocation,
                                          ),

                                        ),
                                      )],
                                      currentUserLocation: LatLng(latitude:double.parse(licenceQueryDetails.y!), longitude:double.parse(licenceQueryDetails.x!)),
                                      incidentLocation: LatLng(latitude:double.parse(licenceQueryDetails.y!), longitude:double.parse(licenceQueryDetails.x!)),
                                      onCameraIdle: (bool isIdle) {

                                      },
                                      updateMovedPosition: (LatLng p) {

                                      },
                                      onMapController: (DgisMapController controller) {

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
                                    //   onMapCreated:
                                    //       (GoogleMapController controller) {
                                    //     controller.setMapStyle(
                                    //       """[{ "featureType": "water","elementType": "labels.text",  "stylers": [{  "visibility": "off" }                                ]                            }                           ]""",
                                    //     );
                                    //   },
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
                                            image:
                                                AssetImage(IconPath.direction)),
                                      ),
                                    ),
                                  ]),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      (licenceQueryDetails.parcels != null &&
                              licenceQueryDetails.parcels!.isNotEmpty)
                          ? ExpandableCard(
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
                                      itemCount:
                                          licenceQueryDetails.parcels!.length,
                                      itemBuilder: (_, index) {
                                        Parcel activity =
                                            licenceQueryDetails.parcels![index];
                                        return ExpandableCard(
                                          title: "${"land".tr()} ${index + 1}",
                                          bgColor: AppColor.lightGray,
                                          children: [
                                            activity.landNo != null
                                                ? CardParameter(
                                                    title: 'landNo'.tr(),
                                                    value: activity.landNo
                                                        .toString(),
                                                    bgColor: AppColor.lightGray,
                                                  )
                                                : Container(),
                                            activity.landNo != null
                                                ? const Divider(
                                                    height: 2,
                                                    color: AppColor
                                                        .blackModern200Light,
                                                  )
                                                : Container(),
                                            activity.area != null &&
                                                    activity.area != 0
                                                ? CardParameter(
                                                    // from whats
                                                    title: 'area_natural'.tr(),
                                                    value: activity.area
                                                        .toString(),
                                                    bgColor: AppColor.lightGray,
                                                  )
                                                : Container(),
                                            activity.area != 0
                                                ? const Divider(
                                                    height: 2,
                                                    color: AppColor
                                                        .blackModern200Light,
                                                  )
                                                : Container(),
                                            activity.areaAccordingToScheme !=
                                                        null &&
                                                    activity.areaAccordingToScheme !=
                                                        0
                                                ? CardParameter(
                                                    // from whats
                                                    title: 'area_schema'.tr(),
                                                    value: activity
                                                        .areaAccordingToScheme
                                                        .toString(),
                                                    bgColor: AppColor.lightGray,
                                                  )
                                                : Container(),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              }
              return Center(
                child: NoDataWidget(
                  title: state.errorMessage,
                ),
              );
            },
          ),
        ),
      ),
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
