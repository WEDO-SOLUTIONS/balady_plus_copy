import 'dart:math';

import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/addetional_activity_request.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/save_location_data_request.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/save_location_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/sub_activit_entity.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/use_cases/get_accommodation_types.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/use_cases/get_sub_activities.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/use_cases/get_sub_activity_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/use_cases/step2_save_activity_details.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/use_cases/step2_save_location_details.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:dgis_map/dgis_map_controller.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../../features/municipal_services/municipal_advisor/domain/use_cases/get_gis_image.dart';
import '../../../../../../../features/vd/domain/entities/gis/gis_params.dart';
import '../../../../../../../features/vd/domain/entities/gis/gis_response.dart';
import '../../../../../../../features/vd/domain/entities/map/map_screen_params.dart';
import '../../../../../../../features/vd/domain/use_cases/get_gis_data.dart';
import '../../../../data/models/initialApproval/fees_request.dart';
import '../../../../data/models/initialApproval/isics_main_activity.dart';
import '../../../../data/models/initialApproval/request_details_model.dart';
import '../../../../data/models/initialApproval/save_activity_and_location_response_model.dart';
import '../../../../data/models/initialApproval/sub_activity_details_data.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../data/models/initialApproval/submit_activity_details_request.dart';
import '../../../../data/models/lookups_model.dart';
import '../../../../domain/use_cases/setp2_caluclate_fees_interactively.dart';
import '../../../../domain/use_cases/setp2_get_spl_notification.dart';
import '../../commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';


import '../../step3/bloc/step3_conclusion_cubit.dart';
import '../widgets/intactive_calculator_fees.dart';
part 'step2_activity_data_export_state.dart';
part 'map_export_event.dart';

class Step2ActivityDataExportCubit extends   Bloc<MapExportEvent, Step2ActivityDataExportState> {
  final GetSubActivities _getSubActivities;
  final GetAccommodationTypes _getAccommodationTypes;
  final GetSubActivityDetails _getSubActivityDetails;
  final SaveActivityDetails _saveActivityDetails;
  CaluclateFeesInteractively _caluclateFeesInteractively;
  GetSPLNotification _getSPLNotification;




  TextEditingController mapNpController = TextEditingController();
  TextEditingController landNpController = TextEditingController();
  final GetGISData _getGisData;
  late DgisMapController mapController;
  final SaveLocationDetails _saveLocationDetails;
  final GetGISImage _getGISImage;

  Step2ActivityDataExportCubit()
      : _getSubActivities = GetSubActivities(repository: sl()),
        _caluclateFeesInteractively = CaluclateFeesInteractively(repository: sl()),
        _getAccommodationTypes = GetAccommodationTypes(repository: sl()),
        _getSubActivityDetails = GetSubActivityDetails(repository: sl()),
        _saveActivityDetails = SaveActivityDetails(repository: sl()),
        _getGisData = GetGISData(repository: sl()),
        _saveLocationDetails = SaveLocationDetails(repository: sl()),
        _getGISImage = GetGISImage(sl()),
        _getSPLNotification = GetSPLNotification(repository:sl()),

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

  void calculateFeesInteractivly() async {

    if(state.location?.lon != null && state.location?.lat != null && state.selectedSubActivity?.id != null) {
      emit(state.copyWith(status: BlocStatus.loading, errorMessage: "",));

      FeesRequest request = FeesRequest();
      request.requestId = sl<CommercialLicenseInitialAprrovalBloc>().state.requestId!;
      request.latitude = state.location?.lat.toString();
      request.longitude =  state.location?.lon.toString();
      request.mainDetailedActivityId = state.selectedSubActivity!.id!;
      final response = await _caluclateFeesInteractively(request);
      response.fold(
              (failure) =>
              emit(state.copyWith(
                status: BlocStatus.failure,
                errorMessage: (failure as ServerFailure).errorMessage,
              )), (res) {
               emit(state.copyWith(status: BlocStatus.success,));
                if(res.activitiesCostDetailes != null) {

                  BottomSheetDialog.showDraggableSheet(
                      NavigationService.navigatorKey.currentContext!,
                      backgroundColor:AppColor.black,
                      child: BottomSheetWithActions(
                          title: "intial_approval_fees".tr(),
                          action: ElevatedButtonWidget.primaryCustom(
                              text: "agree".tr(),
                              onPressed: () {
                                NavigationService.goBack();
                              }),
                          body:IntactiveCalculatorFees( model: res,)
                      ));



                }



      });
    }
  }

