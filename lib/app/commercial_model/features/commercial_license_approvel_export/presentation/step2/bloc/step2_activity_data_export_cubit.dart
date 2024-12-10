import 'dart:math';

import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/step2/widgets/map_widgets/warning_message.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../../../../features/municipal_services/municipal_advisor/domain/use_cases/get_gis_image.dart';
import '../../../../../../features/vd/domain/entities/gis/gis_params.dart';
import '../../../../../../features/vd/domain/entities/gis/gis_response.dart';
import '../../../../../../features/vd/domain/entities/map/map_screen_params.dart';
import '../../../../../../features/vd/domain/use_cases/get_gis_data.dart';
import '../../../commercial_license_exports.dart';
import '../../../data/models/additional_activity_details_response.dart';
import '../../../data/models/additional_activity_response.dart';
import '../../../data/models/commercial_request_details_response_entity.dart'
    hide Activity;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../data/models/isics_main_activity.dart';
import '../../../data/models/salama_warning_request.dart';
import '../../../data/models/sub_activity_details_data.dart';
import '../../../domain/entities/addetional_activity_details_request.dart';
import '../../../domain/entities/addetional_activity_request.dart';
import '../../../domain/use_cases/get_additional_activites.dart';
import '../../../domain/use_cases/get_details_additional_activites.dart';
import '../../../domain/use_cases/get_warning_messsage.dart';
import '../../../domain/use_cases/get_warning_workflow_messsage.dart';
import '../page/salama_warning_message.dart';
import 'package:collection/collection.dart';
part 'step2_activity_data_export_state.dart';
part '../../step2/bloc/map_export_event.dart';

class Step2ActivityDataExportCubit extends   Bloc<MapExportEvent, Step2ActivityDataExportState> {
  final GetSubActivities _getSubActivities;
  final GetAccommodationTypes _getAccommodationTypes;
  final GetSubActivityDetails _getSubActivityDetails;
  final SaveActivityDetails _saveActivityDetails;
  final GetAddetionalActivites _getAddetionalActivites;
  final GetAddetionalDetailsActivites _getAddetionalDetailsActivites;
  final GetWarningMessage _getWarningMessage;
  final GetWarningWorkFlowMessage _getWarninFlowMessage;



  TextEditingController mapNpController = TextEditingController();
  TextEditingController landNpController = TextEditingController();
  final GetGISData _getGisData;
  late GoogleMapController mapController;
  final SaveLocationDetails _saveLocationDetails;
  final GetGISImage _getGISImage;

  Step2ActivityDataExportCubit()
      : _getSubActivities = GetSubActivities(repository: sl()),
        _getAccommodationTypes = GetAccommodationTypes(repository: sl()),
        _getSubActivityDetails = GetSubActivityDetails(repository: sl()),
        _saveActivityDetails = SaveActivityDetails(repository: sl()),
        _getAddetionalActivites = GetAddetionalActivites(repository: sl()),
        _getAddetionalDetailsActivites =
            GetAddetionalDetailsActivites(repository: sl()),
        _getWarningMessage = GetWarningMessage(repository: sl()),
        _getWarninFlowMessage = GetWarningWorkFlowMessage(repository: sl()),

        _getGisData = GetGISData(repository: sl()),
        _saveLocationDetails = SaveLocationDetails(repository: sl()),
        _getGISImage = GetGISImage(sl()),


        super( Step2ActivityDataExportState()) {
        getAccommodationTypes();



        ///////////////// map///////////////////
        on<GetGISDataExportEvent>(_getGisDataHandler);
        on<InitMapEvent>(_initMapHandler);
        on<GetCurentLocationEvent>(_getCurrenttUserLocationHandler);
        on<SelectLocationEvent>(_selectLocationEventHandler);
        on<SaveLocationDataEvent>(_saveLocationHandler);
        on<UpdateFieldsEvent>(_updateFieldsHandler);
  }




