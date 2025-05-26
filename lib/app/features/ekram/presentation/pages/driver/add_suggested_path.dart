
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
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';

import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

import '../../../data/model/driver/transport_request_item_model.dart';
import '../../../data/model/driver/trip_details_model.dart';

import '../../blocs/driver_add_trip/add_trip_bloc.dart';


import '../../widgets/driver/trip_body_widget.dart';
import '../../widgets/driver/trip_datetime_widget.dart';
import 'add_custom_trip_path.dart';


class AddSuggestedPath extends StatefulWidget {
  final TripDetailsModel trip ;
  AddTripBloc bloc;
 AddSuggestedPath(
      {Key? key,

        required this.trip,
        required this.bloc,
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddSuggestedPath();
  }
}





  class _AddSuggestedPath extends State<AddSuggestedPath> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        body:
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
              children:
              [
                SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DialogHeader(
                          title: "addnewPath".tr(),
                        ),


                        CustomVerticalSpace(height: 20),
                        ReadOnlyField(
                          title: "currentTripCity".tr(),
                          subTitle:widget.trip.startupInfo?.cityName ?? "",
                          subTitleColor:AppColor.grey1000.withOpacity(0.5),
                          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                        ),
                        CustomVerticalSpace(height: 10),
                        ReadOnlyField(
                          title: "currentTripStationType".tr(),
                          subTitle:widget.trip.startupInfo?.typeName  ?? "",
                          subTitleColor:AppColor.grey1000.withOpacity(0.5),
                          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                        ),


                        CustomVerticalSpace(height: 10),
                        widget.trip.startupInfo?.isEditable()==false?
                        ReadOnlyField(
                          title: "currentTripStationName".tr(),
                          subTitle:widget.trip.startupInfo?.name  ?? "",
                          subTitleColor:AppColor.grey1000.withOpacity(0.5),
                          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                        ):
                        CustomTextFieldWidget(
                            enabled: true,
                            label: "currentTripStationName".tr(),
                            hintText: "currentTripStationName".tr(),
                            textFieldHeight: 55,
                            initialValue:  widget.trip.startupInfo?.name??"",
                            onChanged: (String? text) {
                              if (text != null) {
                                widget.trip.startupInfo?.name = text;
                              }
                            },
                            onValidate: (String? value) {
                              return null;
                            }),


                        CustomVerticalSpace(height: 10),

                        TripDateTimeWidget(
                          isEditable:true,
                          title: "currentTripStationArrivalTime".tr(),
                          date:widget.trip.startupInfo?.date != null ?CommonFunctions.getFormattedDateEkram(
                              widget.trip.startupInfo?.date):null,
                          time:widget.trip.startupInfo?.time != null ?CommonFunctions.getFormattedTimeEkram(
                              widget.trip.startupInfo?.time):null,
                          onDateCallback: (String? date){

                            if(date != null)
                            {

                              setState(() {
                                widget.trip.startupInfo?.date = date;
                              });

                              // var x =  context.read<AddTripBloc>();
                              // context.read<AddTripBloc>().add(EditTripPathData(item:widget.widget.bloc.state.model));

                            }
                          },
                          onTimeCallback: (String? time){

                            if(time != null)
                            {

                              DateTime tempTime = DateFormat("HH:mm").parse(time);
                              String strTime = DateFormat("HH:mm")
                                  .format(tempTime)
                                  .toString();
                              setState(() {
                                widget.trip.startupInfo?.time = strTime;
                              });
                              //widget.trip.startupInfo?.time= time;
                              // context.read<AddTripBloc>().add(EditTripPathData(item:widget.widget.bloc.state.model));
                            }
                          },

                        ),

                        CustomVerticalSpace(height: 15),


                        InkWell(
                          onTap: () {
                            if (widget.trip.startupInfo?.location?.x != null &&widget.trip.startupInfo?.location?.y != null ) {
                              CommonFunctions.openMap(
                                  double.parse(widget.trip.startupInfo!.location!.y!),
                                  double.parse(widget.trip.startupInfo!.location!.x!));
                            }
                            else
                            {
                              CommonFunctions.showError("noData".tr());
                            }
                            // else if(enableEdit == true)
                            //   {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //         builder: (context) => LocationSelectorScreen(callback: updateLocation,isCurrentStation:true)));
                            //
                            //   }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration:  BoxDecoration(color: Colors.transparent, border: Border.all(color: AppColor.blackModern300Light, width: 1), borderRadius: BorderRadius.circular(6)),
                            //:BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                CustomTextWidget(
                                  ("ekram_current_step_location").tr(),
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.medium,
                                  fontColor: AppColor.black,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),




                        CustomVerticalSpace(height: 20),
                        ReadOnlyField(
                          title: "nextTripCity".tr(),
                          subTitle:widget.trip.arrivalInfo?.cityName ?? "",
                          subTitleColor:AppColor.grey1000.withOpacity(0.5),
                          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                        ),
                        CustomVerticalSpace(height: 10),
                      ReadOnlyField(
                          title: "nextTripStationType".tr(),
                          subTitle:widget.trip.arrivalInfo?.typeName  ?? "",
                          subTitleColor:AppColor.grey1000.withOpacity(0.5),
                          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                        ),


                        CustomVerticalSpace(height: 10),
                        widget.trip.startupInfo?.isEditable()==false?  ReadOnlyField(
                          title: "nextTripStationName".tr(),
                          subTitle:widget.trip.arrivalInfo?.name  ?? "",
                          subTitleColor:AppColor.grey1000.withOpacity(0.5),
                          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                        ):
                        CustomTextFieldWidget(
                            enabled: true,
                            label: "nextTripStationName".tr(),
                            hintText: "nextTripStationName".tr(),
                            textFieldHeight: 55,
                            initialValue:  widget.trip.arrivalInfo?.name??"",
                            onChanged: (String? text) {
                              if (text != null) {
                                widget.trip.arrivalInfo?.name = text;
                              }
                            },
                            onValidate: (String? value) {
                              return null;
                            }),


                        CustomVerticalSpace(height: 10),



                        TripDateTimeWidget(
                          isEditable:true,
                          title: "nextTripStationArrivalTime".tr(),
                          date:widget.trip.arrivalInfo?.date != null ?CommonFunctions.getFormattedDateEkram(
                              widget.trip.arrivalInfo?.date):null,
                          time:widget.trip.arrivalInfo?.time != null ?CommonFunctions.getFormattedTimeEkram(
                              widget.trip.arrivalInfo?.time):null,
                          onDateCallback: (String? date){

                            if(date != null)
                            {


                              setState(() {
                                widget.trip.arrivalInfo?.date = date;
                              });



                            }
                          },
                          onTimeCallback: (String? time){

                            if(time != null)
                            {

                              DateTime tempTime = DateFormat("HH:mm").parse(time);
                              String strTime = DateFormat("HH:mm")
                                  .format(tempTime)
                                  .toString();
                              setState(() {
                                widget.trip.arrivalInfo?.time = strTime;
                              });
                              //widget.trip.startupInfo?.time= time;
                              // context.read<AddTripBloc>().add(EditTripPathData(item:widget.widget.bloc.state.model));
                            }
                          },
                        ),


                        CustomVerticalSpace(height: 15),
                        InkWell(
                          onTap: () {
                            if (widget.trip.arrivalInfo?.location?.x != null &&widget.trip.arrivalInfo?.location?.y != null ) {
                              CommonFunctions.openMap(
                                  double.parse(widget.trip.arrivalInfo!.location!.y!),
                                  double.parse(widget.trip.arrivalInfo!.location!.x!));
                            }
                            else
                            {
                              CommonFunctions.showError("noData".tr());
                            }
                            // else if(enableEdit == true)
                            // {
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) => LocationSelectorScreen(callback: updateLocation,isCurrentStation:false)));
                            //
                            // }

                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: AppColor.blackModern300Light, width: 1), borderRadius: BorderRadius.circular(6)),
                            //:BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                CustomTextWidget(
                                  ("ekram_next_step_location").tr(),
                                  fontSize: 12,
                                  fontWeight: AppFontWeight.medium,
                                  fontColor: AppColor.black,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 30,right: 30,bottom: 20),
                          child: ElevatedButtonWidget.primaryCustom(
                            btnColor: AppColor.primary800Light,
                            height: 40,
                            onPressed: () {

                              if (widget.trip.startupInfo?.date != null &&
                                  widget.trip.startupInfo?.time != null
                                  &&widget.trip.arrivalInfo?.date != null &&
                                  widget.trip.arrivalInfo?.time != null) {
                                widget.bloc.add(
                                    EditTripPathData(item: widget.trip,hidenScreen: true));
                              }
                              else {
                                CommonFunctions.showError("please_enter_date_and_time".tr());
                              }


                            },
                            text: ('addnewPath').tr(),
                          ),
                        ),

                      ]),
                ),
                if (widget.bloc.state.status == BlocStatus.loading) Center(child: const CustomLoadingWidget()),
              ]
          ),
        ));






    //   BlocConsumer<AddTripBloc, AddTripState>(
    //   listener: (context, state) {
    //     // if (state.status == BlocStatus.failure) {
    //     //
    //     //
    //     //   // CommonFunctions.showError(state.errorMessage ?? "");
    //     // }
    //   },
    //   builder: (context, state) {
    //
    //
    //
    //
    //   },
    // );
  }
}

