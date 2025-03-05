import 'dart:io';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_inquery/persentation/commercial_license_query_Details/socail_contact_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_inquery/persentation/commercial_license_query_Details/working_hours_details_update.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../features/_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../domain/entity/commercial_license_data_entity.dart';
import '../bloc/commercial_license_query_details_cubit.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class CommercialLicenseQueryDetails extends StatefulWidget {
  const CommercialLicenseQueryDetails({super.key});

  @override
  State<CommercialLicenseQueryDetails> createState() =>
      _CommercialLicenseQueryDetailsState();
}

class _CommercialLicenseQueryDetailsState
    extends State<CommercialLicenseQueryDetails> {
  CommercialLicenseQueryDetailsCubit? bloc;
  bool showDays = false;
  String? commercialLicenseNumber;
  DgisMapController? mapController;

  @override
  void initState() {
    super.initState();

    // commercialLicenseNumber = 45079837078;
    // unifiedFacilityNumber = 7008360062;

    Future.microtask(() {
      setState(() {
        commercialLicenseNumber = "${bloc!.commercialLicenseNumber}#";
      });
      bloc!.getCommercialLicenseQueryDetails(
          bloc!.commercialLicenseNumber, bloc!.unifiedFacilityNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        bloc = ModalRoute.of(context)!.settings.arguments
            as CommercialLicenseQueryDetailsCubit;

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
                    text: commercialLicenseNumber,
                    style: AppStyle.listTitleTextStyle),
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
    return BlocConsumer<CommercialLicenseQueryDetailsCubit,
        CommercialLicenseQueryDetailsState>(
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
        } else if (state.commercialLicenceQueryDetails != null) {
          final commercialLicenceQueryDetails =
              state.commercialLicenceQueryDetails!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColor.primary50Light,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            CustomTextWidget(
                              commercialLicenceQueryDetails
                                      .licenseStatus?.name ??
                                  "",
                              textStyle: AppStyle.tagTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ExpandableCard(
                  title: 'license_info'.tr(),
                  icon: IconPath.editIcon,
                  isExpandedByDefault: false,
                  children: [
                    CardParameter(
                      title: 'crNumbers'.tr(),
                      value: commercialLicenceQueryDetails.licenseNumber
                              .toString() ??
                          '',
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      title: 'facilityType'.tr(),
                      value: commercialLicenceQueryDetails.entityType ?? '',
                      bgColor: AppColor.mystic,
                    ),
                    CardParameter(
                      title: 'employee_type'.tr(),
                      value: commercialLicenceQueryDetails.workerType ?? "",
                      bgColor: AppColor.mystic,
                    ),

                    commercialLicenceQueryDetails.shopNameAr != null
                        ? CardParameter(
                            title: 'license_shop_name_ar'.tr(),
                            value:
                                commercialLicenceQueryDetails.shopNameAr ?? '',
                            bgColor: AppColor.mystic,
                          )
                        : Container(),
                    /////////////////////
                    commercialLicenceQueryDetails.shopNameEn != null
                        ? CardParameter(
                            title: 'license_shop_name_en'.tr(),
                            value:
                                commercialLicenceQueryDetails.shopNameEn ?? '',
                            bgColor: AppColor.mystic,
                          )
                        : Container(),
                    CardParameter(
                      title: 'city'.tr(),
                      value: commercialLicenceQueryDetails.city?.name ?? '',
                      bgColor: AppColor.mystic,
                    ),
                    commercialLicenceQueryDetails.district != null
                        ? CardParameter(
                            title: 'district'.tr(),
                            value:
                                commercialLicenceQueryDetails.district?.name ??
                                    '',
                            bgColor: AppColor.mystic,
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    commercialLicenceQueryDetails.x != null &&
                            commercialLicenceQueryDetails.y != null
                        ? SizedBox(
                            height: 250,
                            child: Stack(children: [


                              UrbiMapSection(
                                readOnly: true,
                                currentUserLocation:LatLng(latitude: double.parse(commercialLicenceQueryDetails.y!),longitude: double.parse(commercialLicenceQueryDetails.x!)),
                                incidentLocation:LatLng(latitude: double.parse(commercialLicenceQueryDetails.y!),longitude: double.parse(commercialLicenceQueryDetails.x!)),
                                onCameraIdle: (bool isIdle) {
                                  mapController?.moveCamera(
                                    CameraPositionMessage(
                                      point: GeoPointMessage(latitude:  double.parse(commercialLicenceQueryDetails.y!), longitude: double.parse(commercialLicenceQueryDetails.x!)),
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
                              //             commercialLicenceQueryDetails.y!),
                              //         double.parse(
                              //             commercialLicenceQueryDetails.x!),
                              //       ),
                              //       zoom: 16),
                              //   markers: {
                              //     Marker(
                              //       markerId: const MarkerId('position'),
                              //       position: LatLng(
                              //         double.parse(
                              //             commercialLicenceQueryDetails.y!),
                              //         double.parse(
                              //             commercialLicenceQueryDetails.x!),
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
                                            commercialLicenceQueryDetails.y!),
                                        double.parse(
                                            commercialLicenceQueryDetails.x!));
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
                ),
                commercialLicenceQueryDetails.mainActivity != null
                    ? ExpandableCard(
                        title: 'activity_info'.tr(),
                        icon: IconPath.editIcon,
                        children: [
                          CardParameter(
                            title: 'isicNumber'.tr(),
                            value: commercialLicenceQueryDetails
                                .mainActivity!.isicNumber
                                .toString(),
                            bgColor: AppColor.mystic,
                          ),
                          CardParameter(
                            // from whats
                            title: 'isicName'.tr(),
                            value: commercialLicenceQueryDetails
                                .mainActivity!.isicName
                                .toString(),
                            bgColor: AppColor.mystic,
                          ),
                          (commercialLicenceQueryDetails.additionalActivities !=
                                      null &&
                                  commercialLicenceQueryDetails
                                      .additionalActivities!.isNotEmpty)
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomTextWidget(
                                      'additional_activity_info'.tr(),
                                      textStyle: AppStyle.cardTitleTextStle
                                          .copyWith(fontSize: 16),
                                      maxLines: 2,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: commercialLicenceQueryDetails
                                          .additionalActivities!.length,
                                      itemBuilder: (_, index) {
                                        LicenseActivity activity =
                                            commercialLicenceQueryDetails
                                                .additionalActivities![index];
                                        return ExpandableCard(
                                          title: activity.detailedActivityName!,
                                          bgColor: AppColor.lightGray,
                                          children: [
                                            CardParameter(
                                              title: 'extra_isicNumber'.tr(),
                                              value: activity.isicNumber
                                                  .toString(),
                                              bgColor: AppColor.lightGray,
                                            ),
                                            const Divider(
                                              height: 2,
                                              color:
                                                  AppColor.blackModern200Light,
                                            ),
                                            CardParameter(
                                              // from whats
                                              title: 'extra_isicName'.tr(),
                                              value:
                                                  activity.isicName.toString(),
                                              bgColor: AppColor.lightGray,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      )
                    : const SizedBox(),
                if (commercialLicenceQueryDetails.workTimes != null)
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),
                          CustomTextWidget(
                            'personal_contact_info'.tr(),
                            textStyle: AppStyle.cardTitleTextStle
                                .copyWith(fontSize: 16),
                            maxLines: 2,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      boxShadow: [],
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.white),
                  child: Column(
                    children: [
                      if (commercialLicenceQueryDetails.workTimes != null)
                        WorkingHourDetailsUpdate(
                          openNow:
                              commercialLicenceQueryDetails.checkIsOpenNow(),
                          todayWorkingHours: commercialLicenceQueryDetails
                              .getTodayWorkingHours(),
                          workingHours:
                              (commercialLicenceQueryDetails.workTimes!),
                          customerServiceNumber: commercialLicenceQueryDetails
                              .customerServicePhoneNumber??"",
                        ),
                    ],
                  ),
                ),
                if (commercialLicenceQueryDetails.website != null &&
                    commercialLicenceQueryDetails.website!.isNotEmpty) ...[
                  const CustomVerticalSpace(height: 20),
                  LabelIconSubtitleComponent(
                    padding: const EdgeInsetsDirectional.only(
                        start: 20, top: 10, bottom: 10),
                    text: ('website').tr(),
                    icon: IconPath.qrWebIcon,
                    subtitle: commercialLicenceQueryDetails.website,
                    onPress: () async {
                      try {
                        String url = commercialLicenceQueryDetails.website!;
                        if (url.contains("https") == false ||
                            url.contains("http") == false) {
                          url = "https://$url";
                        }

                        await launchUrl(Uri.parse(url));
                      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
                    },
                  )
                ],
                if (commercialLicenceQueryDetails.phone != null &&
                    commercialLicenceQueryDetails.phone!.isNotEmpty) ...[
                  const CustomVerticalSpace(height: 20),
                  LabelIconSubtitleComponent(
                    padding: const EdgeInsetsDirectional.only(
                        start: 20, top: 10, bottom: 10),
                    text: ('contact_number').tr(),
                    icon: IconPath.qrCallIcon,
                    subtitle: commercialLicenceQueryDetails.phone,
                    onPress: () {
                      launch("tel://${commercialLicenceQueryDetails.phone}");
                    },
                  )
                ],
                const SizedBox(height: 20),
                SocailContactWidget(
                  twitterContact: commercialLicenceQueryDetails.twitter,
                  snapchatContact: commercialLicenceQueryDetails.snapchat,
                  instegramContact: commercialLicenceQueryDetails.instagram,
                  facebookContact: commercialLicenceQueryDetails.facebook,
                  whatsappContact: commercialLicenceQueryDetails.whatsApp,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            errorMessage: "no_data_found".tr(),
            onTab: () {
              bloc!.getCommercialLicenseQueryDetails(
                  bloc!.commercialLicenseNumber, bloc!.unifiedFacilityNumber);
            },
          ),
        );
      },
    );
  }

  //  void navigateTo(double lat, double lng) async {
  //   var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  //   if (await canLaunch(uri.toString())) {
  //     await launch(uri.toString());
  //   } else {
  //     MessageDialog.showErrorNotification(msg: "cannot_open_google".tr());
  //
  //   }
  // }

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
