
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';

import '../../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';

import '../../../../_shared_feature_/presentation/widgets/details_header.dart';

import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';

import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

import '../../../data/model/driver/transport_request_item_model.dart';
import '../../../data/model/driver/trip_stations.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';
import '../../widgets/driver/custom_dropdown_dialog.dart';
import '../../widgets/driver/trip_datetime_widget.dart';



class AddCustomTripPath extends StatelessWidget {
  final AddTripBloc bloc;

   AddCustomTripPath({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bloc.add(GetTripsStationEvent());

    return BlocProvider.value(
      value: bloc,
      child:
      BlocConsumer<AddTripBloc, AddTripState>(
        listener: (context, state) {
          if (bloc.state.status == BlocStatus.failure) {

            //bloc.add(ClearErrorMsgEvent());
            // CommonFunctions.showError(bloc.state.errorMessage ?? "");
          }
        },
        builder: (context, state) {

          return  Scaffold(

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
                          DialogHeader(
                            title: "addnewPath".tr(),
                          ),


                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomVerticalSpace(height: 20),

                              CustomDropDownDialog(
                                isDisbaled:true,
                                items: bloc.state.lstTripStation ?? [],
                                selectedValue: bloc.state.addTripPath?.startupInfo?.typeName,
                                onChangeType: (var item) {

                                  bloc.add(setCustomPathDataEvent(item: item,isStartupInfo: true));
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
                                subTitle: bloc.state.addTripPath?.startupInfo?.cityName  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),

                              CustomVerticalSpace(height: 10),
                              bloc.state.addTripPath?.startupInfo?.isEditable()==false?
                              ReadOnlyField(
                                title: "currentTripStationName".tr(),
                                subTitle: bloc.state.addTripPath?.startupInfo?.name  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ):
                              CustomTextFieldWidget(
                                  enabled: true,
                                  label: "currentTripStationName".tr(),
                                  hintText: "currentTripStationName".tr(),
                                  textFieldHeight: 55,
                                  initialValue:   bloc.state.addTripPath?.startupInfo?.name  ?? "",
                                  onChanged: (String? text) {
                                    if (text != null) {

                                      bloc.add(setCustomPathDataEvent(item: TripStations(name: text),isStartupInfo: true));

                                    }
                                  },
                                  onValidate: (String? value) {
                                    return null;
                                  }),


                              CustomVerticalSpace(height: 10),

                              TripDateTimeWidget(
                                title: "currentTripStationArrivalTime".tr(),
                                isEditable: bloc.state.addTripPath != null ? true :false,
                                date:bloc.state.addTripPath?.startupInfo?.date != null? CommonFunctions.getFormattedDateEkram(bloc.state.addTripPath?.startupInfo?.date):null,
                                time: bloc.state.addTripPath?.startupInfo?.time != null? CommonFunctions.getFormattedTimeEkram(bloc.state.addTripPath?.startupInfo?.time):null,

                                onDateCallback: (String? date){

                                  if(date != null)
                                  {

                                    bloc.add(setCustomPathDataEvent(item: TripStations(date: date),isStartupInfo: true));
                                  }
                                },
                                onTimeCallback: (String? time){

                                  if(time != null)
                                  {

                                    DateTime tempTime = DateFormat("HH:mm").parse(time!);
                                    String strTime = DateFormat("HH:mm")
                                        .format(tempTime)
                                        .toString();
                                    bloc.add(setCustomPathDataEvent(item: TripStations(time: strTime),isStartupInfo: true));
                                  }
                                },

                              ),




                              CustomVerticalSpace(height: 10),


                              CustomDropDownDialog(
                                items:  bloc.state.lstTripStation??[],

                               // items: bloc.state.addTripPath?.startupInfo != null ? bloc.state.lstTripStation:[],
                                selectedValue: bloc.state.addTripPath?.arrivalInfo?.typeName,
                                onChangeType: (var item) {
                                  bloc.add(setCustomPathDataEvent(item: item,isStartupInfo: false));
                                },
                                onEmptyList: () async {
                                  bloc.add(GetTripsStationEvent());
                                },
                                label: "nextTripStationType".tr(),
                                hint: "nextTripStationType".tr(),
                              ),


                              ReadOnlyField(
                                title: "nextTripCity".tr(),
                                subTitle: bloc.state.addTripPath?.arrivalInfo?.cityName  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),

                              CustomVerticalSpace(height: 10),
                              bloc.state.addTripPath?.arrivalInfo?.isEditable()==false?
                              ReadOnlyField(
                                title: "nextTripStationName".tr(),
                                subTitle: bloc.state.addTripPath?.arrivalInfo?.name  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ):
                              CustomTextFieldWidget(
                                  enabled: true,
                                  label: "currentTripStationName".tr(),
                                  hintText: "currentTripStationName".tr(),
                                  textFieldHeight: 55,
                                  initialValue:  bloc.state.addTripPath?.arrivalInfo?.name  ?? "",
                                  onChanged: (String? text) {
                                    if (text != null) {

                                      bloc.add(setCustomPathDataEvent(item: TripStations(name: text),isStartupInfo: false));

                                    }
                                  },
                                  onValidate: (String? value) {
                                    return null;
                                  }),


                              CustomVerticalSpace(height: 10),

                              TripDateTimeWidget(
                                title: "nextTripStationArrivalTime".tr(),
                                isEditable: bloc.state.addTripPath != null ? true :false,
                                date:bloc.state.addTripPath?.arrivalInfo?.date != null? CommonFunctions.getFormattedDateEkram(bloc.state.addTripPath?.arrivalInfo?.date):null,
                                time: bloc.state.addTripPath?.arrivalInfo?.time != null? CommonFunctions.getFormattedTimeEkram(bloc.state.addTripPath?.arrivalInfo?.time):null,



                                onDateCallback: (String? date){

                                  if(date != null)
                                  {

                                    bloc.add(setCustomPathDataEvent(item: TripStations(date: date),isStartupInfo: false));
                                  }
                                },
                                onTimeCallback: (String? time){

                                  if(time != null)
                                  {

                                    DateTime tempTime = DateFormat("HH:mm").parse(time);
                                    String strTime = DateFormat("HH:mm")
                                        .format(tempTime)
                                        .toString();
                                    bloc.add(setCustomPathDataEvent(item: TripStations(time: strTime),isStartupInfo: false));
                                  }
                                },

                              ),

                              CustomVerticalSpace(height: 20),


                            ],
                          ),
                          if (bloc.state.status == BlocStatus.loading) const CustomLoadingWidget(),

                          if (bloc.state.status == BlocStatus.retry)
                            ReloadWidget(
                              onTab: () {
                                bloc.add(
                                    GetTripsEvent());
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButtonWidget.primaryCustom(
                    onPressed: () {
                      bloc.add(AddCustomPathEvent());

                    },
                    text: ('addnewPath').tr(),
                  ),

                ],
              ),
            ),
          );

        },
      )



    );

  }
}

