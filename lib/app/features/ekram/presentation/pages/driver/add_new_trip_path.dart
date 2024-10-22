
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

import '../../../data/model/driver/trip_stations.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';
import '../../widgets/driver/custom_dropdown_dialog.dart';
import '../../widgets/driver/trip_datetime_widget.dart';



class AddNewTripPath extends StatelessWidget {
  final int requestId;

   AddNewTripPath({Key? key, required this.requestId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTripBloc(
          getTripStations: sl(),
          getTrips: sl(),
          requestId: requestId,
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
                        value: state.currentTripStation,
                          onChangeType: (TripStations? item) {
                          context
                              .read<AddTripBloc>()
                              .add(updateCurrentTripStation(item: item));
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
                                subTitle: state.currentTripStation?.cityName  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),

                              CustomVerticalSpace(height: 10),
                              ReadOnlyField(
                                title: "currentTripStationName".tr(),
                                subTitle: state.currentTripStation?.name  ?? "",
                                subTitleColor:AppColor.grey1000.withOpacity(0.5),
                                decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),

                              ),


                              CustomVerticalSpace(height: 10),

                              TripDateTimeWidget(
                                title: "currentTripStationArrivalTime".tr(),
                                isEditable: state.currentTripStation != null ? true :false,
                                date: state.currentTripStation?.date,
                                time: state.currentTripStation?.time,
                                onDateCallback: (String? date){

                                  if(date != null)
                                    {
                                      TripStations? currentTripStation = state.currentTripStation?.copyWith(date: date);
                                      context.read<AddTripBloc>().add(updateCurrentTripStation(item: currentTripStation));
                                    }
                                },
                                onTimeCallback: (String? time){

                                  if(time != null)
                                  {

                                    TripStations? currentTripStation = state.currentTripStation?.copyWith(time: time);
                                    context.read<AddTripBloc>().add(updateCurrentTripStation(item: currentTripStation));
                                  }
                                },

                              ),

                        //
                        //
                        //       CustomVerticalSpace(height: 10),
                        //       ReadOnlyField(
                        //         title: "currentTripStationArrivalTime".tr(),
                        //         subTitle: widget.model?.startupInfo?.date ?? "",
                        //         subTitleColor:AppColor.grey1000.withOpacity(0.5),
                        //         decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                        //       ),
                        //
                        //
                        //       if (widget.model?.startupInfo?.location?.x != null && widget.model?.startupInfo?.location?.y != null )
                        //         InkWell(
                        //           onTap: () {
                        //             CommonFunctions.openMap(
                        //                 double.parse(widget.model!.startupInfo!.location!.x!),
                        //                 double.parse(widget.model!.startupInfo!.location!.y!));
                        //           },
                        //           child: Container(
                        //             padding: const EdgeInsets.all(16),
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //                 color: Colors.transparent,
                        //                 border:
                        //                 Border.all(color: AppColor.blackModern300Light, width: 1),
                        //                 borderRadius: BorderRadius.circular(6)),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //
                        //                 CustomTextWidget(
                        //                   ("ekram_current_step_location").tr(),
                        //                   fontSize: 12,
                        //                   fontWeight: AppFontWeight.medium,
                        //                   fontColor: AppColor.black,
                        //                   textAlign: TextAlign.start,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //
                        //
                        //       CustomVerticalSpace(height: 20),
                        //       ReadOnlyField(
                        //         title: "nextTripCity".tr(),
                        //         subTitle: widget.model?.arrivalInfo?.cityName ?? "",
                        //         subTitleColor:AppColor.grey1000.withOpacity(0.5),
                        //         decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                        //
                        //       ),
                        //       CustomVerticalSpace(height: 10),
                        //       ReadOnlyField(
                        //         title: "nextTripStationType".tr(),
                        //         subTitle: widget.model?.arrivalInfo?.typeName  ?? "",
                        //         subTitleColor:AppColor.grey1000.withOpacity(0.5),
                        //         decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                        //
                        //       ),
                        //
                        //
                        //       CustomVerticalSpace(height: 10),
                        //       ReadOnlyField(
                        //         title: "nextTripStationName".tr(),
                        //         subTitle: widget.model?.arrivalInfo?.name  ?? "",
                        //         subTitleColor:AppColor.grey1000.withOpacity(0.5),
                        //         decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                        //
                        //       ),
                        //
                        //
                        //       CustomVerticalSpace(height: 10),
                        //       ReadOnlyField(
                        //         title: "nextTripStationArrivalTime".tr(),
                        //         subTitle: widget.model?.arrivalInfo?.date ?? "",
                        //         subTitleColor:AppColor.grey1000.withOpacity(0.5),
                        //         decoration:  BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                        //
                        //       ),
                        //
                        //       if (widget.model?.arrivalInfo?.location?.x != null && widget.model?.arrivalInfo?.location?.y != null )
                        //         InkWell(
                        //           onTap: () {
                        //             CommonFunctions.openMap(
                        //                 double.parse(widget.model!.arrivalInfo!.location!.x!),
                        //                 double.parse(widget.model!.arrivalInfo!.location!.y!));
                        //           },
                        //           child: Container(
                        //             padding: const EdgeInsets.all(16),
                        //             width: double.infinity,
                        //             decoration: BoxDecoration(
                        //                 color: Colors.transparent,
                        //                 border:
                        //                 Border.all(color: AppColor.blackModern300Light, width: 1),
                        //                 borderRadius: BorderRadius.circular(6)),
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.center,
                        //               children: [
                        //
                        //                 CustomTextWidget(
                        //                   ("ekram_current_step_location").tr(),
                        //                   fontSize: 12,
                        //                   fontWeight: AppFontWeight.medium,
                        //                   fontColor: AppColor.black,
                        //                   textAlign: TextAlign.start,
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //


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




                    },
                    text: ('startTrip').tr(),
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

