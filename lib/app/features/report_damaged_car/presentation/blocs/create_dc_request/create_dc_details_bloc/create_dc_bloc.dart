import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../core/errors/failures.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/services/local/use_case.dart';
import '../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../../_shared_feature_/data/entities/validators/incident_desc_validation.dart';
import '../../../../../_shared_feature_/data/entities/validators/required_field_validation.dart';
import '../../../../../vd/domain/entities/camera/attachment_item.dart';
import '../../../../../vd/domain/entities/categories/category_item.dart';
import '../../../../../vd/domain/entities/create_incident/create_incident_params.dart';
import '../../../../../vd/domain/entities/create_vd_page_params.dart';
import '../../../../../vd/domain/entities/gis/gis_params.dart';
import '../../../../../vd/domain/entities/gis/gis_response.dart';
import '../../../../../vd/domain/entities/map/map_screen_params.dart';
import '../../../../../vd/domain/entities/upload/upload_file_params.dart';
import '../../../../../vd/domain/use_cases/get_gis_data.dart';
import '../../../../../vd/presentation/dialogs/duplicate_request_dialog.dart';
import '../../../../damaged_cars_exports.dart';
import '../../../../domain/entities/car_model.dart';
import '../../../../domain/entities/car_type.dart';
import '../../../widgets/create_dc_request/details_widgets/location_photo_section.dart';
import '../../../widgets/create_dc_request/summery_widgets/summury_section.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'create_dc_event.dart';

part 'create_dc_state.dart';

class CreateDCBloc extends Bloc<CreateDCEvent, CreateDCState> {
  PageController controller = PageController();
  late List pagesList = [
    LocationPhotoSection(),
    IncidentCarInfoSection(),
    IncidentCarPlateSection(),
    IncidentDescSection(),
    SummurySection()
  ];

  final GetGISData _getGisData;
  final CreateDamagedCarInc _createIncidentRegistered;
  final UploadFile _uploadFile;
  final GetCarModels _getCarModels;
  final GetCarTypes _getCarTypes;
  final CheckActiveLocation _checkActiveLocation;

  CreateDCBloc({
    CreateVDParamsPage? params,
  })  : _getGisData = GetGISData(repository: sl()),
        _createIncidentRegistered = CreateDamagedCarInc(repository: sl()),
        _uploadFile = UploadFile(repository: sl()),
        _getCarModels = GetCarModels(repository: sl()),
        _getCarTypes = GetCarTypes(repository: sl()),
        _checkActiveLocation = CheckActiveLocation(repository: sl()),
        super(CreateDCState(
            items: params?.files ?? [],
            selectedCategory: params?.selectedCategory,
            isFromHome: params?.isFromHome,
            location: params?.location,
            currentUserlocation: params?.location,
            gisResponse: params?.gisResponse)) {
    on<CreateDCEvent>((event, emit) {
      controller.addListener(() {});
    });

    on<EditCreateVDPageEvent>(_editCreateVDPageHandler);

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    /*--- Form Fields  Events --- */

    on<ChangeAddressEvent>(_changeAddressHandler);
    on<ChangeIssueDescEvent>(_changeIssueDescHandler);
    on<ChangeAgreementEvent>(_changeAgreementHandler);
    on<SelectCarModelEvent>(_selectCarModelEventHandler);
    on<SelectReportTypeEvent>(_selectReportTypeEventHandler);
    on<SelectRegisterTypeEvent>(_selectRegisterTypeEventHandler);

    on<ChangeCarDetailsEvent>(_changeCarDetailsFieldsHandler);

    /*--- Submissions  Events --- */

    on<UploadFileEvent>(_uploadFileHandler);
    on<SubmitIncidentEvent>(_submitIncidentHandler);
    on<CreateIncidentRegisteredEvent>(_createIncidentRegisteredHandler);

    /*--- Get Models Events --- */

    on<GetCarTypesEvent>(_getCardTypesHandler);
    on<GetCarModelsEvent>(_getCardModelsHandler);

    add(GetCarTypesEvent());
  }

