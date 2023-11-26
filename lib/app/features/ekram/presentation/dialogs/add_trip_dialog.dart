import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_new_app/app/features/customer_voice/customer_voice_exports.dart';
import 'package:balady_new_app/app/features/ekram/domain/entities/add_trip_dialog_params.dart';
import 'package:balady_new_app/app/features/ekram/presentation/blocs/ekram_add_trip/ekram_add_trip_bloc.dart';

import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTripDialog extends StatelessWidget {
  final AddTripDialogParams params;
  const AddTripDialog({Key? key, required this.params}) : super(key: key);

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
            showError(state.errorMessage ?? "");
            context.read<EkramAddTripBloc>().add(ClearErrorMsgEvent());
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: CustomTextWidget(
                            trans('register_trip_details'),
                            maxLines: 1,
                            fontSize: 24,
                            fontColor: AppColors.black,
                            textAlign: TextAlign.start,
                          )),
                          CustomTextButtonWidget(
                            btnPressed: () => Navigator.of(context).pop(),
                            btnText: Helpers.translatingWord(
                              "closeButton",
                            ),
                            btnTextColor: AppColors.grey1000,
                            btnTextSize: 17.0,
                            btnTextWeight: FONT_WEIGHT.medium,
                            alignment: AlignmentDirectional.centerEnd,
                          ),
                        ],
                      ),
                      Expanded(child: DialogBody()),
                      IncidentSubmitButton(
                        isButtonDisabled: !state.isFormValid(),
                        btnText: Helpers.translatingWord("confirm"),
                        onPress: () {
                          context
                              .read<EkramAddTripBloc>()
                              .add(const SubmitEvent());
                        },
                      ),
                    ],
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  CustomCircularLoadingWidget(),
                if (state.status == BlocStatus.retry)
                  ReloadWidget(
                    onTab: () {
                      if (state.nextStationType?.isEmpty ?? true)
                        context
                            .read<EkramAddTripBloc>()
                            .getNextStationTypeLookUp();
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
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
    return BlocBuilder<EkramAddTripBloc, EkramAddTripState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomVerticalSpace(height: 20),
              CustomReadOnlyTextWidget(
                label: trans("currentTripStationType"),
                text: state.getCurrentStationTypeName() ?? "",
              ),
              CustomVerticalSpace(height: 10),
              CustomReadOnlyTextWidget(
                label: trans("currentTripStationName"),
                text: state.currentTripStationName ?? "",
              ),
              CustomVerticalSpace(height: 10),
              CustomReadOnlyTextWidget(
                label: trans("currentTripStationArrivalTime"),
                text: state.currentTripStationArrivalTime ?? "",
              ),
              CustomLookUpLongDialog(
                items: state.nextStationType ?? [],
                value: state.nextTripStationTypeId,
                onChangeType: (LookUpItem? item) {
                  context
                      .read<EkramAddTripBloc>()
                      .add(ChangeNextTripStationType(item: item));
                },
                onEmptyList: () async {
                  return context
                      .read<EkramAddTripBloc>()
                      .getNextStationTypeLookUp();
                },
                label: Helpers.translatingWord("nextTripStationType"),
                hint: Helpers.translatingWord("nextTripStationType"),
              ),
              CustomVerticalSpace(height: 16),
              if (state.showHospitalList())
                CustomLookUpLongDialog(
                  items: state.hospitals ?? [],
                  value: state.nextHospitalStation,
                  onChangeType: (LookUpItem? item) {
                    context
                        .read<EkramAddTripBloc>()
                        .add(ChangeNextTripHospitalStation(item: item));
                  },
                  onEmptyList: () async {
                    return context
                        .read<EkramAddTripBloc>()
                        .getHospitalsLookUp();
                  },
                  label: Helpers.translatingWord("ekram_hospital_field_name"),
                  hint: Helpers.translatingWord("ekram_hospital_field_name"),
                ),
              if (state.showLaundryList())
                CustomLookUpLongDialog(
                  items: state.launduriesList ?? [],
                  value: state.nextLaundryStation,
                  onChangeType: (LookUpItem? item) {
                    context
                        .read<EkramAddTripBloc>()
                        .add(ChangeNextTripLaundryStation(item: item));
                  },
                  onEmptyList: () async {
                    return context
                        .read<EkramAddTripBloc>()
                        .getLanuduriesLookUp();
                  },
                  label: Helpers.translatingWord("ekram_laundry_field_name"),
                  hint: Helpers.translatingWord("ekram_laundry_field_name"),
                ),
              if (state.showMosqueList())
                CustomLookUpLongDialog(
                  items: state.mosquesList ?? [],
                  value: state.nextMosqueStation,
                  onChangeType: (LookUpItem? item) {
                    context
                        .read<EkramAddTripBloc>()
                        .add(ChangeNextTripMosuqeStation(item: item));
                  },
                  onEmptyList: () async {
                    return context.read<EkramAddTripBloc>().getMosquesLookUp();
                  },
                  label: Helpers.translatingWord("ekram_mosque_field_name"),
                  hint: Helpers.translatingWord("ekram_mosque_field_name"),
                ),
              if (state.showNextStationName())
                CustomTextFieldWidgetWithValue(
                    label: trans("nextTripStationName"),
                    hintText: trans("nextTripStationName"),
                    maxLines: 1,
                    initialValue: state.nextTripStationName,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    contentHorizontalPadding: 0,
                    onChanged: (String? text) {
                      context
                          .read<EkramAddTripBloc>()
                          .add(ChangeNextTripStationName(text: text));
                    },
                    validator: (String? value) {}),
              CustomVerticalSpace(height: 16),
              GestureDetector(
                onTap: () {
                  context
                      .read<EkramAddTripBloc>()
                      .add(ChangeArrivalTimeEvent());
                },
                child: CustomReadOnlyTextWidget(
                  label: trans("nextTripStationArrivalTime"),
                  text: state.nextTripStationArrivalTime ??
                      trans("nextTripStationArrivalTime"),
                ),
              ),
              CustomVerticalSpace(height: 16),
              CustomVerticalSpace(height: 16),
              CustomVerticalSpace(height: 20),
            ],
          ),
        );
      },
    );
  }
}
