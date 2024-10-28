
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';

import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';

import '../../../../_shared_feature_/presentation/widgets/details_header.dart';

import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';

import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

import '../../../data/model/driver/transport_request_item_model.dart';
import '../../../data/model/driver/trip_stations.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';
import '../../widgets/driver/custom_dropdown_dialog.dart';
import '../../widgets/driver/trip_datetime_widget.dart';



class AddNewTripPath extends StatelessWidget {
  final TransportRequestItemModel model;

   AddNewTripPath({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTripBloc(
          getTripStations: sl(),
          editTrip: sl(),
          getTrips: sl(),
          model: model,
          addTrip: sl(),
          updateDriverLocation: sl())..add(GetTripsStationEvent()),
      child: BlocConsumer<AddTripBloc, AddTripState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {

            context.read<AddTripBloc>().add(ClearErrorMsgEvent());
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {

          return Scaffold(
            appBar:
            DetailsHeader(
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
                ],
              ),
            ),
            body:
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomVerticalSpace(height: 10),

                              CustomDropDownDialog(
                                items: state.lstTripStation ?? [],
                                selectedValue: state.addTripPath?.startupInfo?.typeName,
                          onChangeType: (TripStations? item) {
                          context
                              .read<AddTripBloc>()
                              .add(setNewPathData(item: item,isStartupInfo: true));
                        },
                        onEmptyList: () async {
                          // return context
                          //     .read<AddTripBloc>()
                          //     .getLanuduriesLookUp();
                        },
                        label: "currentTripStationType".tr(),
                        hint: "currentTripStationType".tr(),
                      ),


                              ReadOnlyField(
                                title: "currentTripCity".tr(),
                                subTitle: state.addTripPath?.startupInfo?.cityName  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),

                              CustomVerticalSpace(height: 10),
                              ReadOnlyField(
                                title: "currentTripStationName".tr(),
                                subTitle: state.addTripPath?.startupInfo?.name  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),


                              CustomVerticalSpace(height: 10),

                              TripDateTimeWidget(
                                title: "currentTripStationArrivalTime".tr(),
                                isEditable: state.addTripPath != null ? true :false,
                                date: state.addTripPath?.startupInfo?.date,
                                time: state.addTripPath?.startupInfo?.time,
                                onDateCallback: (String? date){

                                  if(date != null)
                                    {

                                      context.read<AddTripBloc>().add(setNewPathData(item: TripStations(date: date),isStartupInfo: true));
                                     }
                                },
                                onTimeCallback: (String? time){

                                  if(time != null)
                                  {


                                     context.read<AddTripBloc>().add(setNewPathData(item: TripStations(time: time),isStartupInfo: true));
                                  }
                                },

                              ),




                              CustomVerticalSpace(height: 10),


                              CustomDropDownDialog(
                                items: state.addTripPath?.startupInfo != null ? state.lstTripStation!:[],
                                selectedValue: state.addTripPath?.arrivalInfo?.typeName,
                                onChangeType: (TripStations? item) {
                                  context
                                      .read<AddTripBloc>()
                                      .add(setNewPathData(item: item,isStartupInfo: false));
                                },
                                onEmptyList: () async {
                                  // return context
                                  //     .read<AddTripBloc>()
                                  //     .getLanuduriesLookUp();
                                },
                                label: "nextTripStationType".tr(),
                                hint: "nextTripStationType".tr(),
                              ),


                              ReadOnlyField(
                                title: "nextTripCity".tr(),
                                subTitle: state.addTripPath?.arrivalInfo?.cityName  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),

                              CustomVerticalSpace(height: 10),
                              ReadOnlyField(
                                title: "nextTripStationName".tr(),
                                subTitle: state.addTripPath?.arrivalInfo?.name  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),


                              CustomVerticalSpace(height: 10),

                              TripDateTimeWidget(
                                title: "nextTripStationArrivalTime".tr(),
                                isEditable: state.addTripPath != null ? true :false,
                                date: state.addTripPath?.arrivalInfo?.date,
                                time: state.addTripPath?.arrivalInfo?.time,
                                onDateCallback: (String? date){

                                  if(date != null)
                                  {

                                    context.read<AddTripBloc>().add(setNewPathData(item: TripStations(date: date),isStartupInfo: false));
                                  }
                                },
                                onTimeCallback: (String? time){

                                  if(time != null)
                                  {


                                    context.read<AddTripBloc>().add(setNewPathData(item: TripStations(time: time),isStartupInfo: false));
                                  }
                                },

                              ),


                            ],
                          ),

                          if (state.status == BlocStatus.loading) const CustomLoadingWidget(),

                          if (state.status == BlocStatus.retry)
                            ReloadWidget(
                              onTab: () {
                                context.read<AddTripBloc>().add(
                                    GetTripsEvent());
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButtonWidget.primaryCustom(
                    onPressed: () {
                      // context.read<AddTripBloc>().add(
                      //     ());

                    },
                    text: ('addnewPath').tr(),
                  ),

                ],
              ),
            ),
          );


        },
      ),
    );
  }
}

