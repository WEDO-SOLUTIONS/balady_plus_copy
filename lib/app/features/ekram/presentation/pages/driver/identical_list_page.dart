import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import 'package:balady_plus/app/features/ekram/presentation/pages/driver/request_trips.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/services/local/location_service.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';
import '../../blocs/driver_identical_bloc/identical_list_bloc.dart';

class IdenticalListPage extends StatefulWidget {
  const IdenticalListPage({Key? key}) : super(key: key);

  @override
  State<IdenticalListPage> createState() =>
      _IdenticalListPageState();
}

class _IdenticalListPageState
    extends State<IdenticalListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.detailsServiceFuneralCarDriver);


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
   // sl<EkramLocationService>().stop();


  }

  @override
  Widget build(BuildContext context) {

    TransportRequestItemModel params =
    ModalRoute.of(context)!.settings.arguments as TransportRequestItemModel;

    return BlocProvider.value(
      value: sl<IdenticalListBloc>(),

      child: BlocConsumer<IdenticalListBloc, IdenticalListState>(
        listener: (cont, state) {

          if (state.status == BlocStatus.failure) {
            //   showError(state.errorMessage ?? "");
          }
        },
        builder: (ctx, state) => WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop(state.isCompleted);
            return Future<bool>.value(true);
          },
          child: Scaffold(
            backgroundColor: AppColor.white2,
            appBar: DetailsHeader(
              titleWidget: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    'requests_transporting_deceased'.tr(),
                    fontSize: 20,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern700Light,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  // CustomTextWidget(
                  //   "#${params.requestId}",
                  //   fontSize: 14,
                  //   maxLines: 1,
                  //   textOverflow: TextOverflow.ellipsis,
                  //   fontWeight: AppFontWeight.medium,
                  //   fontColor: AppColor.blackModern700Light,
                  // ),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 16.0,right: 16,left: 16,bottom: 30),
              child:
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.calendarIcon,
                                        width: 24,
                                        height: 24,
                                      ),
                                      CustomHorizontalSpace(width: 8),
                                      CustomTextWidget(
                                        params.requestDate ?? "",
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
                              CustomVerticalSpace(height: 10),
                              CustomTextWidget(
                                "deceasedData".tr(),
                                fontSize: 20.0,
                                fontWeight: AppFontWeight.bold,
                                fontColor: AppColor.blackModern700Light,
                                maxLines: 1,
                                textOverflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount:
                                state.details?.length ??
                                    0,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return

                                    ExpandableCard(
                                        title: "${("cemetry_deceassed_info").tr()} ${index+1}",
                                        icon: null,
                                        children:
                                        [
                                          IdenticalDeceasedCardWidget(
                                            item: state.details![index],
                                            isDriver: state.isDriver,
                                            showLogTrip: state.details![index].requestId != 5 &&
                                                state.details![index].requestStatusId != 6,),
                                        ]);
                                },
                              ),



                              if (state.status == BlocStatus.loading)
                                const CustomLoadingWidget(),
                              Constants.verticalSpaceSmall,
                            ],
                          ),
                        ),
                      ),
                      ElevatedButtonWidget.primaryCustom(
                        onPressed: () {
                         var bloc = AddTripBloc(
                              deleteTrip: sl(),
                              completeTrip: sl(),
                              getTrips: sl(),
                              editTrip: sl(),
                              getTripStations: sl(),
                              model: params,
                              context: context,
                              addTrip: sl(),
                              updateDriverLocation: sl());

                          NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => RequestTrips(
                              bloc: bloc,),),);

                         bloc.add(GetTripsEvent());

                        },
                        text: ('startTrip').tr(),
                      ),
                    ],
                  ),



            ),
          ),
        ),
      ),
    );
  }
}