  void _handleSPLNotication() async {

    if(state.gisResponse != null && state.gisResponse?.subMunicipalityguid != null && sl<CommercialLicenseInitialAprrovalBloc>().state.requestDetails != null) {
      emit(state.copyWith(status: BlocStatus.loading, errorMessage: "",));


      final response = await _getSPLNotification(["${sl<CommercialLicenseInitialAprrovalBloc>().state.requestDetails?.requestType?.id!}",state.gisResponse!.subMunicipalityguid!]);
     // final response = await _getSPLNotification(["1004","1f89e13e-2cab-4794-ae57-d6b45d9877d4"]);

      response.fold(
              (failure) =>
              emit(state.copyWith(
                status: BlocStatus.failure,
                errorMessage: (failure as ServerFailure).errorMessage,
              )), (res) {
        emit(state.copyWith(status: BlocStatus.success,));
        if(res.isNotEmpty) {

          emit(state.copyWith(
            status: BlocStatus.success,
            errorMessage: "",
            splNotification: res
          ));


          // BottomSheetDialog.showDraggableSheet(
          //     NavigationService.navigatorKey.currentContext!,
          //     backgroundColor:AppColor.black,
          //     child: BottomSheetWithActions(
          //         title: "warning_2".tr(),
          //         action: ElevatedButtonWidget.primaryCustom(
          //             text: "agree".tr(),
          //             onPressed: () {
          //               NavigationService.goBack();
          //             }),
          //
          //
          //         body:Text(res)
          //     ));



        }



      });
    }
  }


  void getSubActivityDetails(SubActivityEntity subActivity,bool? draft) async {
    if(subActivity.id == null) return;
    emit(state.copyWith(
        subActivityDetailsStatus: BlocStatus.loading, errorMessage: "",
        userSelectedAddetionalItem:draft==true?null: Nullable(null),
        lstSelectedAddetionalActivities:draft==true?null: Nullable(null)
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

      calculateFeesInteractivly();

    });

  }
  void onSelectIsicActivity(IsicsMainActivity isicActivity,bool? draft) async {
    if(isicActivity.id == null||isicActivity.id.toString().isEmpty) return;

    emit(state.copyWith(
        selectedSubActivity:draft==true?null: Nullable(null),
        subActivityDetails: draft==true?null: Nullable(null),
        lstAddetionalActivities:draft==true?null:  [],
        lstSelectedAddetionalActivities: draft==true?null: Nullable([]

        ),

        subActivitiesStatus: BlocStatus.loading,
        errorMessage: ""));
//4617349072
    int? requestId= sl<CommercialLicenseInitialAprrovalBloc>().state.requestId;
    final response = await _getSubActivities([requestId!,int.parse(isicActivity.id)]);
    response.fold(
        (failure) => emit(state.copyWith(
              subActivitiesStatus: BlocStatus.failure,
              errorMessage: (failure as ServerFailure).errorMessage,
            )), (success) {

      emit(state.copyWith(
          selectedIsicActivity: Nullable(isicActivity),
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
    getSubActivityDetails(subActivity,false);

  }
  void onAccommodationTypes(LookupsModel accommodationTypes) =>
      emit(state.copyWith(selectedAccommodationType: Nullable(accommodationTypes)));
  void updateArea(double? area) {
    emit(state.copyWith(totalArea: area, errorMessage: ""));
  }
  void updateWorkerType(WorkerTypes type) {
    emit(state.copyWith(selectedWorkerType: Nullable(type), errorMessage: ""));
  }
  void updateUnitCount(String? value) {
    if(value != null && value.isNotEmpty) {
      emit(state.copyWith(unitCount: int.parse(value), errorMessage: ""));
    }
  }
  void updateAtmFeesPaid(bool? value) {
    emit(state.copyWith(atmFeesPaid: value));
  }



  void addAddetionalItemRequest({AllowedActivities? activity,required double area}) async {
    List<AddetionalActivityRequest> selectedAddetionalList =
        state.lstSelectedAddetionalActivity ?? [];


    emit(state.copyWith(status: BlocStatus.loading));

  selectedAddetionalList.add(AddetionalActivityRequest(area: area, item: activity?? state.userSelectedAddetionalItem,));


    emit(state.copyWith(
        status: BlocStatus.success,
        userSelectedAddetionalItem: Nullable(null),
        lstSelectedAddetionalActivities: Nullable(selectedAddetionalList)));

    List<AddetionalActivityRequest> selectedAddetionalList11 =
        state.lstSelectedAddetionalActivity ?? [];
  }


  void onSelectAddetionalActivity(AllowedActivities item) async {

    emit(state.copyWith(
        addetionalActivityDetailsListStatus: BlocStatus.success,
        userSelectedAddetionalItem: Nullable(item),
        // addetionalDetails: Nullable(null),
        // addetionalDetailsItem: Nullable(null),
    ));


  }

  void deleteAddetionalActivity(int index) {
    List<AddetionalActivityRequest> selectedAddetionalList =
        state.lstSelectedAddetionalActivity ?? [];

    emit(state.copyWith(status: BlocStatus.loading));

    selectedAddetionalList.removeAt(index);

    emit(state.copyWith(
        status: BlocStatus.success,
        lstSelectedAddetionalActivities: Nullable(selectedAddetionalList)));
  }


  void saveSiteAndActivities(BuildContext context) async {
    int requestId = sl<CommercialLicenseInitialAprrovalBloc>().state.requestId!;

    emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));

    List<RequestExtraActivities> lstRequestExtraActivities = [];
    if(state.lstSelectedAddetionalActivity != null && state.lstSelectedAddetionalActivity!.isNotEmpty) {
      lstRequestExtraActivities = state
          .lstSelectedAddetionalActivity!.map((item) =>
          RequestExtraActivities(
              area: item.area, detailedActivityId: item.item?.isicCode))
          .toList();
    }


    final response = await _saveActivityDetails(
        SubmitActivityDetailRequest(
        requestId: requestId,
        activities:RequestActivity(
            mainActivityId: state.selectedSubActivity!.id!,
            workerTypeId: state.selectedWorkerType!.id!,
            shopArea: state.totalArea ?? 0,
            unitCount: state.showHotel() ? state.unitCount ??0 : null,
            isAtmFeesPaid: state.showAtm() ? state.atmFeesPaid : null,
            accommodationTypeId: state.showHotel() ? state.selectedAccommodationType?.lookupId : null,
            addedActivities:lstRequestExtraActivities,
        ),

        site: RequestSite(

            krokiUrl: state.gisResponse?.locationURL,
           // streetCode: (state.gisResponse?.streetCode?.isEmpty ?? true) ? "-1" : state.gisResponse?.streetCode,
           // subMunicipalityGisCode: state.gisResponse?.municipalityuniquecode,
            //districtCode: state.gisResponse?.Balady_DistrictID,
            latitude: state.location?.lat.toString(),
            longitude: state.location?.lon.toString(),
            mapNumber: state.mapNo,
            landNumber: state.landNo)









    ));
    response.fold(
            (failure) => emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        )), (success) {

     SaveActivityAndLocationResponseModel?  obj= success.data?.result;
      context.read<Step3ConclusionCubit>().add(InitWorkFlowNameEvent(name: obj?.workFlow?.name));
      sl<CommercialLicenseInitialAprrovalBloc>().add((const NextPageEvent()));
      emit(state.copyWith(status: BlocStatus.success));
    });
  }






