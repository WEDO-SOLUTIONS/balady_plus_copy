
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';

import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

import '../../blocs/driver_add_trip/add_trip_bloc.dart';


import '../../widgets/driver/trip_body_widget.dart';
import 'add_new_trip_path.dart';

class RequestTrips extends StatelessWidget {
  final int requestId;
  const RequestTrips({Key? key, required this.requestId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTripBloc(
          getTrips: sl(),
          getTripStations: sl(),
          requestId: requestId,
          addTrip: sl(),
          updateDriverLocation: sl())..add(GetTripsEvent()),
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

                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                         CustomTextWidget(
                           "tripPaths".tr(),
                           fontSize: 20.0,
                           fontWeight: AppFontWeight.bold,
                           fontColor: AppColor.blackModern700Light,
                           maxLines: 1,
                           textOverflow: TextOverflow.ellipsis,
                           textAlign: TextAlign.start,
                         ),
                     SizedBox(width: 20,),
                     Flexible(
                     child: ElevatedButtonWidget.primaryCustomBorderColor(
                       borderColor: AppColor.kGreenBoarder,
                       bgColor: Colors.transparent,
                       color: AppColor.darkGreylight,
                       fontSize:13,
                       height:45,
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => AddNewTripPath(requestId: requestId,),
                           ),
                         );
                     
                     
                     
                       },
                       text: ('addnewPath').tr(),
                     ),
                   ),




                 ],),

                 Expanded(
                   child: SingleChildScrollView(
                     child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisSize: MainAxisSize.max,
                        children: [
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount:
                            state.data?.length ?? 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return

                                ExpandableCard(
                                    title: "${("tripPathsnumber").tr()}${index+1}",
                                    icon: null,
                                    children:
                                    [


                                      TripBodyWidget(model:state.data![index]),
                                    ]);
                            },
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
                     Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => RequestTrips(
                         requestId: requestId,),
                       ),
                     );



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

