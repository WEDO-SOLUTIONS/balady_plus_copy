import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/ekram/data/model/cemetries_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/mosque_ghusl_places_params.dart';
import 'package:balady_plus/app/features/ekram/data/model/transportation_companies_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/get_cemetries_params.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetery_types_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetries.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetries_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_countries.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_launduries_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_mosques_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_prayers.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_special_transport_reasons_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/get_transportation_companies_lookup.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/save_death_burial_info.dart';
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
import '../../../domain/use_cases/get_death_cities.dart';
import '../../../../../core/utils/nullable.dart';
import '../../../domain/use_cases/get_request_details.dart';
import '../../../domain/use_cases/save_deceased_info.dart';


part 'ekram_request_transportation_event.dart';

part 'ekram_request_transportation_state.dart';

class EkramRequestTransportationBloc extends Bloc<
    EkramRequestTransportationEvent, EkramRequestTransportationState> {
  final GetEkramIdentityTypes _getEkramIdentityTypes;

  PageController controller = PageController();
  // TransportRequestsBloc? ekramRequestsBloc;
  late List pagesList = [
    DeceasedVerificationSection(),
    DeceasedInfoSection(),
    const ApplicantInfoSection(),
    const DeathAndBurialInfoSection(),
    const EmirateApprovalInfoSection(),
  ];

  final GetCemeteryTypesLookUp _getCemeteryTypesLookUp;
  final GetHospitals _getHospitals;
  final GetCemetriesLookUp _getCemetries;
  final GetTransportationCompaniesLookUp _getTransportationNames;
  final GetLaundriesLookup _getLaundires;
  final SaveDeathBurialInfo _saveDeathBurialInfo;
  final GetMosquesLookup _getMosques;
  final GetNationalities _getNationalities;
  final ApplyDeceasedTransport _applyDeceasedTransport;
  final GetDeathCities _deathCities;
  final VerifyDeceased _verifyDeceased;
  final GetRequestDetails _getRequestDetails;
  final GetCountreies _getCountreies;
  final SaveDeceasedInfo _saveDeceasedInfo;

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
        _saveDeathBurialInfo = SaveDeathBurialInfo(repository:sl()),
        _getCountreies = GetCountreies(repository: sl()),
        _getCemetries = GetCemetriesLookUp(repository: sl()),
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
        _saveDeceasedInfo = SaveDeceasedInfo(repository: sl()),
        _deathCities = GetDeathCities(repository: sl()),
        _verifyDeceased = VerifyDeceased(repository: sl()),
        super(EkramRequestTransportationState(
            isSpecialTransferNeeded: false,
            isBurialInsideDeathCity: true,
            fullName: CommonProperties.userInfo?.arName ?? "",
            mobileNumber: CommonProperties.userInfo?.getPhone() ?? "",
            requestType: trans("ekram_request_type"),
            requestDetailsModel: null)) {
    on<EkramRequestTransportationEvent>((event, emit) {});
    on<ChangeIsNeedSpecialTransferEvent>(_changeIsNeedSpecialTransferHanlder);
    on<ChangeIsBurialInsideDeathCityEvent>(
        _changeIsBurialInsideDeathCityHanlder);
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

    on<GetHospitalsEvent>(_getHospitalsHandler);
    on<GetCemetriesEvent>(_getCemetriesHandler);
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
    on<saveDeceasedInfoEvent>(_saveDeceasedInfoHandler);
    on<saveBurianDeathInfoEvent>(_saveDeceasedBurialInfoHandler);
    on<ChangeDeathInfoEvent>(_changeDeathandBurialHandler);
    on<setBurialInfoEvent>(_changeBurialInfoHandler);
    on<setTransportInfoEvent>(_changeTansportInfoHandler);
    on<setCemtryInfoEvent>(_changeCemtryInfoHandler);


    getCountries();
    getPrayers();
    getNationalitiesHandler();
    getCitiesHandler();
    getCemetryTypeItemsHandler();
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      agreement: e.isagree,
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
    emitter(
        state.copyWith(selectedtransportation: e.item, errorMessage: ""));
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

  Future<void> _changeIsBurialInsideDeathCityHanlder(
      ChangeIsBurialInsideDeathCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "", isBurialInsideDeathCity: e.isBurialInsideDeathCity));
  }

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
        errorMessage: "",
        deceassedDOBHijri: Nullable(CommonFunctions.padHijriDate(hijri))));
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

  Future<List<LookUpItem>?> getCitiesHandler() async {
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
        cities: success.data?.result,
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

  Future<List<LookUpItem>?> getNationalitiesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getNationalities(NoParams());

    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
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
      success.data?.result
          ?.insert(0, LookUpItem(id: -1, name: trans("other_hospital")));
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
        cemetries: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getLaundriesHandler(GetLandriesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getLaundires([e.transportId, e.params]);
    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        laundries: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<void> _getMosquesHandler(GetMosquesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failureOrSuccess = await _getMosques([e.transportId, e.params]);
    failureOrSuccess.fold((failure) {
      print("failure $failure");
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        laundries: success.data?.result,
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
      controller.jumpToPage(prvoiusPage);
      sendStepPage(prvoiusPage);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: prvoiusPage));
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
  }

  // fawzi
  Future<void> _verifyDeceasedHandler(
      VerifyDeceasedEvent e, Emitter emitter) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _verifyDeceased(VerifyDeceasedParams(
        identityNumber: state.deceasedId!,
        identityType: state.selectedNationalIdType!.id!,
        birthDate: state.deceassedDOBHijri!,
        submitterBirthDate: CommonProperties.userInfo!.getHijriBirthDate(),
        submitterMobile: CommonProperties.userInfo!.getPhone()));
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
          isVerified: false));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        isVerified: true,
        requestId: success.data?.result,
        errorMessage: "",
      ));
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
      emit(state.copyWith(
        status: BlocStatus.success,
        isVerified: true,
        requestDetailsModel: res.data?.result,
        editInfoSection: isScreenEditable(res.data?.result),
        errorMessage: "",
      ));
    });
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
      add(GoToNextPageEvent());
    });
  }
  Future<void> _saveDeceasedBurialInfoHandler(
      saveBurianDeathInfoEvent e, Emitter emitter) async {
    emit(state.copyWith(status: BlocStatus.loading));
    var deceasedInfo = state.requestDetailsModel?.deceasedInfo;
    deceasedInfo?.isMuslim ??= true;
    deceasedInfo?.gender ??= "MALE";

    var mainInfo = state.requestDetailsModel?.mainInfo;
    mainInfo?.transportCaseId = 3;
    final failureOrSuccess = await _saveDeathBurialInfo([
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
      add(GoToNextPageEvent());
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

  Future<void> _changeDeathandBurialHandler(ChangeDeathInfoEvent e, Emitter emitter) async {



    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(
      deathInfo: DeathInfo(countryId: 1),);

    DeathInfo info = params.deathInfo!;

    info = info.copyWith(
        deathDate: e.deathInfo?.deathDate,
        gregorianDeathDate: e.deathInfo?.gregorianDeathDate,
        countryId: e.deathInfo?.countryId?? (info.countryId ?? 1),
        cityId: e.deathInfo?.cityId,
        corpseArrivalCityId: e.deathInfo?.corpseArrivalCityId,
        cityOther:e.deathInfo?.cityOther ,
        hospitalId: e.deathInfo?.hospitalId,
        showHospitalOther: e.deathInfo?.showHospitalOther,
        hospitalOther: e.deathInfo?.hospitalOther,
        caseContagious: e.deathInfo?.caseContagious
    );

    params = params.copyWith(deathInfo: info);


    emitter(state.copyWith(
        status: BlocStatus.success,
        requestDetailsModel: params));


  }



  Future<void> _changeBurialInfoHandler(setBurialInfoEvent e, Emitter emitter) async {

    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(burialInfo: BurialInfo(isBurialInsideDeathCity:true));
    BurialInfo info = params.burialInfo!;
    int? cityID;
    if(e.burialInfo?.isBurialInsideDeathCity != false) {
      cityID = getBurialCityId();
    }

    info = info.copyWith(
      isBurialInsideDeathCity: e.burialInfo?.isBurialInsideDeathCity??true,
      cityId: e.burialInfo?.isBurialInsideDeathCity == false? e.burialInfo?.cityId:cityID??-1,
      burialDate: e.burialInfo?.burialDate,
      gregorianBurialDate: e.burialInfo?.gregorianBurialDate,
      prayId: e.burialInfo?.prayId,
      burialDestination: e.burialInfo?.burialDestination


    );

    params = params.copyWith(burialInfo: info);

    emitter(state.copyWith(
        status: BlocStatus.success,
        requestDetailsModel: params));


  }

  Future<void> _changeCemtryInfoHandler(setCemtryInfoEvent e, Emitter emitter) async {

    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(cemeteryData: CemeteryData());

    CemeteryData info = params.cemeteryData!;

    info = info.copyWith(
    );

    params = params.copyWith(cemeteryData: info);

    emitter(state.copyWith(
        status: BlocStatus.success,
        requestDetailsModel: params));


  }

  Future<void> _changeTansportInfoHandler(setTransportInfoEvent e, Emitter emitter) async {

    RequestDetailsResponseModel? params = state.requestDetailsModel;
    params ??= RequestDetailsResponseModel(transportInfo: TransportInfo());

    TransportInfo info = params.transportInfo!;

    info = info.copyWith(
    );

    params = params.copyWith(transportInfo: info);

    emitter(state.copyWith(
        status: BlocStatus.success,
        requestDetailsModel: params));


  }



  bool isScreenEditable(RequestDetailsResponseModel? res) {
    if (res?.deceasedInfo?.deceasedDataSource == null ||
        res?.deceasedInfo?.deceasedDataSource == "MANUALLY") {
      return true;
    } else {
      return false;
    }
  }

  int? getBurialCityId(){
    int? burialCityId;

      DeathInfo? deathInfo = state.requestDetailsModel?.deathInfo;
      if(deathInfo != null && deathInfo.countryId != null)
      {
        if(deathInfo.countryId==1 && deathInfo.cityId != null)
        {
          burialCityId= deathInfo.cityId;
        }
        else  if(deathInfo.countryId !=1 && deathInfo.corpseArrivalCityId != null)
        {
          burialCityId= deathInfo.corpseArrivalCityId;
        }
      }
      if(burialCityId == null)
        {
          CommonFunctions.showError("chosedeathcity".tr());
        }

      return burialCityId;


  }

}
