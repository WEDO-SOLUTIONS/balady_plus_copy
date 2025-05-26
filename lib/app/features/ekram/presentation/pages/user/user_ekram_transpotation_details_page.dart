import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';
import '../../blocs/driver_identical_bloc/identical_list_bloc.dart';
import '../../widgets/transportation_details_widget/body_sections/attachment_info_widget.dart';

class UsersEkramTransportationDetailsPage extends StatefulWidget {
  const UsersEkramTransportationDetailsPage({Key? key}) : super(key: key);

  @override
  State<UsersEkramTransportationDetailsPage> createState() =>
      _UsersEkramTransportationDetailsPageState();
}

class _UsersEkramTransportationDetailsPageState
    extends State<UsersEkramTransportationDetailsPage> {
  AddTripBloc? bloc;
  ExtraDataBloc? extraDataBloc;
  EkramRequestTransportationBloc? detailsBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.detailsServiceBodyTransportation);
  }

  @override
  Widget build(BuildContext context) {
    TransportRequestItemModel params =
        ModalRoute.of(context)!.settings.arguments as TransportRequestItemModel;

    bloc ??= AddTripBloc(
        deleteTrip: sl(),
        completeTrip: sl(),
        getTrips: sl(),
        editTrip: sl(),
        getTripStations: sl(),
        model: params,
        context: context,
        addTrip: sl(),
        updateDriverLocation: sl())
      ..add(const GetTripsEvent());

    extraDataBloc = ExtraDataBloc(
        getGhuslEmployees: sl(),
        getDeceasedAttachment: sl(),
        uploadAttachment: sl(),
        editAdditionalData: sl(),
        deleteAttachment: sl());
    extraDataBloc!
        .add(GetDeceasedAttachmentEvent(requestId: params.requestId!));

    return BlocProvider(
      create: (context) {
        detailsBloc = EkramRequestTransportationBloc(
          getCities: sl(),
          getRequestDetails: sl(),
          getHospitals: sl(),
          getNationalities: sl(),
          applyDeceasedTransport: sl(),
          getCemeteryTypesLookUp: sl(),
        );
        detailsBloc?.add(getRequestDetailsEvent(requestId: params.requestId!));

        return detailsBloc!;
      }, //

      child: BlocConsumer<EkramRequestTransportationBloc,
          EkramRequestTransportationState>(listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          CommonFunctions.showError(state.errorMessage ?? "");
        }
      }, builder: (context, state) {


        return Scaffold(
          backgroundColor: AppColor.white2,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0), // here the desired height
            child: AppBar(
              backgroundColor: AppColor.scaffoldBackground,
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              title: Text(
                "requests_transporting_deceased".tr(),
                maxLines: 3,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CustomTextWidget(
                            "${"posters_permit_request_id".tr()} ${params.requestId}",
                            fontColor: AppColor.blackModern500Light,
                            fontSize: 12,
                            fontWeight: AppFontWeight.bold,
                          )
                        ],
                      ),
                      HomeTag(
                        title: state.requestDetailsModel?.requestStatusName??"",
                        backgroundColor: AppColor.secondary100Light,
                      ),


                    ],
                  ),

                  Constants.verticalSpaceSmall,
                  state.requestDetailsModel?.notes != null|| state.requestDetailsModel?.cancelReason != null? Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: new BoxDecoration(
                        color: AppColor.yellowStarRating.withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
                    child: Column(children: [
                      state.requestDetailsModel?.cancelReason != null && state.requestDetailsModel?.cancelReason?.isNotEmpty==true?
                      EkramHeaderAndDescWidget_With_Background(
                        title: ('reason_cancellation').tr(),
                        details:  state.requestDetailsModel?.requestStatusId == 6 ? state.requestDetailsModel?.cancelReason??"":"",

                      ):Container(),
                      Constants.verticalSpaceSmall,

                      state.requestDetailsModel?.notes != null && state.requestDetailsModel?.notes?.isNotEmpty==true?
                      EkramHeaderAndDescWidget_With_Background(
                        title: ('note').tr(),
                        details: state.requestDetailsModel?.notes??"",

                      ):Container(),

                    ],),

                  ):Container(),



                  Constants.verticalSpaceSmall,
                  DeceasedInfoWidget_new(
                    item: state.requestDetailsModel?.deceasedInfo,
                  ),
                  const SizedBox(height: 20),
                  ApplicantInfoWidget(
                    item: state.requestDetailsModel?.mainInfo,
                  ),
                  const SizedBox(height: 20),
                  BurialInfoWidget(
                    deathInfo: state.requestDetailsModel?.deathInfo,
                    burialInfo: state.requestDetailsModel?.burialInfo,
                    cemeteryData: state.requestDetailsModel?.cemeteryData,
                    transportInfo: state.requestDetailsModel?.transportInfo,
                  ),
                  const SizedBox(height: 20),
                  AttachmentInfoWidget(
                    bloc: extraDataBloc,
                    requestId: params.requestId!,
                    model: state.requestDetailsModel?.locationInfo,
                    requestStatusId: state.requestDetailsModel?.requestStatusId,
                    detailsBloc: detailsBloc,
                  ),
                  const SizedBox(height: 20),
                  DriversInfoWidget(bloc: bloc),
                  const SizedBox(height: 20),
                  state.requestDetailsModel?.requestStatusId == 352
                      ? ElevatedButtonWidget.primaryCustom(
                          height: 40,
                          onPressed: () {
                            detailsBloc?.add(
                              getCurrentTrackLocationEvent(
                                requestId: params.requestId!,
                              ),
                            );
                          },
                          text: "trafficTracking".tr(),
                        )
                      : Container(),
                  const SizedBox(height: 18),
                  state.requestDetailsModel?.requestStatusId == 1
                      ? ElevatedButtonWidget.primaryCustom(
                          height: 40,
                          onPressed: () {
                            NavigationService.navigatorKey.currentState!
                                .pushNamed(
                              RouteName.ekramRequestTransportationScreen,
                              arguments: state.requestDetailsModel,
                            );
                          },
                          text: "compliance_cancel_request_confirm".tr(),
                        )
                      : Container(),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
