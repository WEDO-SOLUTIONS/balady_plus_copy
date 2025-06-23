import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/models/commercial_license_details_model.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';


import '../../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../../features/_shared_feature_/balady_features/widgets/UrbiMap/UrbiMapSection.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/calendar/presentation/pages/calendar_details_page.dart';
import '../../../../data/models/initialApproval/request_details_model.dart';
import '../../bloc/commercial_license_details_bloc.dart';
import '../../domain/entity/request_note_info.dart';
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

        RequestDetailsModel? requestDetails = state.requestDetails;
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
                      requestDetails?.creationDate ??"",
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
                              requestDetails?.requestStatus?.name??"",
                              textStyle: AppStyle.tagTextStyle,
                            ),
                          ],

                        ),
                      ),
                    ),
                  ],
                ),
                SubmitterInfoWidget(
                  submitterName: requestDetails?.submitter?.name,submitterType:requestDetails?.submitterType?.name,CRNumber: requestDetails?.owner?.crNumber,
                ),

                ExpandableCard(
                  title: 'request_data'.tr(),
                  icon: IconPath.editIcon,
                  isExpandedByDefault: true,
                  children: [
                    CardParameter(
                      title: 'request_no'.tr(),
                      value:
                      requestDetails?.requestId.toString()??"",
                    ),
                    CardParameter(
                      title: 'request_status'.tr(),
                      value:
                      requestDetails?.requestStatus?.name??"",
                    ),

                    requestDetails?.requestStatus?.id == 362?
                    CardParameter(
                      title: 'remainingValidityPeriod'.tr(),
                      value: "${requestDetails?.remainingValidityPeriod} ${"lbl_day".tr()}",
                    ):Container(),

                    CardParameter(
                      title: 'municipalAdvisorLicenseYears'.tr(),
                      value:
                      requestDetails?.activities?.mainActivity?.maxYears.toString() ??"",
                    ),


                    requestDetails?.rejectionInfo != null && requestDetails?.rejectionInfo?.rejectionReason != null?
                    CardParameter(
                      title: 'rejectionReason'.tr(),
                      value: requestDetails?.rejectionInfo?.rejectionReason??"",
                      lines: 4,
                    ):Container(),

                    CardParameter(
                      title: 'objection_date'.tr(),
                      value:
                      requestDetails?.creationDate??"",
                    ),

                    CardParameter(
                      title: 'request_type'.tr(),
                      value: requestDetails?.requestType?.name??"",
                    ),

                    CardParameter(
                      title: 'approvalType'.tr(),
                      value: requestDetails?.workFlow?.name??"",
                    ),

                    if(requestDetails?.requestStatus?.id == 12)
                      NotesWidget(notes: [requestDetails?.objectionMessage],marginBottom: 0,),
                  ],
                ),

                ExpandableCard(
                title: 'locationInfo'.tr(),
        icon: IconPath.qrLocationIcon,
        children: [
        const SizedBox(height: 16),
        requestDetails?.location?.latitude != null && requestDetails?.location?.longitude != null
        ? SizedBox(
        height: 250,
        child:
        UrbiMapSection(
        readOnly: true,
        currentUserLocation:LatLng(latitude: double.parse(requestDetails!.location!.latitude!),longitude: double.parse(requestDetails.location!.longitude!)),
        incidentLocation:LatLng(latitude: double.parse(requestDetails.location!.latitude!),longitude: double.parse(requestDetails.location!.longitude!)),
        onCameraIdle: (bool isIdle) {
        mapController?.moveCamera(
        CameraPositionMessage(
        point: GeoPointMessage(latitude:  double.parse(requestDetails.location!.latitude!), longitude: double.parse(requestDetails.location!.longitude!)),
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
            requestDetails?.location?.municipality?.name??"",
          ),

          CardParameter(
            title: 'subMunicipalityName'.tr(),
            value:
            requestDetails?.location?.subMunicipality?.name??"",
          ),


          CardParameter(
            title: 'district'.tr(),
            value:
            requestDetails?.location?.district?.name??"",
          ),

          CardParameter(
            title: 'street'.tr(),
            value:
            requestDetails?.location?.street?.name??"",
          ),
        ],
        ),
                MainActivityInfoWidget(activityInfo: requestDetails?.activities,),
                ExtraActivitiesInfoWidget(additionalActivities:requestDetails?.activities?.addedActivities),
                ExpandableCard(
                  title: 'municipalAdvisorRequirementsTitle'.tr(),
                  icon: IconPath.notificationStatusIcon,
                children: [
                  ConclusionWidget(),
                ],
                ),

                ExpandableCard(
                  title: 'requestNotes'.tr(),
                  icon: IconPath.notificationStatusIcon,
                  children: [
                    requestDetails?.notes != null
                        ? ListView.builder(
                      itemCount: requestDetails?.notes?.length??0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        RequestNoteInfo? requestNotesInfo =
                        requestDetails?.notes![index];
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
                                      requestNotesInfo?.date??"",
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
                                  requestNotesInfo?.note??"",
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

                if(requestDetails?.isRelatedToCommercialRequest==true)
                EnhancedCustomElevatedButtonWidget(
                  btnColor: AppColor.primary900Light,
                  btnTextColor:  AppColor.white,
                  btnPressed: (){

                    NavigationService.navigatorKey.currentState!.pushNamed(
                        RouteName.requestCommercialLicenseDetails
                        ,
                        arguments: {
                        "requestNumber": requestDetails?.relatedCommercialRequestId.toString(),
                        },
                    );

                  },
                  btnRadius: 8,
                  btnText:"relatedCommercialRequestDetails".tr(),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnHeight: 56,
                ),
                if (state.status == BlocStatus.loading)
                  Center(child: CustomCircularLoadingWidget())



              ],
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
