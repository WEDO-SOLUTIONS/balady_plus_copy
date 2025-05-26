import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/additional_activity_details_response.dart';
import '../../../data/models/additional_activity_response.dart';
import '../../../data/models/commercial_request_details_response.dart'
    hide Activity;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/models/salama_warning_request.dart';
import '../../../domain/entities/addetional_activity_details_request.dart';
import '../../../domain/entities/addetional_activity_request.dart';
import '../../../domain/use_cases/get_additional_activites.dart';
import '../../../domain/use_cases/get_details_additional_activites.dart';
import '../../../domain/use_cases/get_warning_messsage.dart';
import '../../../domain/use_cases/get_warning_workflow_messsage.dart';
import '../../step3/widgets/map_widgets/warning_message.dart';
import '../page/salama_warning_message.dart';
import 'package:collection/collection.dart';

part 'cr_step2_activity_data_state.dart';

class CrStep2ActivityDataCubit extends Cubit<CrStep2ActivityDataState> {
  final GetSubActivities _getSubActivities;
  final GetAccommodationTypes _getAccommodationTypes;
  final GetSubActivityDetails _getSubActivityDetails;
  final SaveActivityDetails _saveActivityDetails;
  final GetAddetionalActivites _getAddetionalActivites;
  final GetAddetionalDetailsActivites _getAddetionalDetailsActivites;
  final GetWarningMessage _getWarningMessage;
  final GetWarningWorkFlowMessage _getWarninFlowMessage;

  CrStep2ActivityDataCubit()
      : _getSubActivities = GetSubActivities(repository: sl()),
        _getAccommodationTypes = GetAccommodationTypes(repository: sl()),
        _getSubActivityDetails = GetSubActivityDetails(repository: sl()),
        _saveActivityDetails = SaveActivityDetails(repository: sl()),
        _getAddetionalActivites = GetAddetionalActivites(repository: sl()),
        _getAddetionalDetailsActivites =
            GetAddetionalDetailsActivites(repository: sl()),
        _getWarningMessage = GetWarningMessage(repository: sl()),
        _getWarninFlowMessage = GetWarningWorkFlowMessage(repository: sl()),
        super(const CrStep2ActivityDataState()) {
    getAccommodationTypes();
  }

