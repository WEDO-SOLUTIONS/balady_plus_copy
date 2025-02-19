import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/ekram/data/model/cemetries_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/ekram_transport_validate_submit_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/mosque_ghusl_places_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/transportation_companies_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_burial_cities.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetery_types_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetries_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_countries.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_current_track_location.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_launduries_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_mosques_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_prayers.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_special_transport_reasons_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_transportation_companies_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/save_death_burial_info.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/transport_validate_submit.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/verify_deceased.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_page_view/deceased_verification_section.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_page_view/emirate_approval_info_section.dart';
import 'package:balady_plus/app/features/ekram_inquiry_service/domain/use_cases/get_ekram_identity_types.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';

import '../../../data/model/request_details_response_model/SaveDeceasedInfoParams.dart';
import '../../../data/model/request_details_response_model/burial_info.dart';
import '../../../data/model/request_details_response_model/cemetery_data.dart';
import '../../../data/model/request_details_response_model/death_info.dart';
import '../../../data/model/request_details_response_model/deceased_info.dart';
import '../../../data/model/request_details_response_model/main_info.dart';
import '../../../data/model/request_details_response_model/submitter_info.dart';
import '../../../data/model/request_details_response_model/request_details_response_model.dart';
import '../../../data/model/request_details_response_model/transport_info.dart';
import '../../../data/model/reset_action_enum.dart';
import '../../../data/model/save_death_burial_info_params/save_death_burial_info_params.dart';
import '../../../domain/use_cases/get_death_cities.dart';
import '../../../../../core/utils/nullable.dart';
import '../../../domain/use_cases/get_madinah_emirate_approval_statue.dart';
import '../../../domain/use_cases/get_request_details.dart';
import '../../../domain/use_cases/save_deceased_info.dart';
import '../../widgets/transportation_request_page_view/agreement_section.dart';

part 'ekram_request_transportation_event.dart';

part 'ekram_request_transportation_state.dart';

