import 'package:balady_new_app/app/core/core_exports.dart';
import 'package:balady_new_app/app/features/ekram/data/model/trips_details_params.dart';
import 'package:balady_new_app/app/features/ekram/domain/entities/add_trip_dialog_params.dart';
import 'package:balady_new_app/app/features/ekram/domain/entities/trip_details.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/app/features/ekram/presentation/dialogs/add_trip_dialog.dart';
import 'package:balady_new_app/app/features/ekram/presentation/widgets/trip_details_dialog_widgets/police_letter.dart';
import 'package:collection/collection.dart';

import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import '../../../../../shared/core/utils/enums/bloc_status.dart';

class TripDetailsDialog extends StatelessWidget {
  final TripDetailsParmas params;

  const TripDetailsDialog({Key? key, required this.params}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripDetailsBloc(
          params: params,
          getTrips: sl(),
          completeTrip: sl(),
          getLookUp: sl(),
          deleteTrip: sl(),
          uploadLetter: sl(),
          getDeceasedDriverRequestDetails: sl(),
          downloadAttachment: sl()),
      child: BlocConsumer<TripDetailsBloc, TripDetailsState>(
          listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          showError(state.errorMessage ?? "");
        }
      }, builder: (context, state) {
        return Stack(
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
                          trans('trip_details'),
                          maxLines: 1,
                          fontSize: 24,
                          fontColor: AppColors.black,
                          textAlign: TextAlign.start,
                        )),
                        CustomTextButtonWidget(
                          btnPressed: () =>
                              Navigator.of(context).pop(state.isCompleted),
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
                    if (state.tripDetails?.isNotEmpty ?? false) ...[
                      Expanded(
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.tripDetails?.length,
                            itemBuilder: (ctx, index) {
                              return TripDetailsDialogCard(
                                tripDetails: state.tripDetails![index],
                                showDelete: params.requestStatusId != 6 &&
                                    params.requestStatusId != 5,
                                currentStationType: state.getStationTypeName(
                                    state.tripDetails![index]
                                            .currentTripStationTypeId ??
                                        0),
                                nextStationType: state.getStationTypeName(state
                                        .tripDetails![index]
                                        .nextTripStationTypeId ??
                                    0),
                                onPressDelete: () {
                                  context.read<TripDetailsBloc>().add(
                                      DeleteTripEvent(
                                          id: state.tripDetails![index]
                                              .tripStepsInfoRecordId!));
                                },
                              );
                            }),
                      ),
                    ],
                    if (state.tripDetails != null && state.tripDetails!.isEmpty)
                      Expanded(
                          child: EmptyStateWidget(title: trans("no_trips"))),
                    CustomVerticalSpace(height: 16),
                    PoliceLetter(),
                    if (state.isCompleted != true) ...[
                      CustomVerticalSpace(height: 16),
                      CustomElevatedButtonWidget(
                        btnTextColor: AppColors.white,
                        btnPressed: () async {
                          final result =
                              await CustomPopUpsWidgets.showBottomSheet(context,
                                  child: AddTripDialog(
                                    params: getCurrentAddTripData(
                                        state.tripDetails?.lastOrNull,
                                        state.deathInfo),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.95);

                          if (result != null) {
                            context
                                .read<TripDetailsBloc>()
                                .add(GetTripsDetailsInDialogEvent());
                          }
                        },
                        btnText:
                            Helpers.translatingWord("register_trip_details"),
                        btnTextSize: 16,
                        btnTextWeight: FONT_WEIGHT.regular,
                        btnHeight: 56,
                      ),
                      CustomVerticalSpace(height: 16),
                      CustomElevatedButtonWidget(
                        btnPressed: () {
                          context
                              .read<TripDetailsBloc>()
                              .add(CompleteTripEvent());
                        },
                        btnText: Helpers.translatingWord("trip_done"),
                        btnTextSize: 16,
                        btnTextWeight: FONT_WEIGHT.regular,
                        btnHeight: 56,
                        btnTextColor: AppColors.darkTurquoise,
                        btnBorderColor: AppColors.darkTurquoise,
                        btnColor: Colors.transparent,
                      ),
                    ],
                    if (state.status == BlocStatus.retry)
                      Expanded(child: ReloadWidget(
                        onTab: () {
                          if (state.stationTypes == null) {
                            context
                                .read<TripDetailsBloc>()
                                .getStationTypeLookUp();
                          } else
                            context
                                .read<TripDetailsBloc>()
                                .add(GetTripsDetailsInDialogEvent());
                        },
                      )),
                  ]),
            ),
            if (state.status == BlocStatus.loading)
              CustomCircularLoadingWidget(),
          ],
        );
      }),
    );
  }

  AddTripDialogParams getCurrentAddTripData(
      TripDetails? lastTrip, DeceasedInfoResponseDtoList info) {
    if (lastTrip == null) {
      return AddTripDialogParams(
        deathCityId: info.deathCityId,
        deathInfoId: info.deathInfoId,
        currentTripStationArrivalTime:
            info.driverAssignDateTime?.replaceAll("-", "/"),
        currentTripStationId: info.transferOrganizationId,
        currentTripStationLocationX: double.tryParse(
          info.transferOrganizationX ?? "",
        ),
        currentTripStationLocationY: double.tryParse(
          info.transferOrganizationY ?? "",
        ),
        currentTripStationName: info.transferOrganizationName,
        currentTripStationTypeId: 30502,
      );
    } else {
      return AddTripDialogParams(
          deathCityId: info.deathCityId,
          deathInfoId: info.deathInfoId,
          currentTripStationArrivalTime:
              lastTrip.nextTripStationArrivalTime?.replaceAll("-", "/"),
          currentTripStationId: lastTrip.nextTripStationId,
          currentTripStationLocationX: double.tryParse(
            lastTrip.nextTripStationLocationX ?? "",
          ),
          currentTripStationLocationY: double.tryParse(
            lastTrip.nextTripStationLocationY ?? "",
          ),
          currentTripStationName: lastTrip.nextTripStationName,
          currentTripStationTypeId: lastTrip.nextTripStationTypeId);
    }
  }
}
