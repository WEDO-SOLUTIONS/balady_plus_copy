import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';


import '../../../../../../../features/_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../bloc/commercial_license_details_bloc.dart';
import 'ConclusionWidget.dart';
import 'ExtraActivitiesInfoWidget.dart';
import 'MainActivityInfoWidget.dart';
import 'SubmitterInfoWidget.dart';

class RequestDetailsBody extends StatefulWidget {
  const RequestDetailsBody({super.key});

  @override
  State<RequestDetailsBody> createState() =>
      _RequestDetailsBodyState();
}

class _RequestDetailsBodyState
    extends State<RequestDetailsBody> {
  DgisMapController? mapController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommercialLicenseDetailsBloc bloc = context.watch<CommercialLicenseDetailsBloc>();

    return BlocConsumer<CommercialLicenseDetailsBloc,
        CommercialLicenseDetailsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (_, state) async {
        if (state.status == BlocRequestStatus.submissionGetFailure) {
          MessageDialog.showErrorNotification(msg: state.error??"");
        }
      },
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              height: 200,
              margin: const EdgeInsets.only(top: 16),
              child: const ShimmerEffectWidget(),
            ),
          );
        } else if (state.requestDetails != null) {
          final requestCommercialLicenseDetails =
          state.requestDetails!;
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const DrawIconBasedTypeWidget(
                      icon: IconPath.calendar,
                      iconSize: 24,
                    ),
                    const SizedBox(width: 4),
                    CustomTextWidget(
                      requestCommercialLicenseDetails.creationDate ??"",
                      textStyle: AppStyle.dateTextStyle,
                    ),
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
                              requestCommercialLicenseDetails.requestStatus?.name??"",
                              textStyle: AppStyle.tagTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),


                SubmitterInfoWidget(
                  submitterName: requestCommercialLicenseDetails.submitter?.name,submitterType:requestCommercialLicenseDetails.submitterType?.name,CRNumber: requestCommercialLicenseDetails.owner?.crNumber,
                ),

                ExpandableCard(
                  title: 'request_data'.tr(),
                  icon: IconPath.editIcon,
                  isExpandedByDefault: true,
                  children: [
                    CardParameter(
                      title: 'request_no'.tr(),
                      value:
                      requestCommercialLicenseDetails.requestId.toString(),
                    ),
                    CardParameter(
                      title: 'request_status'.tr(),
                      value:
                      requestCommercialLicenseDetails.requestStatus?.name??"",
                    ),

                    CardParameter(
                      title: 'objection_date'.tr(),
                      value:
                      requestCommercialLicenseDetails.creationDate??"",
                    ),

                    CardParameter(
                      title: 'request_type'.tr(),
                      value: requestCommercialLicenseDetails.requestType?.name??"",
                    ),

                    
                  ],
                ),

                ExpandableCard(
                title: 'locationInfo'.tr(),
        icon: IconPath.qrLocationIcon,
        children: [
        const SizedBox(height: 16),
        requestCommercialLicenseDetails.location?.latitude != null && requestCommercialLicenseDetails.location?.longitude != null
        ? SizedBox(
        height: 250,
        child:
        UrbiMapSection(
        readOnly: true,
        currentUserLocation:LatLng(latitude: double.parse(requestCommercialLicenseDetails.location!.latitude!),longitude: double.parse(requestCommercialLicenseDetails.location!.longitude!)),
        incidentLocation:LatLng(latitude: double.parse(requestCommercialLicenseDetails.location!.latitude!),longitude: double.parse(requestCommercialLicenseDetails.location!.longitude!)),
        onCameraIdle: (bool isIdle) {
        mapController?.moveCamera(
        CameraPositionMessage(
        point: GeoPointMessage(latitude:  double.parse(requestCommercialLicenseDetails.location!.latitude!), longitude: double.parse(requestCommercialLicenseDetails.location!.longitude!)),
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
          
        )
            : const SizedBox(),
          CardParameter(
            title: 'municipalityName'.tr(),
            value:
            requestCommercialLicenseDetails.location?.municipality?.name??"",
          ),

          CardParameter(
            title: 'subMunicipalityName'.tr(),
            value:
            requestCommercialLicenseDetails.location?.subMunicipality?.name??"",
          ),


          CardParameter(
            title: 'district'.tr(),
            value:
            requestCommercialLicenseDetails.location?.district?.name??"",
          ),

          CardParameter(
            title: 'street'.tr(),
            value:
            requestCommercialLicenseDetails.location?.street?.name??"",
          ),
        ],
        ),

                MainActivityInfoWidget(activityInfo: requestCommercialLicenseDetails.activities,),
                ExtraActivitiesInfoWidget(additionalActivities:requestCommercialLicenseDetails.activities?.addedActivities),
                ExpandableCard(
                  title: 'municipalAdvisorRequirementsTitle'.tr(),
                  icon: IconPath.notificationStatusIcon,
                children: [
                  ConclusionWidget(),
                ],
                ),

                ExpandableCard(
                  title: 'responses_request'.tr(),
                  icon: IconPath.notificationStatusIcon,
                  children: [
                    requestCommercialLicenseDetails.notes != null
                        ? ListView.builder(
                      itemCount: requestCommercialLicenseDetails
                          .notes!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        RequestNotesInfo requestNotesInfo =
                        requestCommercialLicenseDetails
                            .notes![index];
                        return Card(
                          color: AppColor.primary100Light,
                          margin: const EdgeInsets.only(top: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CustomTextWidget(
                                      ('notes_').tr(),
                                      fontSize: 12,
                                      fontColor: AppColor.primary900Light,
                                      fontWeight: AppFontWeight.bold,
                                      textAlign: TextAlign.center,
                                    ),
                                    const Spacer(),
                                    CustomTextWidget(
                                      requestNotesInfo.date
                                          .toWrittenDate(),
                                      fontSize: 12,
                                      fontColor:
                                      AppColor.blackModern500Light,
                                      fontWeight: AppFontWeight.bold,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                CustomTextWidget(
                                  requestNotesInfo.note,
                                  fontSize: 12,
                                  maxLines: 100,
                                  fontColor: AppColor.blackModern600Light,
                                  fontWeight: AppFontWeight.regular,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                        : const SizedBox()
                  ],
                ),
                /////////////////////////////////////////////////
                const SizedBox(height: 24),
              ],
            ),
          );
        }
        return Center(
          child: ReloadWidget(
            onTab: () {
              bloc.getCommercialRequestData();
            },
          ),
        );
      },
    );
  }

// List<AttachmentData> getNewModelList(List<AttachmentModel> attachments) {
//   return attachments
//       .map(
//         (attachment) => AttachmentData(
//           id: attachment.id.toString(),
//           memo: "attachment",
//           title: attachment.name ?? '',
//           fileName: attachment.fileName ?? attachment.name,
//           filePath: attachment.attachUrl,
//           isRequired: attachment.isMandatory ?? false,
//           isUploaded: attachment.updatable ?? false,
//         ),
//       )
//       .toList();
// }
}