  Future<void> _editCreateVDPageHandler(
      EditCreateVDPageEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        items: e.params.files,
        isFromHome: e.params.isFromHome,
        location: e.params.location,
        currentUserlocation: e.params.location,
        gisResponse: e.params.gisResponse,
        selectedCategory: e.params.selectedCategory));
  }

  Future<void> _changeIssueDescHandler(
      ChangeIssueDescEvent e, Emitter emitter) async {
    emitter(state.copyWith(errorMessage: "", issueDesc: e.text));
  }

  Future<void> _changeCarDetailsFieldsHandler(
      ChangeCarDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      errorMessage: "",
      chassisNumber: e.chassisNumber,
      leftLetter: e.leftLetter,
      middleLetter: e.middleLetter,
      rightLetter: e.rightLetter,
      plateDigit: e.plateDigit,
    ));
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    hideKeyboard();

    emitter(state.copyWith(
      agreement: e.isagree,
    ));
  }

  Future<void> _submitIncidentHandler(
      SubmitIncidentEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    AttachmentItem? item = state.items.firstOrNull;
    if (item != null && item.fileId == null) {
      var failureOrSuccess = await _uploadFile(
          UploadFileParams(attachStream: item.base64, filePath: item.filePath));
      await failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) {
        List<AttachmentItem> items = state.items.map((e) {
          if (e.index == e.index) {
            e.fileId = success.fileId;
          }
          return e;
        }).toList();
        emitter(state.copyWith(
          status: BlocStatus.success,
          items: items,
          errorMessage: "",
        ));
        if (CommonProperties.isLoggedInMunicipality) {
          add(CreateIncidentRegisteredEvent());
        } else {}
      });
    } else {
      if (CommonProperties.isLoggedInMunicipality) {
        add(CreateIncidentRegisteredEvent());
      } else {}
    }
  }

  Future<void> _createIncidentRegisteredHandler(
      CreateIncidentRegisteredEvent e, Emitter emitter) async {
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));
    CreateIncidentParams params = e.params ??
        CreateIncidentParams(
          municipalityID: state.gisResponse?.adminMunicipalityId,
          subMunicipalityID: state.gisResponse?.municipalityId,
          sub_SubMunicipalityID: state.gisResponse?.subMunicipalityId,
          latitude: state.location?.y.toString(),
          longitude: state.location?.x.toString(),
          address: state.gisResponse?.getFullAddress(),
          streetName: state.gisResponse?.streetName,
          districtName: state.gisResponse?.districtName,
          splClassificationID: RemoteConfig.damagedCarsClass,
          issueDescription: state.issueDesc,
          chassisNumber: state.chassisNumber,
          vehicleClassification: state.reportType?.id,
          vehicleModel: state.selectedCarModel?.carName,
          vehicleType: state.selectedCarType?.brandName,
          leftLetter: state.leftLetter,
          middleLetter: state.middleLetter,
          rightLetter: state.rightLetter,
          plateDigit: state.plateDigit,
          attachments: state.items.map((e) => e.fileId ?? "").toList(),
        );
    final failureOrSuccess = await _createIncidentRegistered(params);

    failureOrSuccess.fold((failure) {
      ServerFailure serverFailure = (failure as ServerFailure);

      if (serverFailure.errorCode == "CS_API_023") {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: "",
        ));

        showDialog(
            context: NavigationService.navigatorKey.currentState!.context,
            barrierDismissible: false,
            builder: (ctx) => Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: DuplicateRequestDialog(
                  onSelect: (bool? value) {
                    if (value != null && value == true) {
                      CreateIncidentParams newParams =
                          params.copyWith(continueIncidentCreation: "YES");
                      add(CreateIncidentRegisteredEvent(params: newParams));
                    } else {
                      //continueIncidentCreation = null;
                      if (value == false) {
                        int count = 0;
                        NavigationService.navigatorKey.currentState!
                            .popUntil((_) => count++ >= 3);
                      }
                    }
                  },
                  title: ("duplicate_incident_title").tr(),
                  body: ("duplicate_incident_body").tr(),
                  confirmButtonText: ("duplicate_incident_dialog_yes").tr(),
                  cancelButtonText: ("duplicate_incident_dialog_no").tr(),
                )));
      } else {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: serverFailure.errorMessage,
        ));
      }
    }, (success) {
      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute, predicate,
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.dc,
              fromHomePage: state.isFromHome,
              thanksMessage: success.data?.responseMessage));
      //  Helpers.sendEventToAnalytics(AppEvents.VD_Success_Registered_Submit);
    });
  }

  Future<void> _uploadFileHandler(UploadFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _uploadFile(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<AttachmentItem> items = state.items.map((e) {
        if (e.index == e.index) {
          e.fileId = success.fileId;
        }
        return e;
      }).toList();
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: items,
        errorMessage: "",
      ));
    });
  }

  void cancelIncident() {
    hideKeyboard();
    bool Function(Route<dynamic>) predicate =
        ModalRoute.withName(RouteName.bottomNavigation);
    NavigationService.navigatorKey.currentState!.popUntil((predicate));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      await controller.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      await controller.animateToPage(prvoiusPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: prvoiusPage));
    }
    hideKeyboard();
  }

  Future<void> _changeAddressHandler(
      ChangeAddressEvent e, Emitter emitter) async {
    GISParams? currentLocation;
    if (state.currentUserlocation == null) {
      Position? pos;
      try {
        emitter(state.copyWith(status: BlocStatus.loading));
        pos = (await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 6)));
        if (pos == null) pos = (await Geolocator.getLastKnownPosition());
        emitter(state.copyWith(status: BlocStatus.success));
      } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
        emitter(state.copyWith(status: BlocStatus.success));
        if (pos == null)
          try {
            pos = (await Geolocator.getLastKnownPosition());
          } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
      }
      if (pos != null)
        currentLocation = GISParams(x: pos.longitude, y: pos.latitude);
    } else {
      currentLocation = state.currentUserlocation;
    }

    await NavigationService.navigatorKey.currentState!
        .pushNamed(RouteName.dcMapRoute,
            arguments: MapScreenParams(
                gisParams: state.location ?? currentLocation,
                gisResponse: state.gisResponse,
                currentUserLocation: currentLocation))
        .then((value) {
      if (value != null) {
        MapScreenParams? params = value as MapScreenParams;
        emitter(state.copyWith(
            gisResponse: params.gisResponse,
            location: params.gisParams,
            currentUserlocation: params.currentUserLocation));
      }
    });
  }

  Future<void> _getCardModelsHandler(
      GetCarModelsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading, clearCarModel: true));

    final failureOrSuccess = await _getCarModels(e.item!.id!);

    failureOrSuccess.fold((failure) {
      ServerFailure serverFailure = (failure as ServerFailure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: serverFailure.errorMessage,
      ));
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        carModels: r ?? [],
        errorMessage: "",
        selectedCarType: state.carTypes
            ?.firstWhereOrNull((element) => element.brandName == e.item?.id),
      ));
    });
  }

  Future<void> _getCardTypesHandler(GetCarTypesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCarTypes(NoParams());

    failureOrSuccess.fold((failure) {
      ServerFailure serverFailure = (failure as ServerFailure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: serverFailure.errorMessage,
      ));
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        carModels: [],
        carTypes: r,
        errorMessage: "",
      ));
    });
  }

  Future<void> _selectCarModelEventHandler(
      SelectCarModelEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      selectedCarModel: state.carModels
          ?.firstWhereOrNull((element) => element.id == e.item?.id),
    ));
  }

  Future<void> _selectReportTypeEventHandler(
      SelectReportTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(reportType: e.item));
  }

  Future<void> _selectRegisterTypeEventHandler(
      SelectRegisterTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(registerType: e.item));
  }

  bool isLastPage() {
    return state.currentPageValue == (pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
