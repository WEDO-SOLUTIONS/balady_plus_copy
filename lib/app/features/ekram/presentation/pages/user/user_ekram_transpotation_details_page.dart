import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
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

    params.requestId = 4617335922;
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
       ..add(GetTripsEvent());

    extraDataBloc=  ExtraDataBloc(getGhuslEmployees: sl(),getDeceasedAttachment: sl(),uploadAttachment: sl(), editAdditionalData: sl(),deleteAttachment: sl());
    extraDataBloc!.add(GetDeceasedAttachmentEvent(requestId: params.requestId!));


    return BlocProvider(
      create: (context) => EkramRequestTransportationBloc(
          getCities: sl(),
          getRequestDetails: sl(),
          getHospitals: sl(),
          getNationalities: sl(),
          applyDeceasedTransport: sl(),
          getCemeteryTypesLookUp: sl(),
      )..add(getRequestDetailsEvent(requestId: "${params.requestId}")),//

      child: BlocConsumer<EkramRequestTransportationBloc, EkramRequestTransportationState>(
          listener: (context, state) {

            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
        builder: (context, state){return Scaffold(
          backgroundColor: AppColor.white2,
          appBar: DetailsHeader(
            titleWidget: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTextWidget(
                  "requests_transporting_deceased".tr(),
                  fontSize: 20,
                  maxLines: 1,
                  textOverflow: TextOverflow.ellipsis,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern700Light,
                ),

              ],
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
                        title: params.requestStatusName ?? "",
                        backgroundColor: AppColor.secondary100Light,
                      )
                    ],
                  ),
                  Constants.verticalSpaceSmall,
                  DeceasedInfoWidget_new(item:state.requestDetailsModel?.deceasedInfo),
                  SizedBox(height: 20,),
                   ApplicantInfoWidget(item:state.requestDetailsModel?.mainInfo),
                   SizedBox(height: 20,),
                   BurialInfoWidget(deathInfo:state.requestDetailsModel?.deathInfo ,burialInfo: state.requestDetailsModel?.burialInfo,cemeteryData: state.requestDetailsModel?.cemeteryData,transportInfo: state.requestDetailsModel?.transportInfo,),
                  SizedBox(height: 20,),
                  AttachmentInfoWidget(bloc:extraDataBloc, requestId: params.requestId!,model: state.requestDetailsModel?.locationInfo,),
                  SizedBox(height: 20,),
                  DriversInfoWidget(bloc: bloc,),



                  SizedBox(height: 30,)
                  // TransferInfo
                  // DriversInfo
                  //  DriversInfoWidget(),
                  // ApplicantInfo
                  //  ApplicantInfoWidget(),
                  // DeceasedInfo
                  //
                  // BurialInfo
                  //  ,

                ],
              ),
            ),
          ),
        );
          }

        ),
    );
  }
}