  void initDraft() async {
    // bool isDraft = sl<CommercialLicenseInitialExportBloc>().state.isDraft ?? false;
    // bool draftLoaded = state.isDraft ?? false;

    if (sl<CommercialLicenseInitialAprrovalBloc>().state.requestId != null &&sl<CommercialLicenseInitialAprrovalBloc>().state.isDraft==true ) {
      emit(state.copyWith(draftStatus: BlocStatus.loading,));

      RequestDetailsModel? requestData = sl<CommercialLicenseInitialAprrovalBloc>().state.requestDetails;

      if(requestData != null) {

        emit(state.copyWith(
            userSelectedAddetionalItem: Nullable(null),
            lstSelectedAddetionalActivities: Nullable(null),
            totalArea: 0.0,
            selectedWorkerType: Nullable(null),
            unitCount:0 ,
            selectedAccommodationType: Nullable(null),
            selectedIsicActivity: Nullable(null),
            atmFeesPaid: false,
            isDraft: true,
            draftStatus: BlocStatus.loading,
            selectedSubActivity: Nullable(null)
        ));


        WorkerTypes? workerType = requestData.activities?.workerType;
        bool? atmFeesPaid;
        IsicsMainActivity? selectedMainActivity = IsicsMainActivity(isicCode: requestData.activities?.mainActivity?.isicId,isicName: requestData.activities?.mainActivity?.isicName );
        SubActivityEntity? selectedSubActivity = SubActivityEntity(activityName: requestData.activities?.mainActivity?.detailedActivityName,id: requestData.activities?.mainActivity?.detailedActivityId,facilityName:requestData.activities?.facility?.name,facilityId: requestData.activities?.facility?.id );


        atmFeesPaid = requestData.activities?.isAtmPaid;

        double? latitude =
        double.tryParse(requestData.location?.latitude ?? "");
        double? longitude =
        double.tryParse(requestData.location?.longitude ?? "");

        if (latitude != null && longitude != null) {
          add(GetGISDataExportEvent(
              params: GISParams(x: longitude, y: latitude),
              popPage: false,
              refreshLocation: true));

          emit(state.copyWith(
            draftStatus: BlocStatus.success,
            location: GISParams(x: longitude, y: latitude),
            userLocation: GISParams(x: longitude, y: latitude),
            mapNo: requestData.location?.mapNumber,
            landNo: requestData.location?.landNumber,

          ));
          mapNpController.text = requestData.location?.mapNumber ?? "";
          landNpController.text = requestData.location?.landNumber ?? "";
        }



        emit(state.copyWith(
            userSelectedAddetionalItem: Nullable(AllowedActivities(isicName:requestData.activities?.addedActivities?[0].isicName,isicCode:int.parse((requestData.activities?.addedActivities?[0].isicId??"0"))  )),
            totalArea: requestData.activities?.shopArea,
            selectedWorkerType: Nullable(workerType),
            unitCount:requestData.activities?.unitCount ,
            selectedAccommodationType: Nullable(requestData.activities?.accommodationType),
            selectedIsicActivity:selectedMainActivity.id != null? Nullable(selectedMainActivity):Nullable(null),
            atmFeesPaid: atmFeesPaid,
            isDraft: true,
            draftStatus: BlocStatus.success,
            selectedSubActivity:selectedSubActivity.id != null? Nullable(selectedSubActivity):Nullable(null)
        ));


        if(requestData.activities!.addedActivities != null) {
          for (int index = 0; index <
              requestData.activities!.addedActivities!.length; index++) {
            AllowedActivities item = AllowedActivities(
                isicName: requestData.activities?.addedActivities?[index].detailedActivityName,
                isicCode: requestData.activities?.addedActivities![index].detailedActivityId);

            addAddetionalItemRequest(
                activity: item, area:requestData.activities!.addedActivities![index].area!);
          }
        }
        if(selectedMainActivity.id != null && selectedMainActivity.id.toString().isNotEmpty ) {
          onSelectIsicActivity(selectedMainActivity,true);
        }
        getSubActivityDetails(selectedSubActivity,true);


      }

    } else {
      emit(state.copyWith(draftStatus: BlocStatus.success));
    }

    // if (draftLoaded == false && isDraft) {
    //   // if (true) {
    //   emit(state.copyWith(
    //     draftStatus: BlocStatus.success,
    //   ));
    //
    // } else {
    //   emit(state.copyWith(
    //     draftStatus: BlocStatus.success,
    //   ));
    // }




  }



