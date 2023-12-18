import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/data/model/trips_details_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/add_trip_dialog_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/trip_details.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/dialogs/add_trip_dialog.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/trip_details_dialog_widgets/police_letter.dart';
import 'package:collection/collection.dart';

import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import '../../../../core/services/local/helpers.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/empty_state_widget.dart';
import '../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

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
          CommonFunctions.showError(state.errorMessage ?? "");
        }
      }, builder: (context, state) {
        return Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          /* CustomTextWidget(
                            trans('trip_details'),
                            maxLines: 1,
                            fontSize: 24,
                            fontColor: AppColor.black,
                            textAlign: TextAlign.start,
                          ),
                          EnhancedCustomElevatedButtonWidget(
                            btnPressed: () =>
                                Navigator.of(context).pop(state.isCompleted),
                            btnText: Helpers.translatingWord(
                              "closeButton",
                            ),
                            btnTextColor: AppColor.grey1000,
                            btnTextSize: 17.0,
                            btnTextWeight: AppFontWeight.medium,
                            btnAlignment: AlignmentDirectional.centerEnd,
                          ),*/
                        ],
                      ),
                      if (state.tripDetails?.isNotEmpty ?? false) ...[
                        ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                      ],
                      if (state.tripDetails != null &&
                          state.tripDetails!.isEmpty)
                        EmptyListWidget(title: trans("no_trips")),
                      const CustomVerticalSpace(height: 16),
                      PoliceLetter(),
                      if (state.isCompleted != true) ...[
                        CustomVerticalSpace(height: 16),
                        EnhancedCustomElevatedButtonWidget(
                          btnTextColor: AppColor.white,
                          btnPressed: () async {
                            final result =
                                await CustomPopUpsWidgets.showBottomSheet(
                                    context,
                                    child: AddTripDialog(
                                      params: getCurrentAddTripData(
                                          state.tripDetails?.lastOrNull,
                                          state.deathInfo,
                                          trips: state.tripDetails),
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
                          btnTextWeight: AppFontWeight.regular,
                          btnHeight: 56,
                        ),
                        CustomVerticalSpace(height: 16),
                        EnhancedCustomElevatedButtonWidget(
                          btnPressed: () {
                            context
                                .read<TripDetailsBloc>()
                                .add(CompleteTripEvent());
                          },
                          btnText: Helpers.translatingWord("trip_done"),
                          btnTextSize: 16,
                          btnTextWeight: AppFontWeight.regular,
                          btnHeight: 56,
                          btnTextColor: AppColor.primary900Light,
                          btnBorderColor: AppColor.primary900Light,
                          btnColor: Colors.transparent,
                        ),
                      ],
                      if (state.status == BlocStatus.retry)
                        ReloadWidget(
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
                        ),
                    ]),
              ),
            ),
            if (state.status == BlocStatus.loading)
              CustomCircularLoadingWidget(),
          ],
        );
      }),
    );
  }

  AddTripDialogParams getCurrentAddTripData(
      TripDetails? lastTrip, DeceasedInfoResponseDtoList info,
      {List<TripDetails>? trips}) {
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
          cemetryId: info.cemeteryId,
          cemetryName: info.cemeteryName,
          trips: trips);
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
          currentTripStationTypeId: lastTrip.nextTripStationTypeId,
          cemetryId: info.cemeteryId,
          cemetryName: info.cemeteryName,
          trips: trips);
    }
  }
}
