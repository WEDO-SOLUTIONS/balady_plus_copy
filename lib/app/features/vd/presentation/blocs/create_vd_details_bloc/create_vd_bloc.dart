import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:formz/formz.dart';
import 'package:balady_plus/app/features/vd/presentation/pages/guest_otp_page/vd_guest_otp_screen.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart'
    show
        getPageList,
        AttachmentItem,
        SplParams,
        CreateVDParamsPage,
        CategoryItem,
        SplResponse,
        CreateIncidentParams,
        GISResponse,
        GISParams,
        CheckCR,
        MapScreenParams,
        SplItem,
        SPLDetailsParams,
        SPLDetailsResponse,
        GetSpecialClassifications,
        GetGISData,
        CreateIncidentRegistered,
        CreateIncidentUnRegistered,
        GetOTP,
        ValueItem,
        OTPParams,
        GetSPLDetails,
        UploadFile,
        UploadFileParams,
        OTPResponse;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/services/local/shared_prefs_manager.dart';
import '../../../../../core/utils/constants/keys/general_keys.dart';
import '../../../../../core/utils/constants/remote_config.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../_shared_feature_/data/entities/validators/incident_desc_validation.dart';
import '../../../../_shared_feature_/data/entities/validators/name_validation.dart';
import '../../../../_shared_feature_/data/entities/validators/phone_number_validation.dart';
import '../../dialogs/duplicate_request_dialog.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'create_vd_event.dart';

part 'create_vd_state.dart';

class CreateVDBloc extends Bloc<CreateVDEvent, CreateVDState> {
  PageController controller = PageController();
  late List pagesList = getPageList();

  final GetGISData _getGisData;
  final CreateIncidentRegistered _createIncidentRegistered;
  final CreateIncidentUnRegistered _createIncidentUnRegistered;
  final GetOTP _getOTP;
  final GetSPLDetails _getSPLDetails;
  final UploadFile _uploadFile;
  final GetSpecialClassifications _getSplList;
  final CheckCR _checkCR;

  CreateVDBloc(
      {CreateVDParamsPage? params,
      required GetGISData getGisData,
      required CreateIncidentRegistered createIncidentRegistered,
      required CreateIncidentUnRegistered createIncidentUnRegistered,
      required GetOTP getOTP,
      required GetSPLDetails getSPLDetails,
      required UploadFile uploadFile,
      required GetSpecialClassifications getSplList,
      required CheckCR checkCR})
      : _getSplList = getSplList,
        _getGisData = getGisData,
        _createIncidentRegistered = createIncidentRegistered,
        _createIncidentUnRegistered = createIncidentUnRegistered,
        _getOTP = getOTP,
        _getSPLDetails = getSPLDetails,
        _uploadFile = uploadFile,
        _checkCR = checkCR,
        super(CreateVDState(
          items: params?.files ?? [],
          selectedCategory: params?.selectedCategory,
          splResponse: params?.splResponse,
          splItems: params?.splResponse?.items,
          // isFromHome: params?.isFromHome,
          location: params?.location,
          currentUserlocation: params?.location,
          gisResponse: params?.gisResponse,
          pageType: params?.pageType,
          qrCodeFlow: params?.qrCodeFlow ?? false,
          firstName: !CommonProperties.isLoggedInMunicipality
              ? sharedPrefs.getGuestFirstName()
              : null,
          lastName: !CommonProperties.isLoggedInMunicipality
              ? sharedPrefs.getGuestLastName()
              : null,
          mobileNumber: !CommonProperties.isLoggedInMunicipality
              ? sharedPrefs.getGuestMobile()
              : null,
        )) {
    on<CreateVDEvent>((event, emit) {
      controller.addListener(() {});
    });

    on<EditCreateVDPageEvent>(_editCreateVDPageHandler);

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    /*--- Search SPL   Events --- */
    on<SearchForSPLEvent>(_searchForSPLEventHandler);
    on<ShowSPLSearchEvent>(_showSPLSearchHandler);

    /*--- Form Fields  Events --- */

    on<ChangeAddressEvent>(_changeAddressHandler);
    on<ChangeIssueDescEvent>(_changeIssueDescHandler);
    on<ChangeAgreementEvent>(_changeAgreementHandler);
    on<GetSPLDetailsEvent>(_getSPLDetailsHandler);

    /*--- Guest Fields  Events --- */
    on<ChangeGuestFirstNameEvent>(_changeGuestFirstNameHandler);
    on<ChangeGuestLastNameEvent>(_changeGuestLastNameHandler);
    on<ChangeGuestMobileEvent>(_changeGuestMobileHandler);

    /*--- Addetional Fields  Events --- */

    on<ChangeSelectedTextValueEvent>(_changeSelectedTextValueHandler);
    on<ChangeSelectedDropDownValueEvent>(_changeSelectedDropDownValueHandler);
    on<ChangeSelectedMultiSelectValueEvent>(
        _changeSelectedMultiSelectValueHandler);

    /*--- Submissions  Events --- */

    on<UploadFileEvent>(_uploadFileHandler);
    on<GetOTPEvent>(_getOTPHandler);
    on<SubmitIncidentEvent>(_submitIncidentHandler);
    on<CreateIncidentRegisteredEvent>(_createIncidentRegisteredHandler);
    on<CreateIncidentUnRegisteredEvent>(_createIncidentUnRegisteredHandler);

    on<GetSplListEvent>(_getVDSplListHandler);

    /*--- REGA Cr Events --- */

    on<ChangeCrNumberEvent>(_changeCrNumberEventHandler);
    on<VerifyCrNumberEvent>(_verifyCrNumberEventHandler);
  }