class EkramRequestTransportationBloc extends Bloc<
    EkramRequestTransportationEvent, EkramRequestTransportationState> {
  final GetEkramIdentityTypes _getEkramIdentityTypes;
  final TextEditingController? decesssedIdentity = TextEditingController();

  PageController controller = PageController();

  // TransportRequestsBloc? ekramRequestsBloc;
  late List pagesList = [
    DeceasedVerificationSection(),
    const DeceasedInfoSection(),
    const ApplicantInfoSection(),
    const DeathAndBurialInfoSection(),
    const EmirateApprovalInfoSection(),
    const AgreementSection(),
  ];

  final GetCemeteryTypesLookUp _getCemeteryTypesLookUp;
  final GetHospitals _getHospitals;
  final GetCemetriesLookUp _getCemetries;
  final EkramTransportValidateSubmit _ekramTransportValidateSubmit;
  final GetTransportationCompaniesLookUp _getTransportationNames;
  final GetLaundriesLookup _getLaundires;
  final SaveDeathBurialInfo _saveDeathBurialInfo;
  final GetMosquesLookup _getMosques;
  final GetNationalities _getNationalities;
  final ApplyDeceasedTransport _applyDeceasedTransport;
  final GetDeathCities _deathCities;
  final GetBurialCities _burialCities;
  final VerifyDeceased _verifyDeceased;
  final GetRequestDetails _getRequestDetails;
  final GetCurrentTrackLocation _getCurrentTrackLocation;
  final GetCountreies _getCountreies;
  final SaveDeceasedInfo _saveDeceasedInfo;
  final GetMadinahEmirateApprovalStatus _getMadinahEmirateApprovalStatus;

  final GetPrayers _getPrayers;
  final GetSpecialTransportReasonsLookUp _getSpecialTransportReasons;

  EkramRequestTransportationBloc({
    required GetCities getCities,
    required GetHospitals getHospitals,
    required GetNationalities getNationalities,
    required GetCemeteryTypesLookUp getCemeteryTypesLookUp,
    required ApplyDeceasedTransport applyDeceasedTransport,
    required GetRequestDetails getRequestDetails,
  })  : _getEkramIdentityTypes = GetEkramIdentityTypes(repository: sl()),
        _getHospitals = getHospitals,
        _getCemeteryTypesLookUp = getCemeteryTypesLookUp,
        _saveDeathBurialInfo = SaveDeathBurialInfo(repository: sl()),
        _getCountreies = GetCountreies(repository: sl()),
        _getCemetries = GetCemetriesLookUp(repository: sl()),
        _ekramTransportValidateSubmit =
            EkramTransportValidateSubmit(repository: sl()),
        _getTransportationNames =
            GetTransportationCompaniesLookUp(repository: sl()),
        _getLaundires = GetLaundriesLookup(repository: sl()),
        _getMosques = GetMosquesLookup(repository: sl()),
        _getPrayers = GetPrayers(repository: sl()),
        _getSpecialTransportReasons =
            GetSpecialTransportReasonsLookUp(repository: sl()),
        _getNationalities = getNationalities,
        _applyDeceasedTransport = applyDeceasedTransport,
        _getRequestDetails = getRequestDetails,
        _getCurrentTrackLocation = GetCurrentTrackLocation(repository: sl()),
        _saveDeceasedInfo = SaveDeceasedInfo(repository: sl()),
        _deathCities = GetDeathCities(repository: sl()),
        _burialCities = GetBurialCities(repository: sl()),
        _getMadinahEmirateApprovalStatus =
            GetMadinahEmirateApprovalStatus(repository: sl()),
        _verifyDeceased = VerifyDeceased(repository: sl()),
        super(EkramRequestTransportationState(
            agreementChecked: false,
            isSpecialTransferNeeded: false,
            isBurialInsideDeathCity: true,
            isDeceasedBtnEnabled: false,
            fullName: CommonProperties.userInfo?.arName ?? "",
            mobileNumber: CommonProperties.userInfo?.getPhone() ?? "",
            requestType: trans("ekram_request_type"),
            requestDetailsModel: null)) {
    on<EkramRequestTransportationEvent>((event, emit) {});
    on<ChangeIsNeedSpecialTransferEvent>(_changeIsNeedSpecialTransferHanlder);
    // on<ChangeIsBurialInsideDeathCityEvent>(
    //     _changeIsBurialInsideDeathCityHanlder);
    on<ChangeAgreementEvent>(_changeAgreementHandler);
    on<SelectHospitalEvent>(_selectHospitalHanlder);
    on<SubmitRequestEvent>(_submitRequestEvent);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<SelectNationalIdTypeEvent>(_selectNationalIdHandler);

    on<ChangeRelationShipEvent>(_changeRelationShipHanlder);
    on<ChangeDeathLocationEvent>(_changeDeathLocationHanlder);

    on<ChangeHospitalOtherNameEvent>(_changeOtherHospitalNameHanlder);

    // on<GetCitiesEvent>(_getCitiesHandler);
    // on<GetNationalitiesEvent>(_getNationalitiesHandler);
    on<GetMadinahEmirateApprovalStatusEvent>(
        _getMadinahEmirateApprovalStatusHandler);
    on<GetHospitalsEvent>(_getHospitalsHandler);
    on<GetCemetriesEvent>(_getCemetriesHandler);
    on<ekramTransportValidateSubmitEvent>(_ekramTransportValidateSubmitHandler);
    on<GetTransportationNamesEvent>(_getTransportationNamesHandler);
    on<GetLandriesEvent>(_getLaundriesHandler);
    on<GetMosquesEvent>(_getMosquesHandler);
    on<ChangeCemetryTypeItemsEvent>(_changeCemetryTypeItemsHandler);
    on<ChangeCemetryItemsEvent>(_changeCemetryItemsHandler);
    on<ChangeLandriesEvent>(_changeLandriesHandler);
    on<ChangeMosqueEvent>(_changeMosqueHandler);
    on<ChangeTransportationNameEvent>(_changeTransportationNamesHandler);
    // on<AddDeceasedEvent>(_addDeceasedHandler);
    // on<DeleteDeceasedEvent>(_deleteDeceasedHandler);
    // on<EditDeceasedEvent>(_editDeceasedHandler);
    on<AddFileEvent>(_addFileHandler);
    on<ChangeNationalIdDob>(_changeNationalIdDobHandler);
    on<ChangeBurialDateEvent>(_changeBurialDateEventHandler);
    on<ChangeDeathDateEvent>(_changeDeathDateEventHandler);
    on<ChangeIdEvent>(_changeIdHandler);

    on<ChangeDeathCityEvent>(_changeCityHandler);
    on<ChangePrayerEvent>(_changePrayerHandler);
    on<ChangeSpecialTransportReasonsEvent>(
        _changeSpecialTransportReasonsHandler);

    on<ChangeHospitalEvent>(_changeHospitalHandler);
    on<ChangebodyArrivalCitiesEvent>(_changebodyArrivalCitiesHandler);

    // fawzi

    on<VerifyDeceasedEvent>(_verifyDeceasedHandler);
    on<ChangeDeceasedUserInfoEvent>(_changeDeceasedInfoDataHanlder);
    on<SetApplicantInfoEvent>(_setApplicantInfoDataHanlder);
    on<getRequestDetailsEvent>(_getRequestDetailsHandler);
    on<getCurrentTrackLocationEvent>(_getCurrentTrackLocationHandler);
    on<saveDeceasedInfoEvent>(_saveDeceasedInfoHandler);
    on<saveBurianDeathInfoEvent>(_saveDeceasedBurialInfoHandler);
    on<ChangeDeathInfoEvent>(_changeDeathandBurialHandler);
    on<setBurialInfoEvent>(_changeBurialInfoHandler);
    on<setTransportInfoEvent>(_changeTansportInfoHandler);
    on<setCemtryInfoEvent>(_changeCemtryInfoHandler);
    on<setInitialDataEvent>(_setInitialDataHandler);
    on<ResetActionEvent>(_resetActionEventHandler);

    getEkramNationalIdTypesEventHandler();
    getCountries();
    getPrayers();
    getNationalitiesHandler(null);
    getDeathCitiesHandler();
    getBurialCitiesHandler();
    getCemetryTypeItemsHandler();

    // RequestDetailsResponseModel? params = state.requestDetailsModel;
    // params ??= RequestDetailsResponseModel(
    //   deathInfo: DeathInfo(countryId: 1),
    // );
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      agreementChecked: e.isagree,
    ));
  }

  Future<void> _changeRelationShipHanlder(
      ChangeRelationShipEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      relation: e.text,
    ));
  }

  Future<void> _changeCityHandler(
      ChangeDeathCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedDeathCity: e.item, errorMessage: ""));
  }

  Future<void> _changePrayerHandler(
      ChangePrayerEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedPrayer: e.item, errorMessage: ""));
  }

  Future<void> _changeCemetryTypeItemsHandler(
      ChangeCemetryTypeItemsEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCemetryType: e.item, errorMessage: ""));
  }

  Future<void> _changeCemetryItemsHandler(
      ChangeCemetryItemsEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCemetry: e.item, errorMessage: ""));
  }

  Future<void> _changeLandriesHandler(
      ChangeLandriesEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedlaundry: e.item, errorMessage: ""));
  }

  Future<void> _changeMosqueHandler(
      ChangeMosqueEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedMosque: e.item, errorMessage: ""));
  }

  Future<void> _changeTransportationNamesHandler(
      ChangeTransportationNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedtransportation: e.item, errorMessage: ""));
  }

  Future<void> _changeSpecialTransportReasonsHandler(
      ChangeSpecialTransportReasonsEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        selectedSpecialTransportReason: e.item, errorMessage: ""));
  }

  Future<void> _changeBurialCityHandler(
      ChangeBurialCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedBurialCity: e.item, errorMessage: ""));
  }

  Future<void> _changeHospitalHandler(
      ChangeHospitalEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedHospital: e.item, errorMessage: ""));
  }

  Future<void> _changebodyArrivalCitiesHandler(
      ChangebodyArrivalCitiesEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedBodyArrivalCity: e.item, errorMessage: ""));
  }

  Future<void> _changeDeathLocationHanlder(
      ChangeDeathLocationEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      deathLocation: e.text,
    ));
  }

  Future<void> _changeOtherHospitalNameHanlder(
      ChangeHospitalOtherNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      otherHospitalName: e.text,
    ));
  }

  Future<void> _selectHospitalHanlder(
      SelectHospitalEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      selectedHospital: e.item,
    ));
  }

  Future<void> _changeIsNeedSpecialTransferHanlder(
      ChangeIsNeedSpecialTransferEvent e, Emitter emitter) async {
    emitter(
        state.copyWith(errorMessage: "", isSpecialTransferNeeded: e.isNeeded));
  }

  // Future<void> _changeIsBurialInsideDeathCityHanlder(
  //     ChangeIsBurialInsideDeathCityEvent e, Emitter emitter) async {
  //   emitter(state.copyWith(
  //       errorMessage: "", isBurialInsideDeathCity: e.isBurialInsideDeathCity));
  // }

  Future<void> _changeNationalIdDobHandler(
      ChangeNationalIdDob e, Emitter emitter) async {
    String? hijri = e.hijriDate;
    String? gorgian = e.gorgianDate;
    if (e.gorgianDate != null) {
      List<int> dateSplitted =
          e.gorgianDate!.split("/").map((e) => int.parse(e)).toList();
      hijri = HijriCalendar.fromDate(
              DateTime(dateSplitted[0], dateSplitted[1], dateSplitted[2]))
          .toFormat("yyyy/mm/dd");
    }
    if (e.hijriDate != null) {
      print("HHHff ${e.hijriDate}");
      List<int> dateSplitted =
          CommonFunctions.replaceArabicNumberWithEnglish(e.hijriDate!)
              .split("/")
              .map((e) => int.parse(e))
              .toList();
      var gDate = HijriCalendar();
      DateTime gorgianDate = gDate.hijriToGregorian(
          dateSplitted[0], dateSplitted[1], dateSplitted[2]);
      gorgian = DateFormat('yyyy/MM/dd').format(gorgianDate);
    }
    print(gorgian);
    print(hijri);

    emitter(state.copyWith(
        deceassedDOBGorgian: Nullable(CommonFunctions.padHijriDate(gorgian)),
        status: BlocStatus.success,
        errorMessage: "",
        deceassedDOBHijri: Nullable(CommonFunctions.padHijriDate(hijri))));
    deceasedVerificationSectionValidator(emitter);
  }

  String? validateNationalId(String? input) {
    if (state.selectedNationalIdType?.id == 1) {
      if (!(input?.startsWith("1") ?? false) ||
          (input?.length ?? 0) < 10 ||
          (input?.length ?? 0) > 10) {
        return "wrong_input_data".tr();
      } else {
        return null;
      }
    } else if (state.selectedNationalIdType?.id == 3) {
      if (!(input?.startsWith("2") ?? false) ||
          (input?.length ?? 0) < 10 ||
          (input?.length ?? 0) > 10) {
        return "wrong_input_data".tr();
      } else {
        return null;
      }
    } else if (state.selectedNationalIdType?.id == 9 ||
        state.selectedNationalIdType?.id == 10) {
      if ((input?.startsWith("2") ?? false) ||
          (input?.startsWith("1") ?? false) ||
          (input?.length ?? 0) < 10 ||
          (input?.length ?? 0) > 10) {
        return "wrong_input_data".tr();
      } else {
        return null;
      }
    } else if ((input?.length ?? 0) > 10) {
      return "wrong_input_data".tr();
    }
    return null;
  }

  Future<List<LookUpItem>?> getCemetryTypeItemsHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCemeteryTypesLookUp(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
          status: BlocStatus.success,
          cemetryTypeItems: success.data?.result,
          errorMessage: ""));
      return success.data?.result;
    });
  }

  Future<void> _changeDeathDateEventHandler(
      ChangeDeathDateEvent e, Emitter emitter) async {
    String? hijri = e.hijriDate;
    String? gorgian = e.gorgianDate;
    if (e.gorgianDate != null) {
      List<int> dateSplitted =
          e.gorgianDate!.split("/").map((e) => int.parse(e)).toList();
      hijri = HijriCalendar.fromDate(
              DateTime(dateSplitted[0], dateSplitted[1], dateSplitted[2]))
          .toFormat("yyyy/mm/dd");
    }
    if (e.hijriDate != null) {
      print("HHHff ${e.hijriDate}");
      List<int> dateSplitted =
          CommonFunctions.replaceArabicNumberWithEnglish(e.hijriDate!)
              .split("/")
              .map((e) => int.parse(e))
              .toList();
      var gDate = HijriCalendar();
      DateTime gorgianDate = gDate.hijriToGregorian(
          dateSplitted[0], dateSplitted[1], dateSplitted[2]);
      gorgian = DateFormat('yyyy/MM/dd').format(gorgianDate);
    }
    print(gorgian);
    print(hijri);

    emitter(state.copyWith(
        deathDateGregorian: Nullable(CommonFunctions.padHijriDate(gorgian)),
        errorMessage: "",
        deathDateHijri: Nullable(CommonFunctions.padHijriDate(hijri))));
  }

  Future<void> _changeBurialDateEventHandler(
      ChangeBurialDateEvent e, Emitter emitter) async {
    String? hijri = e.hijriDate;
    String? gorgian = e.gorgianDate;
    if (e.gorgianDate != null) {
      List<int> dateSplitted =
          e.gorgianDate!.split("/").map((e) => int.parse(e)).toList();
      hijri = HijriCalendar.fromDate(
              DateTime(dateSplitted[0], dateSplitted[1], dateSplitted[2]))
          .toFormat("yyyy/mm/dd");
    }
    if (e.hijriDate != null) {
      print("HHHff ${e.hijriDate}");
      List<int> dateSplitted =
          CommonFunctions.replaceArabicNumberWithEnglish(e.hijriDate!)
              .split("/")
              .map((e) => int.parse(e))
              .toList();
      var gDate = HijriCalendar();
      DateTime gorgianDate = gDate.hijriToGregorian(
          dateSplitted[0], dateSplitted[1], dateSplitted[2]);
      gorgian = DateFormat('yyyy/MM/dd').format(gorgianDate);
    }
    print(gorgian);
    print(hijri);

    emitter(state.copyWith(
        burialDateGregorian: Nullable(CommonFunctions.padHijriDate(gorgian)),
        errorMessage: "",
        burialDateHijri: Nullable(CommonFunctions.padHijriDate(hijri))));
  }

  Future<List<LookUpItem>?> getDeathCitiesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _deathCities(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        deathCities: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getBurialCitiesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _burialCities(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        burialCities: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getCountries() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCountreies(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
          status: BlocStatus.success,
          countries: success.data?.result,
          errorMessage: "",
          selectedDeathCountry: success.data?.result
              ?.firstWhere((value) => value.localCountry == true)));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getPrayers() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getPrayers(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
          status: BlocStatus.success,
          prayers: success.data?.result,
          errorMessage: ""));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getSpecialTransportReasons() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getSpecialTransportReasons(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
          status: BlocStatus.success,
          specialTransportReasons: success.data?.result,
          errorMessage: ""));
      return success.data?.result;
    });
  }

  Future<void> _changeCemetryTypeEventHandler(
      ChangeCemetryTypeEvent e, Emitter emitter) async {
    // emitter(state.copyWith(
    //     errorMessage: "",
    //     cemetries: [],
    //     data: state.data.copyWith(
    //         selectedCemetryType: e.item,
    //         selectedCemetry: Nullable(null),
    //         baqieApproval: Nullable(null))));
  }

  Future<List<LookUpItem>?> getNationalitiesHandler(int? identityTypeId) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getNationalities(identityTypeId);

    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      getNationalitiesHandler(identityTypeId);
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nationalities: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<void> _selectNationalIdHandler(
      SelectNationalIdTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      status: BlocStatus.loading,
    ));

    emitter(state.copyWith(
      status: BlocStatus.success,
      selectedNationalIdType: e.item,
      errorMsg: "",
    ));
    getNationalitiesHandler(e.item.id);
    deceasedVerificationSectionValidator(emitter);
  }

  Future<List<LookUpItem>?> getEkramNationalIdTypesEventHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramIdentityTypes(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMsg: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nationalIdTypes: success,
        errorMsg: "",
      ));
      return success;
    });
  }

  Future<void> _getHospitalsHandler(
      GetHospitalsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getHospitals(e.cityId!);

    failureOrSuccess.fold((failure) {
      print("failure $failure");

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      print("Succ3ess $success");
      success.data?.result;
      print("Succ3ess 555 ${success.data?.result?.length}");

      emitter(state.copyWith(
        status: BlocStatus.success,
        hospitals: success.data?.result,
        clearHospital: true,
        errorMessage: "",
      ));

      print("Succ3ess 555 ${state.hospitals}");
    });
  }

  Future<void> _getCemetriesHandler(
      GetCemetriesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getCemetries([e.requestId, e.params]);
    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        cemetries: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _ekramTransportValidateSubmitHandler(
      ekramTransportValidateSubmitEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess =
        await _ekramTransportValidateSubmit([e.requestId, e.params]);
    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));

      NavigationService.navigatorKey.currentState!.pushNamed(
          RouteName.ekramSuccessScreen,
          arguments: "${state.requestId!}");
    });
  }

  Future<void> _getTransportationNamesHandler(
      GetTransportationNamesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess =
        await _getTransportationNames([e.requestId, e.params]);
    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        transportations: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getLaundriesHandler(GetLandriesEvent e, Emitter emitter) async {
    if (e.cityIds == null || e.transportId == null) return;
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess =
        await _getLaundires([e.transportId, e.cityIds, e.params]);
    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<LookUpItem>? laundries = [];
      LookUpItem choose = LookUpItem(id: -1, name: "choose".tr());
      laundries.add(choose);
      laundries.addAll(success.data?.result as List<LookUpItem>);

      emitter(state.copyWith(
        status: BlocStatus.success,
        laundries: laundries,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getMosquesHandler(GetMosquesEvent e, Emitter emitter) async {
    if (e.cityIds == null || e.transportId == null) return;
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess =
        await _getMosques([e.transportId, e.cityIds, e.ghuslplace]);
    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<LookUpItem>? mosques = [];
      LookUpItem choose = LookUpItem(id: -1, name: "choose".tr());
      mosques.add(choose);
      mosques.addAll(success.data?.result as List<LookUpItem>);
      emitter(state.copyWith(
        status: BlocStatus.success,
        mosques: mosques,
        errorMessage: "",
      ));
    });
  }

  // Future<void> _addDeceasedHandler(AddDeceasedEvent e, Emitter emitter) async {
  //   emitter(state.copyWith(status: BlocStatus.loading));
  //   List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];
  //
  //   DeceasedInfoDto info = e.data as DeceasedInfoDto;
  //   deceasedInfoDto.add(info);
  //
  //   emitter(state.copyWith(
  //       status: BlocStatus.success, deceasedInfoDto: deceasedInfoDto));
  // }
  //
  // Future<void> _editDeceasedHandler(
  //     EditDeceasedEvent e, Emitter emitter) async {
  //   emitter(state.copyWith(status: BlocStatus.loading));
  //   List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];
  //
  //   DeceasedInfoDto info = e.data as DeceasedInfoDto;
  //   deceasedInfoDto[e.index] = info;
  //
  //   emitter(state.copyWith(
  //       status: BlocStatus.success, deceasedInfoDto: deceasedInfoDto));
  // }
  //
  // Future<void> _deleteDeceasedHandler(
  //     DeleteDeceasedEvent e, Emitter emitter) async {
  //   emitter(state.copyWith(status: BlocStatus.loading));
  //   List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];
  //
  //   deceasedInfoDto.removeAt(e.index);
  //
  //   emitter(state.copyWith(
  //       status: BlocStatus.success, deceasedInfoDto: deceasedInfoDto));
  //
  //   CommonFunctions.showSuccess(trans("delete_deceassed_success"));
  // }

  Future<void> _addFileHandler(AddFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    emitter(state.copyWith(status: BlocStatus.success, letter: e.data));
  }

  Future<void> _submitRequestEvent(
      SubmitRequestEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;

    CommonFunctions.sendUXCamEvent(UXCamEvents
        .RequestsTransportingAndPreparingDeceased_Send_Request_Event);
    hideKeyboard();

    emitter(state.copyWith(status: BlocStatus.loading));
    //
    // final failureOrSuccess = await _applyDeceasedTransport(ApplyDeceasedParams(
    //     deathCityId: state.selectedDeathCity?.id,
    //     hospitalId: state.selectedHospital?.id,
    //     relationship: state.relation,
    //     locationAddress: state.deathLocation,
    //     deathTransferStatusId: 3,
    //     deceasedInfoDtoList: state.deceasedInfoDto,
    //     hospitalOtherName:
    //         state.selectedHospital?.id == -1 ? state.otherHospitalName : null,
    //     letter: state.letter));
    //
    // failureOrSuccess.fold((failure) {
    //   emitter(state.copyWith(
    //     status: BlocStatus.failure,
    //     errorMessage: (failure as ServerFailure).errorMessage,
    //   ));
    // }, (success) {
    //   emitter(state.copyWith(
    //     status: BlocStatus.success,
    //     errorMessage: "",
    //   ));
    //   NavigationService.navigatorKey.currentState!.pushReplacementNamed(
    //       RouteName.successRoute,
    //       arguments: SuccessScreenArgs(
    //           type: PAGE_TYPE.ekramCemetry,
    //           thanksMessage: success.data?.responseMessage));
    //
    //   CommonFunctions.sendUXCamEvent(UXCamEvents
    //       .RequestsTransportingAndPreparingDeceased_Open_Success_Page_Event);
    //
    //   CommonFunctions.sendUXCamEvent(
    //       UXCamEvents.finishServiceBodyTransportation);
    // });
  }

  void cancelRequest() {
    hideKeyboard();
    NavigationService.navigatorKey.currentState!
        .popUntil(ModalRoute.withName(RouteName.bottomNavigation));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.performing) return;
    int nextPage = state.currentPageValue + 1;
    if (state.requestDetailsModel?.cemeteryData?.cemeteryId != null) {
      if (nextPage == 4) {
        state
                    .getCemtryById(
                        state.requestDetailsModel?.cemeteryData?.cemeteryId,
                        state.requestDetailsModel?.cemeteryData?.cemeteryName)
                    ?.needApproval ??
                false
            ? null
            : nextPage++;
      }
    }
    emitter(state.copyWith(
      status: BlocStatus.performing,
    ));
    controller.jumpToPage(nextPage);
    sendStepPage(nextPage);
    emitter(
        state.copyWith(status: BlocStatus.success, currentPageValue: nextPage));

    if (nextPage == 1) {
      add(getRequestDetailsEvent(requestId: state.requestId!));
    }
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      if (state.requestDetailsModel?.cemeteryData?.cemeteryId != null) {
        if (prvoiusPage == 4) {
          state
                      .getCemtryById(
                          state.requestDetailsModel?.cemeteryData?.cemeteryId,
                          state.requestDetailsModel?.cemeteryData?.cemeteryName)
                      ?.needApproval ??
                  false
              ? null
              : prvoiusPage--;
        }
      }
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      controller.jumpToPage(prvoiusPage);
      sendStepPage(prvoiusPage);

      emitter(state.copyWith(
        status: BlocStatus.success,
        currentPageValue: prvoiusPage,
      ));
    }
    hideKeyboard();
  }

  bool isLastPage() {
    return state.currentPageValue == (pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void sendStepPage(int page) {
    if (page == 0) {
      CommonFunctions.sendUXCamEvent(UXCamEvents
          .RequestsTransportingAndPreparingDeceased_Open_Applicant_Info_Step_Event);
    } else if (page == 1) {
      CommonFunctions.sendUXCamEvent(UXCamEvents
          .RequestsTransportingAndPreparingDeceased_Open_Deceased_Info_Step_Event);
    } else if (page == 2) {
      CommonFunctions.sendUXCamEvent(UXCamEvents
          .RequestsTransportingAndPreparingDeceased_Open_Location_Info_Step_Event);
    } else if (page == 3) {
      CommonFunctions.sendUXCamEvent(UXCamEvents
          .RequestsTransportingAndPreparingDeceased_Open_Review_Info_Step_Event);
    }
  }

  Future<void> _changeIdHandler(ChangeIdEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.success,
        deceasedId: e.deceasedId,
        errorMessage: ""));
    deceasedVerificationSectionValidator(emitter);
  }

  // fawzi
  Future<void> _verifyDeceasedHandler(
      VerifyDeceasedEvent e, Emitter emitter) async {
    emit(state.copyWith(
        status: BlocStatus.loading, isDeceasedBtnEnabled: false));
    final failureOrSuccess = await _verifyDeceased(
      e.params == null
          ? VerifyDeceasedParams(
              identityNumber: state.deceasedId!,
              identityType: state.selectedNationalIdType!.id!,
              birthDate: state.deceassedDOBHijri!,
              submitterBirthDate:
                  CommonProperties.userInfo!.getHijriBirthDate(),
              submitterMobile: CommonProperties.userInfo!.getPhone(),
            )
          : e.params!,
    );
    return failureOrSuccess.fold((failure) {
      if (e.fromDeepLink) {
        NavigationService.pushNamed(
          routeName: RouteName.ekramRequestTransportationScreen,
          args: this,
        );
        add(ChangeNationalIdDob(hijriDate: e.params!.birthDate));
        decesssedIdentity?.text = e.params!.identityNumber;
        emit(
          state.copyWith(
            isDeceasedBtnEnabled: true,
            status: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
            isVerified: false,
            selectedNationalIdType:
                state.getNationalIdTypesById(e.params!.identityType, null),
            deceasedId: e.params!.identityNumber,
          ),
        );
      }

      emit(
        state.copyWith(
          isDeceasedBtnEnabled: true,
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
          isVerified: false,
        ),
      );
      return null;
    }, (success) {
      if (e.fromDeepLink) {
        NavigationService.pushNamed(
          routeName: RouteName.ekramRequestTransportationScreen,
          args: this,
        );
        Future.delayed(const Duration(seconds: 1)).then((e) {
          add(const GoToNextPageEvent());
        });
      }
      emit(
        state.copyWith(
          isDeceasedBtnEnabled: false,
          status: BlocStatus.success,
          isVerified: true,
          requestId: success.data?.result,
          errorMessage: "",
        ),
      );
    });
  }

  Future<void> _getRequestDetailsHandler(
      getRequestDetailsEvent e, Emitter emitter) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getRequestDetails(e.requestId);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
          isVerified: false));
      return null;
    }, (res) {
      RequestDetailsResponseModel? model = res.data?.result;
      if (model != null && model.deceasedInfo?.deceasedDataSource == "BALADY") {
        DeathInfo? deathInfo = model.deathInfo;
        deathInfo = deathInfo?.copyWith(
            deathDate: CommonFunctions.gregorianToHijri(
                DateFormat('yyyy/MM/dd').format(DateTime.now())),
            gregorianDeathDate:
                DateFormat('yyyy/MM/dd').format(DateTime.now()));

        model = model.copyWith(deathInfo: deathInfo);
      }

      emit(state.copyWith(
        status: BlocStatus.success,
        isVerified: true,
        requestDetailsModel: model,
        cemeteryReservationMsg: res.data?.result?.cemeteryReservationMsg,
        editInfoSection: isScreenEditable(res.data?.result),
        errorMessage: "",
      ));
    });
  }

  Future<void> _getCurrentTrackLocationHandler(
      getCurrentTrackLocationEvent e, Emitter emitter) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCurrentTrackLocation(e.requestId);
    return failureOrSuccess.fold(
      (failure) {
        emit(state.copyWith(
            status: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
            isVerified: false));
        return null;
      },
      (res) {
        if (res.data != null && res.data?.result != null) {
          // Extracting x and y correctly from result
          String? x = res.data?.result['x'];
          String? y = res.data?.result['y'];

          if (x != null && y != null) {
            CommonFunctions.openMap(double.parse(y), double.parse(x));
          }
        }

        emit(
          state.copyWith(
            status: BlocStatus.success,
            lat: res.data?.result?['x'],
            long: res.data?.result?['y'],
            errorMessage: "",
          ),
        );
      },
    );
  }

  Future<void> _saveDeceasedInfoHandler(
      saveDeceasedInfoEvent e, Emitter emitter) async {
    emit(state.copyWith(status: BlocStatus.loading));
    var deceasedInfo = state.requestDetailsModel?.deceasedInfo;
    deceasedInfo?.isMuslim ??= true;
    deceasedInfo?.gender ??= "MALE";

    var mainInfo = state.requestDetailsModel?.mainInfo;
    mainInfo?.transportCaseId = 3;
    final failureOrSuccess = await _saveDeceasedInfo([
      state.requestId!,
      SaveDeceasedInfoParams(mainInfo: mainInfo, deceasedInfo: deceasedInfo)
    ]);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
          isVerified: false));
      return null;
    }, (res) {
      emit(state.copyWith(
        status: BlocStatus.success,
        isVerified: true,
        errorMessage: "",
      ));
      if (e.isDarft == true) {
        _ShowDraftMessage();
      } else {
        add(const GoToNextPageEvent());
      }
    });
  }

  void _ShowDraftMessage() {
    FocusManager.instance.primaryFocus?.unfocus();
    NavigationService.navigatorKey.currentState!.pop();

    CommonFunctions.showSuccess("cancellation_license_message".tr());
  }

  Future<void> _saveDeceasedBurialInfoHandler(
      saveBurianDeathInfoEvent e, Emitter emitter) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _saveDeathBurialInfo([
      state.requestId!,
      SaveDeathBurialInfoParams(
          deathInfo: state.requestDetailsModel?.deathInfo,
          burialInfo: state.requestDetailsModel?.burialInfo,
          transportInfo: state.requestDetailsModel?.transportInfo,
          cemeteryData: state.requestDetailsModel?.cemeteryData)
    ]);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
          isVerified: false));

      return null;
    }, (res) {
      emit(state.copyWith(
        status: BlocStatus.success,
        isVerified: true,
        errorMessage: "",
      ));

      if (e.isDarft == true) {
        _ShowDraftMessage();
      } else {
        add(const GoToNextPageEvent());
      }
    });
  }

  Future<void> _changeDeceasedInfoDataHanlder(
      ChangeDeceasedUserInfoEvent e, Emitter emitter) async {
    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(
        deceasedInfo: DeceasedInfo(gender: "MALE", isMuslim: true),
        mainInfo: MainInfo());

    DeceasedInfo info = params.deceasedInfo!;

    info = info.copyWith(
        nationalityId: e.item?.nationalityId,
        firstName: e.item?.firstName,
        secondName: e.item?.secondName,
        thirdName: e.item?.thirdName,
        fourthName: e.item?.fourthName,
        isMuslim: e.item?.isMuslim,
        gender: e.item?.gender);
    params = params.copyWith(deceasedInfo: info);

    emitter(state.copyWith(
        errorMessage: "",
        status: BlocStatus.success,
        requestDetailsModel: params));
  }

  Future<void> _setApplicantInfoDataHanlder(
      SetApplicantInfoEvent e, Emitter emitter) async {
    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(
        deceasedInfo: DeceasedInfo(gender: "MALE", isMuslim: true),
        mainInfo: MainInfo());

    MainInfo info = params.mainInfo!;
    SubmitterInfo submitter = SubmitterInfo(
        fullName: state.fullName,
        mobileNumber: state.mobileNumber,
        relationship: e.relation);

    info = info.copyWith(
      submitterInfo: submitter,
    );
    params = params.copyWith(mainInfo: info);

    emitter(state.copyWith(
        errorMessage: "",
        status: BlocStatus.success,
        requestDetailsModel: params));
  }

  Future<void> _changeDeathandBurialHandler(
      ChangeDeathInfoEvent e, Emitter emitter) async {
    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(
      deathInfo: DeathInfo(countryId: 1),
    );

    DeathInfo info = params.deathInfo!;

    info = info.copyWith(
        deathDate: e.deathInfo?.deathDate,
        gregorianDeathDate: e.deathInfo?.gregorianDeathDate,
        countryId: e.deathInfo?.countryId ?? (info.countryId),
        cityId: state.requestDetailsModel?.deathInfo
                    ?.isCountryChanged(e.deathInfo?.countryId) ==
                false
            ? e.deathInfo?.cityId
            : -1,
        corpseArrivalCityId: state.requestDetailsModel?.deathInfo
                    ?.isCountryChanged(e.deathInfo?.countryId) ==
                false
            ? e.deathInfo?.corpseArrivalCityId
            : -1,
        cityOther: e.deathInfo?.cityOther,
        hospitalId: e.deathInfo?.hospitalId,
        showHospitalOther: e.deathInfo?.showHospitalOther,
        hospitalOther: e.deathInfo?.hospitalOther,
        caseContagious: e.deathInfo?.caseContagious);
    int? newCityId;

    params = params.copyWith(deathInfo: info);
    if (state.requestDetailsModel?.deathInfo?.countryId == 1) {
      newCityId = e.deathInfo?.cityId;
    } else {
      newCityId = e.deathInfo!.corpseArrivalCityId;
    }
    emitter(state.copyWith(
        status: BlocStatus.success, requestDetailsModel: params));
  }
  Future<void> _resetActionEventHandler(
      ResetActionEvent e, Emitter emitter) async {
    RequestDetailsResponseModel? params =  _resetDataDependcyHandler(e.action);

    switch (e.action) {
      case ResetActionEnum.Country:
        {


          emitter(state.copyWith(
            burialCities: [],
            deathCities: [],
            bodyArrivalCities: [],
            hospitals: [],
            cemetries: [],
            transportations: [],
            laundries: [],
            mosques: [],
            requestDetailsModel: params,
            status: BlocStatus.success,
          ));

        }
        break;
      case ResetActionEnum.DeathCity:
        {
          emitter(state.copyWith(
            cemetries: [],
            transportations: [],
            laundries: [],
            mosques: [],
            hospitals: [],
            requestDetailsModel: params,
            status: BlocStatus.success,
          ));

        }
        break;
      case ResetActionEnum.Hospital:
        {
          emitter(state.copyWith(
            //cemetries: [],
            status: BlocStatus.success,

          ));
        }
        break;

      case ResetActionEnum.GraveType:
        {
          emitter(state.copyWith(
            cemetries: [],
            transportations: [],
            laundries: [],
            requestDetailsModel: params,
            status: BlocStatus.success,
          ));

        }
        break;
      case ResetActionEnum.prayer:
        {
          emitter(state.copyWith(
            cemetries: [],
            transportations: [],
            laundries: [],
            requestDetailsModel: params,
            status: BlocStatus.success,
          ));

        }
        break;
      case ResetActionEnum.burialCity:
        {
          emitter(state.copyWith(
            cemetries: [],
            transportations: [],
            laundries: [],
            requestDetailsModel: params,
            status: BlocStatus.success,
          ));

        }
        break;
      case ResetActionEnum.Cemetry:
        {
          emitter(state.copyWith(
            transportations: [],
            laundries: [],
            requestDetailsModel: params,
            status: BlocStatus.success,
          ));

        }
        break;
      case ResetActionEnum.Transport:
        {
          emitter(state.copyWith(
            laundries: [],
            requestDetailsModel: params,
            status: BlocStatus.success,
          ));

        }
        break;
    }
  }

  RequestDetailsResponseModel? _resetDataDependcyHandler(ResetActionEnum action)  {


    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(
        deathInfo: DeathInfo(countryId: 1),
        burialInfo: BurialInfo(isBurialInsideDeathCity: true),
        cemeteryData: CemeteryData(),
        transportInfo: TransportInfo());

    DeathInfo? deathInfo = state.requestDetailsModel?.deathInfo;
    BurialInfo? burialInfo = params.burialInfo;
    CemeteryData? cemeteryData = params.cemeteryData;
    TransportInfo? transportInfo = params.transportInfo;


    switch (action) {
      case ResetActionEnum.Country:
        {
          deathInfo = deathInfo?.copyWith(cityId:-1, corpseArrivalCityId: -1, hospitalId: -1);
          burialInfo = burialInfo?.copyWith(cityId: -1, prayId: -1);
          cemeteryData = cemeteryData?.copyWith(cemeteryId: -1, graveTypeId: -1,);
          transportInfo = transportInfo?.copyWith(charityId: -1, ghuslPlaceId: -1, mosqueId: -1,);

          params = params.copyWith(deathInfo: deathInfo,burialInfo: burialInfo,cemeteryData: cemeteryData,transportInfo: transportInfo);

          return params;
        }

      case ResetActionEnum.DeathCity:
        {

          deathInfo = deathInfo?.copyWith(hospitalId: -1);
          burialInfo = burialInfo?.copyWith(cityId: -1, prayId: -1);
          cemeteryData = cemeteryData?.copyWith(cemeteryId: -1, graveTypeId: -1,);
          transportInfo = transportInfo?.copyWith(charityId: -1, ghuslPlaceId: -1, mosqueId: -1,);

          params = params.copyWith(deathInfo: deathInfo,burialInfo: burialInfo,cemeteryData: cemeteryData,transportInfo: transportInfo);

          return params;


        }

      case ResetActionEnum.Hospital:
        {

          return null;
        }


      case ResetActionEnum.GraveType:
        {

          cemeteryData = cemeteryData?.copyWith(cemeteryId: -1);

          transportInfo = transportInfo?.copyWith(charityId: -1, ghuslPlaceId: -1);

          params = params.copyWith(cemeteryData: cemeteryData,transportInfo: transportInfo);

          return params;


        }

      case ResetActionEnum.prayer:
        {
          cemeteryData = cemeteryData?.copyWith(cemeteryId: -1);

          transportInfo = transportInfo?.copyWith(charityId: -1, ghuslPlaceId: -1);

          params = params.copyWith(cemeteryData: cemeteryData,transportInfo: transportInfo);

          return params;
        }
      case ResetActionEnum.burialCity:
        {
          cemeteryData = cemeteryData?.copyWith(cemeteryId: -1);
          transportInfo = transportInfo?.copyWith(charityId: -1, ghuslPlaceId: -1);
          params = params.copyWith(cemeteryData: cemeteryData,transportInfo: transportInfo);

          return params;
        }


      case ResetActionEnum.Cemetry:
        {

          transportInfo = transportInfo?.copyWith(charityId: -1, ghuslPlaceId: -1);

          params = params.copyWith(transportInfo: transportInfo);

          return params;


        }

      case ResetActionEnum.Transport:
        {
          transportInfo = transportInfo?.copyWith( ghuslPlaceId: -1);

          params = params.copyWith(transportInfo: transportInfo);

          return params;


        }
    }
  }


  Future<void> _changeBurialInfoHandler(
      setBurialInfoEvent e, Emitter emitter) async {
    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(
        burialInfo: BurialInfo(
            isBurialInsideDeathCity:
                e.burialInfo?.isBurialInsideDeathCity ?? true));
    BurialInfo info = params.burialInfo!;
    int? cityID;
    if ((info.isBurialInsideDeathCity == null ||
            info.isBurialInsideDeathCity == true) ||
        (e.burialInfo?.isBurialInsideDeathCity == true)) {
      cityID = getBurialCityId();
    } else {
      cityID = e.burialInfo?.cityId;
    }

    info = info.copyWith(
        isBurialInsideDeathCity: e.burialInfo?.isBurialInsideDeathCity ??
            info.isBurialInsideDeathCity ??
            true,
        cityId: cityID,
        burialDate: e.burialInfo?.burialDate,
        gregorianBurialDate: e.burialInfo?.gregorianBurialDate,
        prayId: e.burialInfo?.prayId,
        burialTime: e.burialInfo?.burialTime,
        burialDestination: e.burialInfo?.burialDestination);

    params = params.copyWith(burialInfo: info);

    emitter(state.copyWith(
        status: BlocStatus.success, requestDetailsModel: params));
  }

  Future<void> _changeCemtryInfoHandler(
      setCemtryInfoEvent e, Emitter emitter) async {
    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(cemeteryData: CemeteryData());

    if (params.cemeteryData == null) {
      params = params.copyWith(cemeteryData: CemeteryData());
    }
    CemeteryData info = params.cemeteryData!;

    info = info.copyWith(
      cemeteryId: e.cemeteryData?.cemeteryId,
      graveTypeId: e.cemeteryData?.graveTypeId,
    );

    params = params.copyWith(cemeteryData: info);

    emitter(state.copyWith(
        status: BlocStatus.success,
        requestDetailsModel: params,
        maghsalaExist: e.maghsalaExist));
  }

  Future<void> _changeTansportInfoHandler(
      setTransportInfoEvent e, Emitter emitter) async {
    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(transportInfo: TransportInfo());

    TransportInfo info = params.transportInfo!;

    info = info.copyWith(
      needSpecialTransport: e.transportInfo?.needSpecialTransport,
      specialTransportReasonId: e.transportInfo?.specialTransportReasonId,
      showOther: e.transportInfo?.showOther,
      specialTransportReasonOther: e.transportInfo?.specialTransportReasonOther,
      charityId: e.transportInfo?.charityId,
      ghuslPlaceId: e.transportInfo?.ghuslPlaceId,
      mosqueId: e.transportInfo?.mosqueId,
    );

    params = params.copyWith(transportInfo: info);

    emitter(state.copyWith(
        status: BlocStatus.success, requestDetailsModel: params));
  }

  bool isScreenEditable(RequestDetailsResponseModel? res) {
    if (res?.deceasedInfo?.deceasedDataSource == null ||
        res?.deceasedInfo?.deceasedDataSource == "MANUALLY") {
      return true;
    } else {
      return false;
    }
  }

  int? getBurialCityId() {
    int? burialCityId;

    DeathInfo? deathInfo = state.requestDetailsModel?.deathInfo;
    if (deathInfo != null) {
      if (deathInfo.countryId == 1 && deathInfo.cityId != null) {
        burialCityId = deathInfo.cityId;
      } else if (deathInfo.countryId != 1 &&
          deathInfo.corpseArrivalCityId != null) {
        burialCityId = deathInfo.corpseArrivalCityId;
      }
    }
    if (burialCityId == null) {
      CommonFunctions.showError("chosedeathcity".tr());
    }

    return burialCityId;
  }

  Future<void> _getMadinahEmirateApprovalStatusHandler(
      GetMadinahEmirateApprovalStatusEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getMadinahEmirateApprovalStatus(
        [e.cemetryId, int.parse(e.id!), e.idType]);

    failureOrSuccess.fold((failure) {
      print("failure $failure");

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          madinahEmirateApprovalStatus:
              success.data?.result?.approvalStatusName,
          madinahEmirateApprovalDate: success.data?.result?.approvalDate,
          errorMessage: success.data?.result?.message,
          valid: success.data?.result?.valid));
    });
  }

  void deceasedVerificationSectionValidator(Emitter emitter) {
    if (state.selectedNationalIdType == null) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        isDeceasedBtnEnabled: false,
      ));
    }

    // ignore: curly_braces_in_flow_control_structures
    else if (state.deceasedId == null || state.deceasedId?.isEmpty == true)
      // ignore: curly_braces_in_flow_control_structures
      emitter(state.copyWith(
        status: BlocStatus.success,
        isDeceasedBtnEnabled: false,
      ));
    else if (state.deceassedDOBGorgian == null)
      // ignore: curly_braces_in_flow_control_structures
      emitter(state.copyWith(
        status: BlocStatus.success,
        isDeceasedBtnEnabled: false,
      ));
    else
      // ignore: curly_braces_in_flow_control_structures
      emitter(state.copyWith(
        status: BlocStatus.success,
        isDeceasedBtnEnabled: true,
      ));
  }

  Future<void> _setInitialDataHandler(
      setInitialDataEvent e, Emitter emitter) async {
    decesssedIdentity?.text = e.dataModel?.deceasedInfo?.identityNumber ?? "";

    add(ChangeNationalIdDob(hijriDate: e.dataModel?.deceasedInfo?.birthDate));
    emitter(state.copyWith(
        isVerified: true,
        deceasedId: e.dataModel?.deceasedInfo?.identityNumber,
        isDeceasedBtnEnabled: false,
        isDraft: state.nationalIdTypes != null ? true : false,
        editInfoSection: isScreenEditable(e.dataModel),
        cemeteryReservationMsg: e.dataModel?.cemeteryReservationMsg,
        requestId: e.dataModel?.requestId,
        selectedNationalIdType: state.getNationalIdTypesById(
            e.dataModel?.deceasedInfo?.identityType,
            e.dataModel?.deceasedInfo?.identityTypeName),
        requestDetailsModel: e.dataModel));
  }


}