  void getSubActivityDetails(SubActivityEntity subActivity) async {
    emit(state.copyWith(
        subActivityDetailsStatus: BlocStatus.loading, errorMessage: ""));
    final response =
        await _getSubActivityDetails(subActivity.id.toString() ?? '');
    response.fold(
        (failure) => emit(state.copyWith(
              subActivityDetailsStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          selectedSubActivity: Nullable(subActivity),
          subActivityDetailsStatus: BlocStatus.success,
          subActivityDetails: Nullable(success.data?.result)));

      if (state.selectedIsicActivity?.craft == false) {
        BottomSheetDialog.showDraggableSheet(
            NavigationService.navigatorKey.currentContext!,
            child: CrStep2ConditionsPage(
              activityTerms: success.data?.result?.activityTerms,
            ));
      }

      if (state.selectedIsicActivity?.craft == true) {
        showCraftMessage();
      }
    });
    getAddetionalActivites();
  }

  void onSelectIsicActivity(IsicActivity isicActivity) async {
    emit(state.copyWith(
        selectedSubActivity: Nullable(null),
        selectedAddetionalList: Nullable([]),
        subActivityDetails: Nullable(null),
        addetionalActivityItems: [],
        addetionalActivityItemDetails: [],
        subActivitiesStatus: BlocStatus.loading,
        errorMessage: ""));
    final response = await _getSubActivities(isicActivity.id ?? '');
    response.fold(
        (failure) => emit(state.copyWith(
              subActivitiesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          selectedIsicActivity: isicActivity,
          subActivitiesStatus: BlocStatus.success,
          subActivities: List.from(success)));
    });
  }

  void getAccommodationTypes() async {
    emit(state.copyWith(accommodationTypesStatus: BlocStatus.loading));
    final response = await _getAccommodationTypes(NoParams());
    response.fold(
        (failure) => emit(state.copyWith(
              accommodationTypesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          accommodationTypesStatus: BlocStatus.success,
          accommodationTypes: List.from(success)));
    });
  }

  void onSelectSubActivity(SubActivityEntity subActivity) async {
    getSubActivityDetails(subActivity);
  }

  void onAccommodationTypes(CrLookupsEntity accommodationTypes) =>
      emit(state.copyWith(selectedAccommodationType: accommodationTypes));

  void updateArea(double? area) {
    emit(state.copyWith(totalArea: area, errorMessage: ""));
  }

  void updateWorkerType(WorkersTypes type) {
    emit(state.copyWith(workerType: type, errorMessage: ""));
  }

  void updateUnitCount(String? value) {
    emit(state.copyWith(unitCount: value, errorMessage: ""));
  }

  void updateAtmFeesPaid(bool? value) {
    emit(state.copyWith(atmFeesPaid: value));
  }

  void save() async {
    int requestId = sl<CommercialLicenseBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _saveActivityDetails(SubmitActivityDetailRequest(
        requestId: requestId,
        workerTypeId: state.workerType!.type,
        area: state.totalArea ?? 0,
        additionalActivities: state.selectedAddetionalList,
        detailedActivityId: state.selectedSubActivity!.id!,
        atmFeesPaid: state.showAtm() ? state.atmFeesPaid : null,
        unitCount:
            state.showHotel() ? int.tryParse(state.unitCount ?? "") : null,
        accommodationTypeId: state.showHotel()
            ? state.selectedAccommodationType?.lookupId
            : null));
    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      sl<CommercialLicenseBloc>().add((const GoToNextPageEvent()));
      emit(state.copyWith(status: BlocStatus.success));
    });
  }

  void onSelectAddetionalDetailsActivity(
      AddetionalActivityItemDetails subActivity) async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response =
        await _getSubActivityDetails(subActivity.activityId.toString() ?? '');
    response.fold(
        (failure) => emit(state.copyWith(
              status: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          status: BlocStatus.success,
          addetionalDetailsItem: Nullable(subActivity),
          addetionalDetails: Nullable(success.data?.result)));

      if (state.selectedIsicActivity?.craft == false) {
        BottomSheetDialog.showDraggableSheet(
            NavigationService.navigatorKey.currentContext!,
            child: CrStep2ConditionsPage(
              activityTerms: success.data?.result?.activityTerms,
            ));
      }

      if (state.selectedIsicActivity?.craft == true) {
        showCraftMessage();
      }
    });
  }

  void addAddetionalItemRequest(double area) async {
    List<AddetionalActivityRequest> selectedAddetionalList =
        state.selectedAddetionalList ?? [];

    String message = await getActivitesSalamaWarningMessage(area);

    emit(state.copyWith(status: BlocStatus.loading));

    selectedAddetionalList.add(AddetionalActivityRequest(
        area: area,
        item: state.addetionalItem,
        details: state.addetionalDetails,
        detailsItem: state.addetionalDetailsItem,
        faweryMessage: message));

    emit(state.copyWith(
        status: BlocStatus.success,
        addetionalItem: Nullable(null),
        addetionalDetails: Nullable(null),
        addetionalDetailsItem: Nullable(null),
        selectedAddetionalList: Nullable(selectedAddetionalList)));
  }

  void onSelectAddetionalActivity(AddetionalActivityItem item) async {
    emit(state.copyWith(
        addetionalActivityDetailsListStatus: BlocStatus.loading,
        errorMessage: ""));
    final response = await _getAddetionalDetailsActivites(
        AddetionalActivityDetailsRequest(
            subActivityId: state.selectedSubActivity!.id.toString(),
            addetionalActivityId: item.isicCode!));
    response.fold(
        (failure) => emit(state.copyWith(
              addetionalActivityDetailsListStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          addetionalActivityDetailsListStatus: BlocStatus.success,
          addetionalItem: Nullable(item),
          addetionalDetails: Nullable(null),
          addetionalDetailsItem: Nullable(null),
          addetionalActivityItemDetails: success.result));
    });
  }

  void getAddetionalActivites() async {
    emit(state.copyWith(
      additionalActivityListStatus: BlocStatus.loading,
      errorMessage: "",
      addetionalItem: Nullable(null),
      addetionalDetails: Nullable(null),
      addetionalDetailsItem: Nullable(null),
      // selectedAddetionalList: Nullable(null)
    ));
    final response = await _getAddetionalActivites(
        state.selectedSubActivity?.id.toString() ?? "");
    response.fold(
        (failure) => emit(state.copyWith(
              additionalActivityListStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {
      emit(state.copyWith(
          additionalActivityListStatus: BlocStatus.success,
          addetionalActivityItems: success.result));
    });
  }

  void deleteAddetionalActivity(int index) {
    List<AddetionalActivityRequest> selectedAddetionalList =
        state.selectedAddetionalList ?? [];

    emit(state.copyWith(status: BlocStatus.loading));

    selectedAddetionalList.removeAt(index);

    emit(state.copyWith(
        status: BlocStatus.success,
        selectedAddetionalList: Nullable(selectedAddetionalList)));
  }

  void getSalamaWarningMessage() async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    try {
      final response = await _getWarningMessage(SalamaWarningRequest(
          activities: state.selectedAddetionalList != null
              ? state.selectedAddetionalList!.map((e) {
                  return Activity(
                      activityId: e.detailsItem?.activityId, area: e.area);
                }).toList()
              : [],
          shopArea: state.totalArea,
          mainActivityId: state.selectedSubActivity?.id ?? 0));
      response.fold((failure) {
        print(failure);
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) {
        emit(state.copyWith(
          status: BlocStatus.success,
        ));

        if (success.isNotEmpty) {
          BottomSheetDialog.showDraggableSheet(
              NavigationService.navigatorKey.currentContext!,
              child: BottomSheetWithActions(
                title: "warning_2".tr(),
                action: Row(
                  children: [
                    Expanded(
                      child: ElevatedButtonWidget.primaryCustom(
                          text: "agree".tr(),
                          onPressed: () {
                            NavigationService.goBack();

                            save();
                          }),
                    ),
                    const CustomHorizontalSpace(width: 32),
                    Expanded(
                      child: ElevatedButtonWidget.primaryCustomBorder(
                          text: "cancelButton".tr(),
                          onPressed: () {
                            NavigationService.goBack();
                          }),
                    ),
                  ],
                ),
                body: SalamaWarningMessage(
                  message: success,
                ),
              ));
        } else {
          save();
        }
      });
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
    }
  }

  Future<String> getActivitesSalamaWarningMessage(double area) async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final response = await _getWarninFlowMessage(SalamaWarningRequest(
        activities: [
          Activity(
              activityId: state.addetionalDetailsItem?.activityId, area: area)
        ],
        shopArea: state.totalArea,
        mainActivityId: state.selectedSubActivity?.id ?? 0));
    return await response.fold((failure) async {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return "";
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
      ));

      return success;
    });
  }

  void showCraftMessage() {
    BottomSheetDialog.showDraggableSheet(
        NavigationService.navigatorKey.currentContext!,
        child: BottomSheetWithActions(
          title: "warning_2".tr(),
          action: Row(
            children: [
              Expanded(
                child: ElevatedButtonWidget.primaryCustom(
                    text: "agree".tr(),
                    onPressed: () {
                      NavigationService.goBack();
                    }),
              ),
            ],
          ),
          body: const WarningMessage(
              message:
                  "<p>عزيزي صاحب المنشأة: وجود عامل حرفي مرخص شرط أساسي لإصدار أو تجديد الرخص التجارية لمنشأتك . بادر بترخيص عمالتك حرفيا على منصة بلدي من خلال الرابط التالي <a href='https://balady.gov.sa/Services/Terms/?id=328'>https://balady.gov.sa/Services/Terms/?id=328 </a> </p>"),
        ));
  }

  void initDraft() async {
    bool isDraft = sl<CommercialLicenseBloc>().state.isDraft ?? false;
    bool draftLoaded = state.draftLoaded ?? false;
    if (draftLoaded == false && isDraft) {
      emit(state.copyWith(
     //   draftStatus: BlocStatus.success,
      ));
      // if (true) {
      CommercialRequestDetailsResponse? requestData =
          sl<CommercialLicenseBloc>().state.requestData;

      RecordInfo? recordInfo = sl<CommercialLicenseBloc>().state.recordInfo;
      print("EEE");
      WorkersTypes? workerType;
      bool? atmFeesPaid;
      IsicActivity? selectedIsicActivity = state.selectedIsicActivity;
      SubActivityEntity? selectedSubActivity = state.selectedSubActivity;
      print("HHHH");
      if (requestData?.activityInfo?.workerTypeId == 1) {
        workerType = WorkersTypes.men;
      }
      if (requestData?.activityInfo?.workerTypeId == 2) {
        workerType = WorkersTypes.women;
      }
      if (requestData?.activityInfo?.workerTypeId == 3) {
        workerType = WorkersTypes.menWomen;
      }

      if (requestData?.activityInfo?.atmActivity == true) {
        atmFeesPaid = requestData?.activityInfo?.atmFeesPaid;
      }

      if (requestData?.activityInfo?.mainActivity?.isicActivityId != null) {
        selectedIsicActivity = recordInfo?.crInfo?.activities?.isicActivities
            ?.firstWhereOrNull((element) =>
                element.isicCode ==
                requestData?.activityInfo?.mainActivity?.isicActivityId
                    .toString());

        final response =
            await _getSubActivities(selectedIsicActivity?.id ?? '');
        response.fold(
            (failure) => emit(state.copyWith(
                  subActivitiesStatus: BlocStatus.failure,
                  errorMessage: (failure as ServerFailure).errorMessage,
                )), (success) {
          emit(state.copyWith(
              selectedIsicActivity: selectedIsicActivity,
              subActivitiesStatus: BlocStatus.success,
              subActivities: List.from(success)));
        });

        if (requestData?.activityInfo?.mainActivity?.detailedActivityId !=
            null) {
          selectedSubActivity = state.subActivities.firstWhereOrNull(
              (element) =>
                  element.id ==
                  requestData?.activityInfo?.mainActivity?.detailedActivityId);

          if (selectedSubActivity != null) {
            getSubActivityDetails(selectedSubActivity);
          }
        }
      }

      List<AddetionalActivityRequest> selectedAddetionalList = [];

      requestData?.activityInfo?.additionalActivities?.forEach((activity) {
        selectedAddetionalList.add(
          AddetionalActivityRequest(
              area: activity.area,
              item: AddetionalActivityItem(
                  isicCode: activity.isicActivityId.toString(),
                  isicName: activity.detailedActivityName),
              detailsItem: AddetionalActivityItemDetails(
                activityId: activity.detailedActivityId,
                isicName: activity.detailedActivityName,
              ),
              faweryMessage: activity.salamaWorkflow),
        );
      });

      /// Hear Need Add The activities
      emit(state.copyWith(
          totalArea: requestData?.shopArea,
          workerType: workerType,
          selectedIsicActivity: selectedIsicActivity,
          atmFeesPaid: atmFeesPaid,
          draftLoaded: true,
          selectedAddetionalList: Nullable(selectedAddetionalList),
          draftStatus: BlocStatus.success,
          selectedSubActivity: Nullable(selectedSubActivity)));
    } else {
      emit(state.copyWith(draftStatus: BlocStatus.success));
    }
  }
}