  /////////Activity Actions*************************************************
  void getSubActivityDetails(SubActivityEntity subActivity) async {
    emit(state.copyWith(
        subActivityDetailsStatus: BlocStatus.loading, errorMessage: "",
        selectedAddetionalItem: Nullable(null),
        addetionalDetails: Nullable(null),
     //   addetionalDetailsItem: Nullable(null),
        lstSelectedAddetionalActivities: Nullable(null)
    ));



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
          subActivityDetails: Nullable(success.data?.result),
         lstAddetionalActivities:  success.data?.result?.allowedActivities
      ));

    });
  }
  void onSelectIsicActivity(IsicsMainActivity isicActivity) async {
    emit(state.copyWith(
        selectedSubActivity: Nullable(null),
        subActivityDetails: Nullable(null),
        lstAddetionalActivities: [],
        lstSelectedAddetionalActivities: Nullable([]),
       // addetionalActivityItemDetails: [],
        subActivitiesStatus: BlocStatus.loading,
        errorMessage: ""));
//4617349072
    int? requestId= sl<CommercialLicenseInitialExportBloc>().state.requestId;
    final response = await _getSubActivities([requestId!,int.parse(isicActivity.id)]);
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
  void onAccommodationTypes(LookupsModel accommodationTypes) =>
      emit(state.copyWith(selectedAccommodationType: accommodationTypes));
  void updateArea(double? area) {
    emit(state.copyWith(totalArea: area, errorMessage: ""));
  }
  void updateWorkerType(WorkerTypes type) {
    emit(state.copyWith(selectedWorkerType: type, errorMessage: ""));
  }
  void updateUnitCount(String? value) {
    emit(state.copyWith(unitCount: value, errorMessage: ""));
  }
  void updateAtmFeesPaid(bool? value) {
    emit(state.copyWith(atmFeesPaid: value));
  }
  void save() async {
    int requestId = sl<CommercialLicenseInitialExportBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    final response = await _saveActivityDetails(SubmitActivityDetailRequest(
        requestId: requestId,
        workerTypeId: state.selectedWorkerType!.id!,
        area: state.totalArea ?? 0,
        additionalActivities: state.lstSelectedAddetionalActivity,
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
      sl<CommercialLicenseInitialExportBloc>().add((const NextPageEvent()));
      emit(state.copyWith(status: BlocStatus.success));
    });
  }
  // void onSelectAddetionalDetailsActivity(
  //     AddetionalActivityItemDetails subActivity) async {
  //   emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
  //   final response =
  //       await _getSubActivityDetails(subActivity.activityId.toString() ?? '');
  //   response.fold(
  //       (failure) => emit(state.copyWith(
  //             status: BlocStatus.failure,
  //             errorMessage: (failure as ServerFailure).errorMessage,
  //           )), (success) {
  //
  //     emit(state.copyWith(
  //         status: BlocStatus.success,
  //         addetionalDetailsItem: Nullable(subActivity),
  //         addetionalDetails: Nullable(success.data?.result)));
  //
  //     // if (state.selectedIsicActivity?.craft == false) {
  //     //   BottomSheetDialog.showDraggableSheet(
  //     //       NavigationService.navigatorKey.currentContext!,
  //     //       child: CrStep2ConditionsPage(
  //     //         activityTerms: success.data?.result?.activityTerms,
  //     //       ));
  //     // }
  //     //
  //     // if (state.selectedIsicActivity?.craft == true) {
  //     //   showCraftMessage();
  //     // }
  //   });
  // }

  void addAddetionalItemRequest(double area) async {
    List<AddetionalActivityRequest> selectedAddetionalList =
        state.lstSelectedAddetionalActivity ?? [];

    //String message = await getActivitesSalamaWarningMessage(area);

    emit(state.copyWith(status: BlocStatus.loading));

    selectedAddetionalList.add(AddetionalActivityRequest(
        area: area,
        item: state.userSelectedAddetionalItem,
        // details: state.addetionalDetails,
        // detailsItem: state.addetionalDetailsItem,
       // faweryMessage: message

    ));

    emit(state.copyWith(
        status: BlocStatus.success,
        selectedAddetionalItem: Nullable(null),
        // addetionalDetails: Nullable(null),
        // addetionalDetailsItem: Nullable(null),
        lstSelectedAddetionalActivities: Nullable(selectedAddetionalList)));
  }
  void onSelectAddetionalActivity(AllowedActivities item) async {


    emit(state.copyWith(
        addetionalActivityDetailsListStatus: BlocStatus.success,
        selectedAddetionalItem: Nullable(item),
        // addetionalDetails: Nullable(null),
        // addetionalDetailsItem: Nullable(null),
    ));



    // emit(state.copyWith(
    //     addetionalActivityDetailsListStatus: BlocStatus.loading,
    //     errorMessage: ""));
    // final response = await _getAddetionalDetailsActivites(
    //     AddetionalActivityDetailsRequest(
    //         subActivityId: state.selectedSubActivity!.id.toString(),
    //         addetionalActivityId: item.isicCode!));
    // response.fold(
    //     (failure) => emit(state.copyWith(
    //           addetionalActivityDetailsListStatus: BlocStatus.failure,
    //           errorMessage: (failure as ServerFailure).errorMessage,
    //         )), (success) {
    //   emit(state.copyWith(
    //       addetionalActivityDetailsListStatus: BlocStatus.success,
    //       addetionalItem: Nullable(item),
    //       addetionalDetails: Nullable(null),
    //       addetionalDetailsItem: Nullable(null),
    //       addetionalActivityItemDetails: success.result));
   // });
  }
  // void getAddetionalActivites() async {
  //   emit(state.copyWith(
  //       additionalActivityListStatus: BlocStatus.loading,
  //       errorMessage: "",
  //       addetionalItem: Nullable(null),
  //       addetionalDetails: Nullable(null),
  //       addetionalDetailsItem: Nullable(null),
  //       selectedAddetionalList: Nullable(null)));
  //   final response = await _getAddetionalActivites(
  //       state.selectedSubActivity?.id.toString() ?? "");
  //   response.fold(
  //       (failure) => emit(state.copyWith(
  //             additionalActivityListStatus: BlocStatus.failure,
  //             errorMessage: (failure as ServerFailure).errorMessage,
  //           )), (success) {
  //     emit(state.copyWith(
  //         additionalActivityListStatus: BlocStatus.success,
  //         addetionalActivityItems: success.result));
  //   });
  // }
  void deleteAddetionalActivity(int index) {
    List<AddetionalActivityRequest> selectedAddetionalList =
        state.lstSelectedAddetionalActivity ?? [];

    emit(state.copyWith(status: BlocStatus.loading));

    selectedAddetionalList.removeAt(index);

    emit(state.copyWith(
        status: BlocStatus.success,
        lstSelectedAddetionalActivities: Nullable(selectedAddetionalList)));
  }
  void getSalamaWarningMessage() async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    try {
      final response = await _getWarningMessage(SalamaWarningRequest(
          activities: state.lstSelectedAddetionalActivity != null
              ? state.lstSelectedAddetionalActivity!.map((e) {
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
  // Future<String> getActivitesSalamaWarningMessage(double area) async {
  //   emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
  //
  //   final response = await _getWarninFlowMessage(SalamaWarningRequest(
  //       activities: [
  //         Activity(
  //             activityId: state.addetionalDetailsItem?.activityId, area: area)
  //       ],
  //       shopArea: state.totalArea,
  //       mainActivityId: state.selectedSubActivity?.id ?? 0));
  //   return await response.fold((failure) async {
  //     emit(state.copyWith(
  //       status: BlocStatus.failure,
  //       errorMessage: (failure as ServerFailure).errorMessage,
  //     ));
  //     return "";
  //   }, (success) {
  //     emit(state.copyWith(
  //       status: BlocStatus.success,
  //     ));
  //
  //     return success;
  //   });
  // }
  // void showCraftMessage() {
  //   BottomSheetDialog.showDraggableSheet(
  //       NavigationService.navigatorKey.currentContext!,
  //       child: BottomSheetWithActions(
  //         title: "warning_2".tr(),
  //         action: Row(
  //           children: [
  //             Expanded(
  //               child: ElevatedButtonWidget.primaryCustom(
  //                   text: "agree".tr(),
  //                   onPressed: () {
  //                     NavigationService.goBack();
  //                   }),
  //             ),
  //           ],
  //         ),
  //         body: WarningMessage(
  //             message:
  //                 "<p>عزيزي صاحب المنشأة: وجود عامل حرفي مرخص شرط أساسي لإصدار أو تجديد الرخص التجارية لمنشأتك . بادر بترخيص عمالتك حرفيا على منصة بلدي من خلال الرابط التالي <a href='https://balady.gov.sa/Services/Terms/?id=328'>https://balady.gov.sa/Services/Terms/?id=328 </a> </p>"),
  //       ));
  // }
  void initDraft() async {
    bool isDraft = sl<CommercialLicenseInitialExportBloc>().state.isDraft ?? false;
    bool draftLoaded = state.draftLoaded ?? false;
    print(isDraft);
    print(draftLoaded);
    if (draftLoaded == false && isDraft) {
      emit(state.copyWith(
        draftStatus: BlocStatus.success,
      ));

      CommercialRequestDetailsResponseEntity? requestData =
          sl<CommercialLicenseInitialExportBloc>().state.requestData;

     // RecordInfo? recordInfo = sl<CommercialLicenseInitialExportBloc>().state.recordInfo;

      WorkerTypes? workerType;
      bool? atmFeesPaid;
      IsicsMainActivity? selectedIsicActivity = state.selectedIsicActivity;
      SubActivityEntity? selectedSubActivity = state.selectedSubActivity;
      if (requestData?.activityInfo?.workerTypeId == 1) {
        workerType = WorkerTypes(id: requestData?.activityInfo?.workerTypeId,name: "men".tr());
      }
      if (requestData?.activityInfo?.workerTypeId == 2) {
        workerType = WorkerTypes(id: requestData?.activityInfo?.workerTypeId,name: "women".tr());
      }
      if (requestData?.activityInfo?.workerTypeId == 3) {
        workerType = WorkerTypes(id: requestData?.activityInfo?.workerTypeId,name: "menWomen".tr());
      }

      if (requestData?.activityInfo?.atmActivity == true) {
        atmFeesPaid = requestData?.activityInfo?.atmFeesPaid;
      }

      // if (requestData?.activityInfo?.mainActivity?.isicActivityId != null) {
      //   selectedIsicActivity = recordInfo?.crInfo?.activities?.isicActivities
      //       ?.firstWhereOrNull((element) =>
      //           element.isicCode ==
      //           requestData?.activityInfo?.mainActivity?.isicActivityId
      //               .toString());
      //
      //   final response =
      //       await _getSubActivities(selectedIsicActivity?.id ?? '');
      //   response.fold(
      //       (failure) => emit(state.copyWith(
      //             subActivitiesStatus: BlocStatus.failure,
      //             errorMessage: (failure as ServerFailure).errorMessage,
      //           )), (success) {
      //     emit(state.copyWith(
      //         selectedIsicActivity: selectedIsicActivity,
      //         subActivitiesStatus: BlocStatus.success,
      //         subActivities: List.from(success)));
      //   });
      //
      //   if (requestData?.activityInfo?.mainActivity?.detailedActivityId !=
      //       null) {
      //     selectedSubActivity = state.subActivities.firstWhereOrNull(
      //         (element) =>
      //             element.id ==
      //             requestData?.activityInfo?.mainActivity?.detailedActivityId);
      //
      //     if (selectedSubActivity != null) {
      //       getSubActivityDetails(selectedSubActivity);
      //     }
      //   }
      // }
      //


      double? latitude =
      double.tryParse(requestData?.locationInfo?.latitude ?? "");
      double? longitude =
      double.tryParse(requestData?.locationInfo?.longitude ?? "");

      if (latitude != null && longitude != null) {
        add(GetGISDataExportEvent(
            params: GISParams(x: longitude, y: latitude),
            popPage: false,
            refreshLocation: true));

        emit(state.copyWith(
          draftLoaded: true,
          draftStatus: BlocStatus.success,
          location: GISParams(x: longitude, y: latitude),
          userLocation: GISParams(x: longitude, y: latitude),
          mapNo: requestData?.locationInfo?.mapNo,
          landNo: requestData?.locationInfo?.landNo,
        ));
        mapNpController.text = requestData?.locationInfo?.mapNo ?? "";
        landNpController.text = requestData?.locationInfo?.landNo ?? "";
      }



      emit(state.copyWith(
          totalArea: requestData?.mainActivityArea?.toDouble(),
          selectedWorkerType: workerType,
          selectedIsicActivity: selectedIsicActivity,
          atmFeesPaid: atmFeesPaid,
          draftLoaded: true,
          draftStatus: BlocStatus.success,
          selectedSubActivity: Nullable(selectedSubActivity)));



    } else {
      emit(state.copyWith(draftStatus: BlocStatus.success));
    }

    if (draftLoaded == false && isDraft) {
      // if (true) {
      emit(state.copyWith(
        draftStatus: BlocStatus.success,
      ));

    } else {
      emit(state.copyWith(
        draftStatus: BlocStatus.success,
      ));
    }




  }



  /////// map actions ***************************************************************************

  Future<void> _getGisDataHandler(GetGISDataExportEvent e, Emitter emitter) async {
    if ((state.status == BlocStatus.loading)) return;
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
    GISParams params = e.params;

    if (e.popPage) params.requestNo = state.requestNo;

    final failureOrSuccess = await _getGisData(e.params);

    await failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      emitter(state.copyWith(
        status: BlocStatus.success,
        gisResponse: success,
        mapNo: !e.refreshLocation
            ? success.planNo != "Null"
            ? success.planNo ?? ""
            : ""
            : null,
        landNo: !e.refreshLocation
            ? success.parcelNo != "Null"
            ? success.parcelNo ?? ""
            : ""
            : null,
        errorMessage: "",
      ));

      if (e.popPage) {
        mapNpController.text =
        success.planNo != "Null" ? success.planNo ?? "" : "";
        landNpController.text =
        success.parcelNo != "Null" ? success.parcelNo ?? "" : "";
        String? url = await getImageUrl(e.params);

        if (url != null) {
          success.locationURL = url;

          NavigationService.navigatorKey.currentState
              ?.pop(MapScreenParams(gisParams: e.params, gisResponse: success));
        }
      }
    });
  }

  Future<String?> getImageUrl(GISParams params) async {
    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final failOrSuccess = await _getGISImage(params);

    return await failOrSuccess.fold((failure) async {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (r) {
      emit(state.copyWith(status: BlocStatus.success, errorMessage: ""));

      return r;
    });
  }

  Future<void> _getCurrenttUserLocationHandler(
      GetCurentLocationEvent e, Emitter emitter) async {
    try {
      emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 20));
      emitter(state.copyWith(
          status: BlocStatus.success,
          location: GISParams(x: position.longitude, y: position.latitude),
          userLocation:
          GISParams(x: position.longitude, y: position.latitude)));
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      Position? position;
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
      if (position != null) {
        emitter(state.copyWith(
            status: BlocStatus.success,
            location: GISParams(x: position.longitude, y: position.latitude),
            userLocation:
            GISParams(x: position.longitude, y: position.latitude)));
      }
    }

    add(GetGISDataExportEvent(
        params: state.location!, popPage: false, refreshLocation: true));

    animateCamera(state.location!.y, state.location!.x);
  }

  Future<void> _selectLocationEventHandler(
      SelectLocationEvent e, Emitter emitter) async {
    print("SelectLocationEvent");
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    emitter(state.copyWith(
        status: BlocStatus.success,
        isLocationAllowed: true,
        location: GISParams(x: e.location.longitude, y: e.location.latitude)));
    add(GetGISDataExportEvent(
        params: GISParams(x: e.location.longitude, y: e.location.latitude),
        popPage: false));
  }

  Future<void> _saveLocationHandler(
      SaveLocationDataEvent e, Emitter emitter) async {
    int requestId = sl<CommercialLicenseInitialExportBloc>().state.requestId!;
    emitter(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    final failOrSuccess = await _saveLocationDetails(SaveLocationDataRequest(
        requestId: requestId,
        krokiUrl: state.gisResponse?.locationURL,
        streetCode: (state.gisResponse?.streetCode?.isEmpty ?? true)
            ? "-1"
            : state.gisResponse?.streetCode,
        subMunicipalityGisCode: state.gisResponse?.municipalityuniquecode,
        districtCode: state.gisResponse?.Balady_DistrictID,
        latitude: state.location?.lat,
        longitude: state.location?.lon,
        mapNo: state.mapNo,
        landNo: state.landNo));

    await failOrSuccess.fold((l) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage));
    }, (r) async {
      sl<CommercialLicenseInitialExportBloc>().add((const NextPageEvent()));
      sl<CommercialLicenseInitialExportBloc>().updateGISData(gis: state.gisResponse);
      emitter(state.copyWith(status: BlocStatus.success, locationResponse: r));
      sl<CommercialLicenseInitialExportBloc>().add((UpdateFieldEvent(
          saveLocationResponse: r, requestId: requestId)));
    });
  }

  Future<void> _updateFieldsHandler(
      UpdateFieldsEvent e, Emitter emitter) async {
    emitter(state.copyWith(mapNo: e.mapNo, landNo: e.landNo, errorMessage: ""));
  }

  Future<void> _initMapHandler(InitMapEvent e, Emitter emitter) async {
    if (state.readOnly == true) {
    } else {
      if (state.location != null && state.gisResponse == null) {
        add(GetGISDataExportEvent(params: state.location!, popPage: false));
      } else if (state.location != null && state.gisResponse != null) {
      } else {
        try {
          emitter(state.copyWith(status: BlocStatus.loading));

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best,
              timeLimit: const Duration(seconds: 20));
          emitter(state.copyWith(
              status: BlocStatus.success,
              location: GISParams(x: position.longitude, y: position.latitude),
              userLocation:
              GISParams(x: position.longitude, y: position.latitude)));
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
          Position? position;
          try {
            position = await Geolocator.getLastKnownPosition();
          } catch (error, stackTrace) {
            LogsViewModel().sendEventFromModel(
              event: ErrorExceptionModel(
                nameEvent: EventsName.handledException,
                message: error.toString(),
                stackTrace: stackTrace.toString(),
              ),
            );
          }
          if (position != null) {
            emitter(state.copyWith(
                status: BlocStatus.success,
                location:
                GISParams(x: position.longitude, y: position.latitude),
                userLocation:
                GISParams(x: position.longitude, y: position.latitude)));
          }
        }

        if (state.location == null) {
          emitter(state.copyWith(
              status: BlocStatus.success,
              location: GISParams(
                  x: CommonProperties.defaultLocation.longitude,
                  y: CommonProperties.defaultLocation.latitude),
              userLocation: GISParams(
                  x: CommonProperties.defaultLocation.longitude,
                  y: CommonProperties.defaultLocation.latitude)));
        }
      }
      animateCamera(state.location!.y, state.location!.x);
    }
  }

  void animateCamera(double lat, double lng) {
    try {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
        ),
      );
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    if (lat1 == null || lon1 == null || lat2 == null || lon2 == null) return 0;
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  bool checkDistanceBetweenUserLocationAndSelectedLocation(
      {LatLng? userLocation, LatLng? selectedLocation}) {
    if (userLocation == null || selectedLocation == null) return false;
    double distanceInMeters = calculateDistance(
        userLocation.latitude,
        userLocation.longitude,
        selectedLocation.latitude,
        selectedLocation.longitude);

    if (distanceInMeters <= RemoteConfig.mapRadius) {
      return true;
    }
    return false;
  }

  static showCustomDialog(Widget dialog, {bool isDismiss = true}) {
    showDialog(
        context: NavigationService.navigatorKey.currentState!.context,
        barrierDismissible: isDismiss,
        builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: dialog));
  }

  // void initDraft() async {
  //   bool isDraft = sl<CommercialLicenseInitialExportBloc>().state.isDraft ?? false;
  //   bool draftLoaded = state.draftLoaded ?? false;
  //
  //   print(isDraft);
  //   print(draftLoaded);
  //   if (draftLoaded == false && isDraft) {
  //     // if (true) {
  //     emit(state.copyWith(
  //       draftStatus: BlocStatus.success,
  //     ));
  //     CommercialRequestDetailsResponseEntity? requestData =
  //         sl<CommercialLicenseInitialExportBloc>().state.requestData;
  //
  //     double? latitude =
  //     double.tryParse(requestData?.locationInfo?.latitude ?? "");
  //     double? longitude =
  //     double.tryParse(requestData?.locationInfo?.longitude ?? "");
  //
  //     if (latitude != null && longitude != null) {
  //       add(GetGISDataExportEvent(
  //           params: GISParams(x: longitude, y: latitude),
  //           popPage: false,
  //           refreshLocation: true));
  //
  //       emit(state.copyWith(
  //         draftLoaded: true,
  //         draftStatus: BlocStatus.success,
  //         location: GISParams(x: longitude, y: latitude),
  //         userLocation: GISParams(x: longitude, y: latitude),
  //         mapNo: requestData?.locationInfo?.mapNo,
  //         landNo: requestData?.locationInfo?.landNo,
  //       ));
  //
  //       print("LANNNND ${requestData?.locationInfo?.landNo}");
  //       mapNpController.text = requestData?.locationInfo?.mapNo ?? "";
  //       landNpController.text = requestData?.locationInfo?.landNo ?? "";
  //     }
  //   } else {
  //     emit(state.copyWith(
  //       draftStatus: BlocStatus.success,
  //     ));
  //   }
  // }



}