  /////// map actions ***************************************************************************

  Future<void> _getGisDataHandler(GetGISDataExportEvent e, Emitter emitter) async {
   if ((state.status == BlocStatus.loading)) return;
   if(e.gisResponse != null)
     {
       emitter(state.copyWith(
         status: BlocStatus.success,
         gisResponse: e.gisResponse,
         mapNo: !e.refreshLocation
             ? e.gisResponse?.planNo != "Null"
             ? e.gisResponse?.planNo ?? ""
             : state.mapNo??""
             : null,
         landNo: !e.refreshLocation
             ? e.gisResponse?.parcelNo != "Null"
             ? e.gisResponse?.parcelNo ?? ""
             : ""
             : null,
         errorMessage: "",
       ));

       if (e.popPage) {

         mapNpController.text =
         e.gisResponse?.planNo != "Null" ? e.gisResponse?.planNo ?? "" : "";
         landNpController.text =
         e.gisResponse?.parcelNo != "Null" ? e.gisResponse?.parcelNo ?? "" : "";
         String? url = await getImageUrl(e.params);

         if (url != null) {
           e.gisResponse?.locationURL = url;

           NavigationService.navigatorKey.currentState
               ?.pop(MapScreenParams(gisParams: e.params, gisResponse: e.gisResponse));
         }

         calculateFeesInteractivly();
         _handleSPLNotication();
       }
       return;
     }
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
            : state.mapNo??""
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

        calculateFeesInteractivly();
        _handleSPLNotication();
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
    int requestId = sl<CommercialLicenseInitialAprrovalBloc>().state.requestId!;
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
      sl<CommercialLicenseInitialAprrovalBloc>().add((const NextPageEvent()));
      sl<CommercialLicenseInitialAprrovalBloc>().updateGISData(gis: state.gisResponse);
      emitter(state.copyWith(status: BlocStatus.success, locationResponse: r));
      sl<CommercialLicenseInitialAprrovalBloc>().add((UpdateFieldEvent(
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
      // mapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(target: LatLng(lat, lng), zoom: 16.0),
      //   ),
      // );


      mapController.moveCamera(
        CameraPositionMessage(
          point: GeoPointMessage(latitude: lat, longitude: lng),
          zoom: 16.0,
          tilt: 0.0,
          bearing: 0.0,
        ),
        0.3, // duration
        CameraAnimationTypeMessage.linear,
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
