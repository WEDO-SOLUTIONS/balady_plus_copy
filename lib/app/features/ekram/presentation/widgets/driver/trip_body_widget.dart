import 'package:balady_plus/app/features/ekram/presentation/widgets/driver/confirm_dialog.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/driver/trip_datetime_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../data/model/driver/trip_details_model.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';
import '../../pages/driver/location_selector.dart';



class TripBodyWidget extends StatefulWidget {
 final TripDetailsModel? model;
  TripBodyWidget({Key? key,this.model}) : super(key: key);

  @override
  State<TripBodyWidget> createState() => _TripBodyWidgetState();
}

class _TripBodyWidgetState extends State<TripBodyWidget> {
  bool enableEdit =false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return

      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomVerticalSpace(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
              "${'pathID'.tr()} #${widget.model?.id}",
              fontSize: 14,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern700Light,
            ),


            Row(
              children: [
                widget.model?.editable == true?  IconButton(
                  onPressed: () {

                    setState(() {
                      enableEdit = true;
                    });

                  },
                  icon: SvgPicture.asset(
                      IconPath.edit,
                      color: AppColor.primary800Light),
                  iconSize: 25 ,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),):Container(),

                SizedBox(width: 10,),
                widget.model?.deletable == true?  IconButton(
                  onPressed: () async {


                    await showCancelConfirmDialog((){


                      context.read<AddTripBloc>().add(
                          DeleteTripPath(tripId: widget.model?.id!));

                      Navigator.pop(context);

                    },);



                  },
                  icon: SvgPicture.asset(
                    IconPath.delete,
                    color: Colors.grey),
                  iconSize: 25 ,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),):Container(),
              ],
            ),
          ],
        ),

        CustomVerticalSpace(height: 20),
        ReadOnlyField(
          title: "currentTripCity".tr(),
          subTitle: widget.model?.startupInfo?.cityName ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ),
        CustomVerticalSpace(height: 10),
        ReadOnlyField(
          title: "currentTripStationType".tr(),
          subTitle: widget.model?.startupInfo?.typeName  ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ),

        CustomVerticalSpace(height: 10),
        widget.model?.startupInfo?.isEditable()==false|| enableEdit==false?
        ReadOnlyField(
          title: "currentTripStationName".tr(),
          subTitle: widget.model?.startupInfo?.name  ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ):
        CustomTextFieldWidget(
            enabled: true,
            label: "currentTripStationName".tr(),
            hintText: "currentTripStationName".tr(),
            textFieldHeight: 55,
            initialValue:   widget.model?.startupInfo?.name ??"",
            onChanged: (String? text) {
              if (text != null) {
                setState(() {
                  widget.model?.startupInfo?.name  = text;
                });

              }
            },
            onValidate: (String? value) {
              return null;
            }),


        CustomVerticalSpace(height: 10),

        TripDateTimeWidget(
          isEditable:enableEdit,
          title: "currentTripStationArrivalTime".tr(),
          date: widget.model?.startupInfo?.date != null ?CommonFunctions.getFormattedDateEkram(
              widget.model?.startupInfo?.date):null,
          time: widget.model?.startupInfo?.time != null ?CommonFunctions.getFormattedTimeEkram(
              widget.model?.startupInfo?.time):null,
          onDateCallback: (String? date){

            if(date != null)
            {

              setState(() {
                widget.model?.startupInfo?.date = date;
              });

              // var x =  context.read<AddTripBloc>();
              // context.read<AddTripBloc>().add(EditTripPathData(item:widget.model));

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
                widget.model?.startupInfo?.time = strTime;
              });
              // widget.model?.startupInfo?.time= time;
              // context.read<AddTripBloc>().add(EditTripPathData(item:widget.model));
            }
          },

        ),

        CustomVerticalSpace(height: 15),


         InkWell(
            onTap: () {
              if (widget.model?.startupInfo?.location?.x != null && widget.model?.startupInfo?.location?.y != null ) {
                CommonFunctions.openMap(
                  double.parse(widget.model!.startupInfo!.location!.y!),
                  double.parse(widget.model!.startupInfo!.location!.x!));
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
          subTitle: widget.model?.arrivalInfo?.cityName ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ),
        CustomVerticalSpace(height: 10),
        ReadOnlyField(
          title: "nextTripStationType".tr(),
          subTitle: widget.model?.arrivalInfo?.typeName  ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ),


        CustomVerticalSpace(height: 10),
        widget.model?.arrivalInfo?.isEditable()==false || enableEdit==false?
        ReadOnlyField(
          title: "nextTripStationName".tr(),
          subTitle: widget.model?.arrivalInfo?.name  ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ):
        CustomTextFieldWidget(
            enabled: true,
            label: "currentTripStationName".tr(),
            hintText: "currentTripStationName".tr(),
            textFieldHeight: 55,
            initialValue:   widget.model?.arrivalInfo?.name ??"",
            onChanged: (String? text) {
              if (text != null) {
                setState(() {
                  widget.model?.arrivalInfo?.name  = text;
                });

              }
            },
            onValidate: (String? value) {
              return null;
            }),


        CustomVerticalSpace(height: 10),



        TripDateTimeWidget(
          isEditable:enableEdit,
          title: "nextTripStationArrivalTime".tr(),
          date: widget.model?.arrivalInfo?.date != null ?CommonFunctions.getFormattedDateEkram(
              widget.model?.arrivalInfo?.date):null,
          time: widget.model?.arrivalInfo?.time != null ?CommonFunctions.getFormattedTimeEkram(
              widget.model?.arrivalInfo?.time):null,
          onDateCallback: (String? date){

            if(date != null)
            {


              setState(() {
                widget.model?.arrivalInfo?.date = date;
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
                widget.model?.arrivalInfo?.time = strTime;
              });
              // widget.model?.startupInfo?.time= time;
              // context.read<AddTripBloc>().add(EditTripPathData(item:widget.model));
            }
          },
        ),


        CustomVerticalSpace(height: 15),
         InkWell(
            onTap: () {
              if (widget.model?.arrivalInfo?.location?.x != null && widget.model?.arrivalInfo?.location?.y != null ) {
                CommonFunctions.openMap(
                  double.parse(widget.model!.arrivalInfo!.location!.y!),
                  double.parse(widget.model!.arrivalInfo!.location!.x!));
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
          padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
          child: ElevatedButtonWidget.primaryCustom(
            btnColor: enableEdit == true ? AppColor.primary800Light: AppColor.blackModern300Light.withOpacity(0.4),
            height: 40,
            onPressed: () {
              if(enableEdit== true ) {
                if (widget.model?.startupInfo?.date != null &&
                    widget.model?.startupInfo?.time != null
                    && widget.model?.arrivalInfo?.date != null &&
                    widget.model?.arrivalInfo?.time != null) {
                  context.read<AddTripBloc>().add(
                      EditTripPathData(item: widget.model, hidenScreen: false));
                }
                else {
                  CommonFunctions.showError("please_enter_date_and_time".tr());
                }
              }

            },
            text: ('saveButton').tr(),
          ),
        ),




      ],
    );
  }
  //  void updateLocation(double? lat,double? lng,String? address,bool isCurrentStation)
  // {
  //   if(isCurrentStation == true) {
  //     setState(() {
  //       widget.model?.startupInfo?.location = Location(x: "$lat",y: "$lng");
  //     });
  //
  //   }
  //   else
  //     {
  //       setState(() {
  //         widget.model?.arrivalInfo?.location = Location(x: "$lat",y: "$lng");
  //       });
  //
  //     }
  //
  // }

  Future<void> showCancelConfirmDialog(Function callback) async {



    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ConfirmDialog(
          title:"deletPathTitle".tr(),
          message:"do_you_want_to_delete_path".tr(),
          okTitle: "yesDeletePath".tr(),
          cancelTitle: "noGoback".tr(),
          onOkCallback: callback,


        );
      },
    );




  }

}
