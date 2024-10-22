import 'package:balady_plus/app/features/ekram/presentation/widgets/driver/trip_datetime_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../data/model/driver/trip_details_model.dart';



class TripBodyWidget extends StatefulWidget {
 final TripDetailsModel? model;
  TripBodyWidget({Key? key,this.model}) : super(key: key);

  @override
  State<TripBodyWidget> createState() => _TripBodyWidgetState();
}

class _TripBodyWidgetState extends State<TripBodyWidget> {
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
        ReadOnlyField(
          title: "currentTripStationName".tr(),
          subTitle: widget.model?.startupInfo?.name  ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ),


        CustomVerticalSpace(height: 10),

        TripDateTimeWidget(

          title: "currentTripStationArrivalTime".tr(),
          date: CommonFunctions.getFormattedDateEkram(
              widget.model?.startupInfo?.date  ?? ""),
          time: CommonFunctions.getFormattedTimeEkram(
              widget.model?.startupInfo?.time ?? ""),
        ),

        CustomVerticalSpace(height: 15),


        if (widget.model?.startupInfo?.location?.x != null && widget.model?.startupInfo?.location?.y != null )
          InkWell(
            onTap: () {
              CommonFunctions.openMap(
                  double.parse(widget.model!.startupInfo!.location!.x!),
                  double.parse(widget.model!.startupInfo!.location!.y!));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border:
                  Border.all(color: AppColor.blackModern300Light, width: 1),
                  borderRadius: BorderRadius.circular(6)),
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
        ReadOnlyField(
          title: "nextTripStationName".tr(),
          subTitle: widget.model?.arrivalInfo?.name  ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ),


        CustomVerticalSpace(height: 10),
        ReadOnlyField(
          title: "nextTripStationArrivalTime".tr(),
          subTitle: widget.model?.arrivalInfo?.date ?? "",
          subTitleColor:AppColor.grey1000.withOpacity(0.5),
          decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

        ),

        if (widget.model?.arrivalInfo?.location?.x != null && widget.model?.arrivalInfo?.location?.y != null )
          InkWell(
            onTap: () {
              CommonFunctions.openMap(
                  double.parse(widget.model!.arrivalInfo!.location!.x!),
                  double.parse(widget.model!.arrivalInfo!.location!.y!));
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border:
                  Border.all(color: AppColor.blackModern300Light, width: 1),
                  borderRadius: BorderRadius.circular(6)),
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



        // CustomLookUpLongDialog(
        //   refreshList: true,
        //   items: widget.state?.nextStationType ?? [],
        //   value: widget.state?.nextTripStationTypeId,
        //   onChangeType: (LookUpItem? item) {
        //     context
        //         .read<EkramAddTripBloc>()
        //         .add(ChangeNextTripStationType(item: item));
        //   },
        //   onEmptyList: () async {
        //     return context
        //         .read<EkramAddTripBloc>()
        //         .getNextStationTypeLookUp();
        //   },
        //   label: Helpers.translatingWord("nextTripStationType"),
        //   hint: Helpers.translatingWord("nextTripStationType"),
        // ),
        // CustomVerticalSpace(height: 16),
        // if (widget.state?.showHospitalList())
        //   CustomLookUpLongDialog(
        //     items: widget.state?.hospitals ?? [],
        //     value: widget.state?.nextHospitalStation,
        //     onChangeType: (LookUpItem? item) {
        //       context
        //           .read<EkramAddTripBloc>()
        //           .add(ChangeNextTripHospitalStation(item: item));
        //     },
        //     onEmptyList: () async {
        //       return context
        //           .read<EkramAddTripBloc>()
        //           .getHospitalsLookUp();
        //     },
        //     label: Helpers.translatingWord("ekram_hospital_field_name"),
        //     hint: Helpers.translatingWord("ekram_hospital_field_name"),
        //   ),
        // if (widget.state?.showLaundryList())
        //   CustomLookUpLongDialog(
        //     items: widget.state?.launduriesList ?? [],
        //     value: widget.state?.nextLaundryStation,
        //     onChangeType: (LookUpItem? item) {
        //       context
        //           .read<EkramAddTripBloc>()
        //           .add(ChangeNextTripLaundryStation(item: item));
        //     },
        //     onEmptyList: () async {
        //       return context
        //           .read<EkramAddTripBloc>()
        //           .getLanuduriesLookUp();
        //     },
        //     label: Helpers.translatingWord("ekram_laundry_field_name"),
        //     hint: Helpers.translatingWord("ekram_laundry_field_name"),
        //   ),
        // if (widget.state?.showMosqueList())
        //   CustomLookUpLongDialog(
        //     items: widget.state?.mosquesList ?? [],
        //     value: widget.state?.nextMosqueStation,
        //     onChangeType: (LookUpItem? item) {
        //       context
        //           .read<EkramAddTripBloc>()
        //           .add(ChangeNextTripMosuqeStation(item: item));
        //     },
        //     onEmptyList: () async {
        //       return context.read<EkramAddTripBloc>().getMosquesLookUp();
        //     },
        //     label: Helpers.translatingWord("ekram_mosque_field_name"),
        //     hint: Helpers.translatingWord("ekram_mosque_field_name"),
        //   ),
        // if (widget.state?.showNextStationName())
        //   CustomTextFieldWidget(
        //       label: trans("nextTripStationName"),
        //       hintText: trans("nextTripStationName"),
        //       maxLines: 1,
        //       controller: context
        //           .read<EkramAddTripBloc>()
        //           .nextTripStationNameController,
        //       enabled: !widget.state?.isCemetry(),
        //       textInputAction: TextInputAction.next,
        //       keyboardType: TextInputType.text,
        //       onChanged: (String? text) {
        //         context
        //             .read<EkramAddTripBloc>()
        //             .add(ChangeNextTripStationName(text: text));
        //       },
        //       onValidate: (String? value) {}),
        // CustomVerticalSpace(height: 16),
        // GestureDetector(
        //   onTap: () {
        //     context
        //         .read<EkramAddTripBloc>()
        //         .add(ChangeArrivalTimeEvent());
        //   },
        //   child: ReadOnlyField(
        //     title: trans("nextTripStationArrivalTime"),
        //     subTitle: widget.state?.nextTripStationArrivalTime ??
        //         trans("nextTripStationArrivalTime"),
        //     subTitleColor: AppColor.blackModern400Light,
        //   ),
        // ),
        // CustomVerticalSpace(height: 16),
        // CustomVerticalSpace(height: 16),
        // CustomVerticalSpace(height: 20),
      ],
    );
  }
}
