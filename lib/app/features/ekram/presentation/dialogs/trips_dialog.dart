import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/add_trip_dialog_params.dart';


import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../blocs/driver_add_trip/add_trip_bloc.dart';


class TripsDialog extends StatelessWidget {
  final AddTripParameter params;
  const TripsDialog({Key? key, required this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container();
    // return BlocProvider(
    //   create: (context) => AddTripBloc(
    //       getLookUp: sl(),
    //       params: params,
    //       addTrip: sl(),
    //       getHospitals: sl(),
    //       getLaundries: sl(),
    //       getMosquess: sl(),
    //       updateDriverLocation: sl()),
    //   child: BlocConsumer<AddTripBloc, EkramAddTripState>(
    //     listener: (context, state) {
    //       if (state.status == BlocStatus.failure) {
    //         CommonFunctions.showError(state.errorMessage ?? "");
    //       }
    //     },
    //     builder: (context, state) {
    //       return Scaffold(
    //         backgroundColor: Colors.transparent,
    //         body: Stack(
    //           children: [
    //             Container(
    //               padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Expanded(
    //                           child: CustomTextWidget(
    //                         trans('register_trip_details'),
    //                         maxLines: 1,
    //                         fontSize: 24,
    //                         fontColor: AppColor.black,
    //                         textAlign: TextAlign.start,
    //                       )),
    //                       CustomTextButtonWidget(
    //                         onPressed: () => Navigator.of(context).pop(),
    //                         text: "closeButton".tr(),
    //                         btnTextColor: AppColor.grey1000,
    //                         btnTextSize: 17.0,
    //                         btnTextWeight: AppFontWeight.medium,
    //                         btnAlignment: AlignmentDirectional.centerEnd,
    //                       ),
    //                     ],
    //                   ),
    //                   Expanded(child: DialogBody()),
    //                   ElevatedButtonWidget.custom(
    //                     isDisabled: !state.isFormValid(),
    //                     text: ("confirm").tr(),
    //                     onPressed: () {
    //                       context
    //                           .read<AddTripBloc>()
    //                           .add(const SubmitEvent());
    //                     },
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             if (state.status == BlocStatus.loading)
    //               const CustomCircularLoadingWidget(),
    //           ],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}

class DialogBody extends StatefulWidget {
  DialogBody({Key? key}) : super(key: key);

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTripBloc, AddTripState>(
      builder: (context, state) {
        return Container();


        //   SingleChildScrollView(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       CustomVerticalSpace(height: 20),
        //       CustomTextFieldWidget(
        //           label: trans("currentTripStationType"),
        //           hintText: trans("currentTripStationType"),
        //           maxLines: 1,
        //           readOnly: true,
        //           initialValue: state.currentTripStationTypeId.toString(),
        //           textInputAction: TextInputAction.next,
        //           keyboardType: TextInputType.text,
        //           onChanged: (String? text) {
        //             /*  context
        //                 .read<AddTripBloc>()
        //                 .add(ChangeFullNameEvent(text: text));*/
        //           },
        //           onValidate: (String? value) {}),
        //       CustomVerticalSpace(height: 10),
        //       CustomTextFieldWidget(
        //           label: trans("currentTripStationName"),
        //           hintText: trans("currentTripStationName"),
        //           maxLines: 1,
        //           readOnly: true,
        //           initialValue: state.currentTripStationName,
        //           textInputAction: TextInputAction.next,
        //           keyboardType: TextInputType.text,
        //           onChanged: (String? text) {
        //             /*  context
        //                 .read<AddTripBloc>()
        //                 .add(ChangeFullNameEvent(text: text));*/
        //           },
        //           onValidate: (String? value) {}),
        //       CustomVerticalSpace(height: 10),
        //       CustomTextFieldWidget(
        //           label: trans("currentTripStationArrivalTime"),
        //           hintText: trans("currentTripStationArrivalTime"),
        //           maxLines: 1,
        //           readOnly: true,
        //           initialValue: state.currentTripStationArrivalTime,
        //           textInputAction: TextInputAction.next,
        //           keyboardType: TextInputType.text,
        //           onChanged: (String? text) {
        //             /*  context
        //                 .read<AddTripBloc>()
        //                 .add(ChangeFullNameEvent(text: text));*/
        //           },
        //           onValidate: (String? value) {}),
        //       CustomLookUpLongDialog(
        //         items: state.nextStationType ?? [],
        //         value: state.nextTripStationTypeId,
        //         onChangeType: (LookUpItem? item) {
        //           context
        //               .read<AddTripBloc>()
        //               .add(ChangeNextTripStationType(item: item));
        //         },
        //         onEmptyList: () async {
        //           return context
        //               .read<AddTripBloc>()
        //               .getNextStationTypeLookUp();
        //         },
        //         label: ("nextTripStationType").tr(),
        //         hint: ("nextTripStationType").tr(),
        //       ),
        //       CustomVerticalSpace(height: 16),
        //       CustomTextFieldWidget(
        //           label: trans("nextTripStationName"),
        //           hintText: trans("nextTripStationName"),
        //           maxLines: 1,
        //           initialValue: state.nextTripStationName,
        //           textInputAction: TextInputAction.next,
        //           keyboardType: TextInputType.text,
        //           onChanged: (String? text) {
        //             context
        //                 .read<AddTripBloc>()
        //                 .add(ChangeNextTripStationName(text: text));
        //           },
        //           onValidate: (String? value) {}),
        //       CustomVerticalSpace(height: 16),
        //       GestureDetector(
        //         onTap: () {
        //           context
        //               .read<AddTripBloc>()
        //               .add(ChangeArrivalTimeEvent());
        //         },
        //         child: ReadOnlyField(
        //           title: trans("nextTripStationArrivalTime"),
        //           subTitle: state.nextTripStationArrivalTime ?? "",
        //         ),
        //       ),
        //       CustomVerticalSpace(height: 16),
        //       CustomVerticalSpace(height: 16),
        //       CustomVerticalSpace(height: 20),
        //     ],
        //   ),
        // );
      },
    );
  }
}
