import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/fields/read_only_field.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/add_trip_dialog_params.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_add_trip/ekram_add_trip_bloc_new.dart';

import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../data/model/driver/trip_details_model.dart';
import '../widgets/transportation_details_widget/trip_body_widget.dart';

class AddTrip_new extends StatelessWidget {
  final List<TripDetailsModel> params;
  const AddTrip_new({Key? key, required this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EkramAddTripBloc(
          getLookUp: sl(),
          params: params,
          addTrip: sl(),
          getHospitals: sl(),
          getLaundries: sl(),
          getMosquess: sl(),
          updateDriverLocation: sl()),
      child: BlocConsumer<EkramAddTripBloc, EkramAddTripState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
            context.read<EkramAddTripBloc>().add(ClearErrorMsgEvent());
          }
        },
        builder: (context, state) {

         return Scaffold(
           appBar:   DetailsHeader(
             titleWidget: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 CustomTextWidget(
                   "request".tr(),
                   fontSize: 20,
                   maxLines: 1,
                   textOverflow: TextOverflow.ellipsis,
                   fontWeight: AppFontWeight.bold,
                   fontColor: AppColor.blackModern700Light,
                 ),
                 const SizedBox(
                   width: 16,
                 ),
                 CustomTextWidget(
                   "#",
                   fontSize: 14,
                   maxLines: 1,
                   textOverflow: TextOverflow.ellipsis,
                   fontWeight: AppFontWeight.medium,
                   fontColor: AppColor.blackModern700Light,
                 ),
               ],
             ),
           ),
           body: SafeArea(

             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: SingleChildScrollView(
                 child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomVerticalSpace(height: 10),
                      CustomTextWidget(
                        "tripPaths".tr(),
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
                        state.data.length ??
                            0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return

                            ExpandableCard(
                                title: "${("tripPathsnumber").tr()}${index+1}",
                                icon: null,
                                children:
                                [
                                  TripBodyWidget(model:state.data[index]),
                                ]);
                        },
                      ),







                      if (state.status == BlocStatus.loading) const CustomLoadingWidget()
                    ],
                  ),
               ),
             ),
           ),
         );


          // return Scaffold(
          //   backgroundColor: Colors.transparent,
          //   body: SafeArea(
          //     child: Stack(
          //       children: [
          //         Container(
          //           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Row(
          //                 children: [
          //                   Expanded(
          //                       child: CustomTextWidget(
          //                     trans('register_trip_details'),
          //                     maxLines: 1,
          //                     fontSize: 24,
          //                     fontColor: AppColor.black,
          //                     textAlign: TextAlign.start,
          //                   )),
          //                   CustomTextButtonWidget(
          //                     onPressed: () => Navigator.of(context).pop(),
          //                     text: Helpers.translatingWord(
          //                       "closeButton",
          //                     ),
          //                     btnTextColor: AppColor.grey1000,
          //                     btnTextSize: 17.0,
          //                     btnTextWeight: AppFontWeight.medium,
          //                     btnAlignment: AlignmentDirectional.centerEnd,
          //                   ),
          //                 ],
          //               ),
          //               Expanded(child: DialogBody()),
          //               ElevatedButtonWidget.custom(
          //                 isDisabled: !state.isFormValid(),
          //                 text: Helpers.translatingWord("add"),
          //                 onPressed: () {
          //                   context
          //                       .read<EkramAddTripBloc>()
          //                       .add(const SubmitEvent());
          //                 },
          //               ),
          //             ],
          //           ),
          //         ),
          //         if (state.status == BlocStatus.loading)
          //           CustomCircularLoadingWidget(),
          //         if (state.status == BlocStatus.retry)
          //           ReloadWidget(
          //             onTab: () {
          //               if (state.nextStationType?.isEmpty ?? true)
          //                 context
          //                     .read<EkramAddTripBloc>()
          //                     .getNextStationTypeLookUp();
          //             },
          //           ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}