  Future<void> _editCreateVDPageHandler(
      EditCreateVDPageEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        items: e.params.files,
        splResponse: e.params.splResponse,
        splItems: e.params.splResponse?.items,
        // isFromHome: e.params.isFromHome,
        location: e.params.location,
        currentUserlocation: e.params.location,
        gisResponse: e.params.gisResponse,
        selectedCategory: e.params.selectedCategory));
  }

  Future<void> _changeIssueDescHandler(
      ChangeIssueDescEvent e, Emitter emitter) async {
    emitter(state.copyWith(errorMessage: "", issueDesc: e.text));
  }

  Future<void> _changeCrNumberEventHandler(
      ChangeCrNumberEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        crNumber: e.crNumber, isCrValid: false, errorMessage: ""));
  }

  Future<void> _changeGuestFirstNameHandler(
      ChangeGuestFirstNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      firstName: e.text,
    ));
  }

  Future<void> _changeGuestLastNameHandler(
      ChangeGuestLastNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      lastName: e.text,
    ));
  }

  Future<void> _changeGuestMobileHandler(
      ChangeGuestMobileEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      mobileNumber: e.text,
    ));
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    hideKeyboard();
    //print(e.isagree);
    emitter(state.copyWith(agreement: e.isagree, errorMessage: ""));
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
        } else {
          if (e.otpValue != null) {
            add(CreateIncidentUnRegisteredEvent(otpValue: e.otpValue!));
          } else {
            add(GetOTPEvent(
                params: OTPParams(mobileNumber: state.mobileNumber ?? "")));
          }
        }
      });
    } else {
      if (CommonProperties.isLoggedInMunicipality) {
        add(CreateIncidentRegisteredEvent());
      } else {
        if (e.otpValue != null) {
          add(CreateIncidentUnRegisteredEvent(
              otpValue: e.otpValue!, params: e.params));
        } else {
          add(GetOTPEvent(
              params: OTPParams(
            mobileNumber: state.mobileNumber ?? "",
          )));
        }
      }
    }
  }

  Future<void> _changeSelectedTextValueHandler(
      ChangeSelectedTextValueEvent e, Emitter emitter) async {
    SPLDetailsResponse? splDetailsResponse = state.splDetailsResponse;
    splDetailsResponse?.questionList?[e.index].selectedTextValue = e.text;
    emitter(state.copyWith(
      splDetailsResponse: splDetailsResponse,
    ));
  }

  Future<void> _changeSelectedDropDownValueHandler(
      ChangeSelectedDropDownValueEvent e, Emitter emitter) async {
    SPLDetailsResponse? splDetailsResponse = state.splDetailsResponse;
    splDetailsResponse?.questionList?[e.index].selectedDropDownValue = e.item;
    emitter(state.copyWith(
      splDetailsResponse: splDetailsResponse,
    ));
  }

  Future<void> _changeSelectedMultiSelectValueHandler(
      ChangeSelectedMultiSelectValueEvent e, Emitter emitter) async {
    SPLDetailsResponse? splDetailsResponse = state.splDetailsResponse;
    splDetailsResponse?.questionList?[e.index].selectedMultiSelectValue =
        e.items;
    emitter(state.copyWith(
      splDetailsResponse: splDetailsResponse,
    ));
  }

  Future<void> _createIncidentRegisteredHandler(
      CreateIncidentRegisteredEvent e, Emitter emitter) async {
    hideKeyboard();
    CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Submit_Event);

    emitter(state.copyWith(status: BlocStatus.loading));
    CreateIncidentParams params = e.params ??
        CreateIncidentParams(
            crNumber: state.isCrValid == true ? state.crNumber : null,
            municipalityID: state.gisResponse?.adminMunicipalityId,
            subMunicipalityID: state.gisResponse?.municipalityId,
            sub_SubMunicipalityID: state.gisResponse?.subMunicipalityId,
            latitude: state.location?.y.toString(),
            longitude: state.location?.x.toString(),
            address: state.gisResponse?.getFullAddress(),
            streetName: state.gisResponse?.streetName,
            districtName: state.gisResponse?.districtName,
            splClassificationID: state.splDetailsResponse?.selectedSPLID,
            issueDescription: state.issueDesc,
            attachments: state.items.map((e) => e.fileId ?? "").toList(),
            questionList: state.splDetailsResponse?.questionList);
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
              type: PAGE_TYPE.newVD,
              // fromHomePage: state.isFromHome,
              thanksMessage: success.data?.responseMessage));

      CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Success_Event);
    });
  }

  Future<void> _createIncidentUnRegisteredHandler(
      CreateIncidentUnRegisteredEvent e, Emitter emitter) async {
    CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Submit_Event);

    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));
    //print("refrences11111 ${state.otpResponse?.referenceId}");
    CreateIncidentParams params = e.params ??
        CreateIncidentParams(
          firstName: state.firstName,
          lastName: state.lastName,
          referenceID: state.otpResponse?.referenceId,
          mobileNumber: state.mobileNumber,
          otpValue: e.otpValue,
          crNumber: state.isCrValid == true ? state.crNumber : null,
          municipalityID: state.gisResponse?.adminMunicipalityId,
          subMunicipalityID: state.gisResponse?.municipalityId,
          sub_SubMunicipalityID: state.gisResponse?.subMunicipalityId,
          latitude: state.location?.y.toString(),
          longitude: state.location?.x.toString(),
          address: state.gisResponse?.getFullAddress(),
          streetName: state.gisResponse?.streetName,
          districtName: state.gisResponse?.districtName,
          splClassificationID: state.splDetailsResponse?.selectedSPLID,
          issueDescription: state.issueDesc,
          attachments: state.items.map((e) => e.fileId ?? "").toList(),
          questionList: state.splDetailsResponse?.questionList,
        );
    final failureOrSuccess = await _createIncidentUnRegistered(params);

    failureOrSuccess.fold((failure) {
      ServerFailure serverFailure = (failure as ServerFailure);

      if (serverFailure.errorCode == "CS_API_023") {
        NavigationService.navigatorKey.currentState!.pop();
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: serverFailure.errorMessage,
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
                      add(SubmitIncidentEvent(params: newParams));
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
      //print(success);
      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute, predicate,
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.newVD,
              // fromHomePage: state.isFromHome,
              thanksMessage: success.data?.responseMessage));
      if (!CommonProperties.isLoggedInMunicipality) {
        sharedPrefs.storeGuestInfo(
            state.firstName, state.lastName, state.mobileNumber);
      }

      CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Success_Event);

      //MM     Helpers.sendEventToAnalytics(AppEvents.VD_Success_UnRegistered_Submit);
    });
  }

  Future<void> _getSPLDetailsHandler(
      GetSPLDetailsEvent e, Emitter emitter) async {
    hideKeyboard();

    if (state.status == BlocStatus.loading) return;

    emitter(state.copyWith(
        status: BlocStatus.loading,
        selectedSPLIndex: e.selectedIndex,
        clearSPLDetailsResponse: true));

    final failureOrSuccess = await _getSPLDetails(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
          selectedSPLIndex: -1));
    }, (success) {
      success.selectedSPLID = e.params.splID;
      emitter(state.copyWith(
        status: BlocStatus.success,
        splDetailsResponse: success,
        errorMessage: "",
      ));

      if (e.autoSelect == true) {
        emitter(state.copyWith(
            status: BlocStatus.success,
            currentPageValue: state.currentPageValue + 1));
        add(GoToNextPageEvent());
      }
    });
  }

  Future<void> _verifyCrNumberEventHandler(
      VerifyCrNumberEvent e, Emitter emitter) async {
    hideKeyboard();

    if (state.crNumber?.isEmpty ?? true) {
      CommonFunctions.showError(("enter_cr_number").tr());
      return;
    }

    if ((state.crNumber?.length ?? 0) < 10 ||
        (state.crNumber?.length ?? 0) > 10) {
      CommonFunctions.showError(("cr_number_error_msg_length").tr());
      return;
    }

    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _checkCR(state.crNumber ?? "");

    failureOrSuccess.fold((failure) {
      //print(failure);
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
        isCrValid: false,
      ));
    }, (success) {
      //print("succcss");
      emitter(state.copyWith(
        status: success == false ? BlocStatus.failure : BlocStatus.success,
        isCrValid: success ?? false,
        errorMessage: success == false ? ("cr_number_not_valid").tr() : "",
      ));
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

  Future<void> _getOTPHandler(GetOTPEvent e, Emitter emitter) async {
    //print("GetOTPEvent");
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getOTP(e.params);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      //print("refrences11111 ${success.referenceId}");
      emitter(state.copyWith(
        status: BlocStatus.success,
        otpResponse: success,
        errorMessage: "",
      ));
      if (e.params.showOTPPage == true) {
        CommonFunctions.sendUXCamEvent(
            UXCamEvents.SnapAndSend_Open_OTP_Step_Event);

        NavigationService.navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: this,
            child: VDGuestOtpScreen(),
          ),
        ));
      }
    });
  }

  void cancelIncident() {
    hideKeyboard(); //MM
    bool Function(Route<dynamic>) predicate =
        ModalRoute.withName(RouteName.bottomNavigation);
    NavigationService.navigatorKey.currentState!.popUntil((predicate));
  }

  Future<void> _searchForSPLEventHandler(
      SearchForSPLEvent e, Emitter emitter) async {
    List<SplItem>? items = state.splResponse?.items
        ?.where((element) =>
            element.name?.toLowerCase().contains(e.text ?? "") ?? false)
        .toList();
    emitter(state.copyWith(
        selectedSPLIndex: -1,
        clearSPLDetailsResponse: true,
        splSearchedText: e.text,
        splItems: items));
  }

  Future<void> _showSPLSearchHandler(
      ShowSPLSearchEvent e, Emitter emitter) async {
    bool newSearchStatus = !(state.isSearchShown ?? false);

    emitter(state.copyWith(
        selectedSPLIndex: -1,
        clearSPLDetailsResponse: true,
        isSearchShown: newSearchStatus,
        splItems: newSearchStatus == false ? state.splResponse?.items : null));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    int nextPage = state.currentPageValue + 1;

    ////print("next page");
    //print("DataLog ${state}");
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      if (nextPage == 1) {
        if (!CommonFunctions.checkForVDExpectedForINC(
            adminMunicipalityId: state.gisResponse?.adminMunicipalityId,
            municipalityName: state.gisResponse?.municipalityName,
            isVDExcepted: state.gisResponse?.isVDExcepted())) {
          add(GetSplListEvent(
              nextPage: nextPage,
              params: SplParams(
                  categoryID: state.selectedCategory?.categoryId ?? "",
                  municipalityID: state.gisResponse?.adminMunicipalityId)));
        } else {
          emitter(state.copyWith(
            status: BlocStatus.success,
          ));
        }
      } else {
        controller.jumpToPage(nextPage);
        sendEventStep(nextPage);
        emitter(state.copyWith(
            status: BlocStatus.success,
            currentPageValue: nextPage,
            errorMessage: ""));
      }
    }

    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    int prvoiusPage = state.currentPageValue - 1;

    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      controller.jumpToPage(prvoiusPage);
      sendEventStep(prvoiusPage);

      emitter(state.copyWith(
          status: BlocStatus.success,
          currentPageValue: prvoiusPage,
          errorMessage: ""));
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
    CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Open_Map_Step_Event);

    await NavigationService.navigatorKey.currentState!
        .pushNamed(RouteName.vdMapRoute,
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
            clearSPLResponse: true,
            selectedSPLIndex: -1,
            currentUserlocation: params.currentUserLocation));
      }
    });
  }

  Future<bool> _getVDSplListHandler(GetSplListEvent e, Emitter emitter) async {
    // //print("_getVDSplListHandler");
    if (state.status == BlocStatus.loading) return false;
    if (state.splResponse?.items?.isEmpty ?? true) {
      emitter(state.copyWith(status: BlocStatus.loading));
      final failureOrSuccess = await _getSplList(e.params);
      return failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
        return false;
      }, (success) async {
        emitter(state.copyWith(
          status: BlocStatus.success,
          splResponse: success,
          splItems: success.items,
          errorMessage: "",
        ));

        if (success.items?.length == 1 &&
            state.selectedCategory?.categoryId ==
                RemoteConfig.movingVeichleCategoryKey) {
          await Future.delayed(Duration(milliseconds: 200));

          add(GetSPLDetailsEvent(
              autoSelect: true,
              selectedIndex: 0,
              params: SPLDetailsParams(
                  municipalityID: state.gisResponse?.adminMunicipalityId ?? "",
                  splID: success.items?[0].id ?? "")));
        } else {
          controller.jumpToPage(e.nextPage);
          sendEventStep(e.nextPage);
          emitter(state.copyWith(
              status: BlocStatus.success, currentPageValue: e.nextPage));
        }

        return true;
        //return navigateToCreateVDPage(e.createVDBloc);
      });
    } else {
      controller.jumpToPage(e.nextPage);
      sendEventStep(e.nextPage);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: e.nextPage));

      return true;
      // return navigateToCreateVDPage(e.createVDBloc);
    }
  }

  bool isLastPage() {
    return state.currentPageValue == (pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void sendEventStep(int page) {
    String eventName = "";

    if (CommonProperties.isLoggedInMunicipality) {
      if (page == 0) {
        eventName = UXCamEvents.SnapAndSend_Open_Location_Step_Event;
      } else if (page == 1) {
        eventName = UXCamEvents.SnapAndSend_Open_SPL_Step_Event;
      } else if (page == 2) {
        eventName = UXCamEvents.SnapAndSend_Open_Details_Step_Event;
      } else if (page == 3) {
        eventName = UXCamEvents.SnapAndSend_Open_Review_Step_Event;
      }
    } else {
      if (page == 0) {
        eventName = UXCamEvents.SnapAndSend_Open_Location_Step_Event;
      } else if (page == 1) {
        eventName = UXCamEvents.SnapAndSend_Open_SPL_Step_Event;
      } else if (page == 2) {
        eventName = UXCamEvents.SnapAndSend_Open_Guest_Info_Step_Event;
      } else if (page == 3) {
        eventName = UXCamEvents.SnapAndSend_Open_Details_Step_Event;
      } else if (page == 4) {
        eventName = UXCamEvents.SnapAndSend_Open_Review_Step_Event;
      }
    }
    CommonFunctions.sendUXCamEvent(eventName);
  }
}
