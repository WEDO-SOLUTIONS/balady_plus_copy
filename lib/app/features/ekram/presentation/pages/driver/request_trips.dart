
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';

import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

import '../../../data/model/driver/transport_request_item_model.dart';
import '../../blocs/driver_add_trip/add_trip_bloc.dart';


import '../../blocs/driver_identical_bloc/identical_list_bloc.dart';
import '../../dialogs/add_path_dialog.dart';
import '../../widgets/driver/trip_body_widget.dart';
import 'add_custom_trip_path.dart';
import 'extra_data.dart';

class RequestTrips extends StatelessWidget {
  final TransportRequestItemModel model;
  AddTripBloc? bloc;
  int pathCounter=0;
   RequestTrips({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)
      {
        bloc = AddTripBloc(
            deleteTrip: sl(),
            getTrips: sl(),
            editTrip: sl(),
            getTripStations: sl(),
            model: model,
            context: context,
            addTrip: sl(),
            updateDriverLocation: sl());
        bloc!.add(GetTripsEvent());


        return bloc!;
      },
      child: BlocConsumer<AddTripBloc, AddTripState>(
        listener: (context, state) {
          // if (state.status == BlocStatus.failure) {
          //
          //
          //   // CommonFunctions.showError(state.errorMessage ?? "");
          // }
        },
        builder: (cont, state) {
          pathCounter = 0;
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
             child: Stack(
               children:
               [
                 Column(
                   mainAxisAlignment: MainAxisAlignment.center,
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
                           child: Column(
                             children: [
                               ElevatedButtonWidget.primaryCustomBorderColor(
                                 borderColor: AppColor.kGreenBoarder,
                                 bgColor: Colors.transparent,
                                 color: AppColor.darkGreylight,
                                 fontSize:13,
                                 height:45,
                                 onPressed: () async {

                                   bloc ??= context.read<AddTripBloc>();
                                   await CustomPopUpsWidgets.showBottomSheet(
                                   context, child: AddNewTripPathDailog( title: 'addnewPath'.tr(), bloc: bloc!,),
                                   );


                                 },
                                 text: ('addnewPath').tr(),
                               ),
                               InkWell(
                                 onTap: () async {

                                 //  NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => DriverExtraDataPage(),),);
                                   await CustomPopUpsWidgets.showBottomSheet(
                                     context, child: DriverExtraDataPage(),
                                   );
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
                                         ("extra_data").tr(),
                                         fontSize: 12,
                                         fontWeight: AppFontWeight.medium,
                                         fontColor: AppColor.black,
                                         textAlign: TextAlign.start,
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ],
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
                                 if(state.data![index].isSuggestPath==false) {
                                   pathCounter = pathCounter+1;
                                   return ExpandableCard(
                                       title: "${("tripPathsnumber")
                                           .tr()}${pathCounter}",
                                       icon: null,
                                       children:
                                       [
                                         TripBodyWidget(
                                             model: state.data![index]),
                                       ]);
                                 }
                                 else
                                   {
                                     return Container();
                                   }
                               },
                             ),


                             if (state.status == BlocStatus.retry)
                               ReloadWidget(
                                 onTab: () {
                                   bloc?.add(
                                       GetTripsEvent());
                                 },
                               ),
                           ],
                         ),
                       ),
                     ),

                     SizedBox(height: 20,),
                     ElevatedButtonWidget.primaryCustom(
                       onPressed: () {

                         NavigationService.navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => DriverExtraDataPage(),),);
               // fffff

                       },
                       text: ('nextButton').tr(),
                     ),

                   ],
                 ),

                 if (state.status == BlocStatus.loading) Center(child: const CustomLoadingWidget()),

               ]

             ),
           ),
         );


       },
      ),
    );
  }
}

