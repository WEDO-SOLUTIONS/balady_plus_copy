import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart'
    hide ApplicantInfoSection, AgreementSection;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/nullable.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../ekram_inquiry_service/domain/use_cases/get_ekram_cities.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/book_cemetry_params.dart';
import '../../../domain/entities/ekram_success_page_params.dart';
import '../../../domain/entities/get_cemetries_params.dart';
import '../../../domain/entities/user_info_request_params.dart';
import '../../../domain/entities/user_info_response.dart';
import '../../../domain/use_cases/book_cemetry.dart';
import '../../../domain/use_cases/check_user_info.dart';
import '../../../domain/use_cases/get_active_cities.dart';
import '../../../domain/use_cases/get_cemetries.dart';
import '../../../domain/use_cases/get_countries.dart';
import '../../../domain/use_cases/get_ekram_lookups.dart';
import '../../../domain/use_cases/get_nationality_types.dart';
import '../../widgets/ekram_book_cemetry/agreement_section.dart';
import '../../widgets/ekram_book_cemetry/applicant_info_section.dart';
import '../../widgets/ekram_book_cemetry/cemetry_deceased_info_section.dart';
import '../ekram_requests_bloc/ekram_requests_bloc.dart';

part 'ekram_book_cemetry_event.dart';

part 'ekram_book_cemetry_state.dart';

class EkramBookCemetryBloc
    extends Bloc<EkramBookCemetryEvent, EkramBookCemetryState> {
  PageController controller = PageController();

  final nationalIdController = TextEditingController();

  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final thirdNameController = TextEditingController();
  final fourthNameController = TextEditingController();

  EkramRequestsBloc? ekramRequestsBloc;
  late List pagesList = [
    ApplicantInfoSection(),
    CemetryDeceasedInfoSection(),
    AgreementSection()
  ];

  final GetEkramLookUp _getEkramLookUp;
  final CheckUserinfo _checkUserInfo;
  final GetCemetries _getCemetries;
  final GetActiveCities _getCities;
  final GetEkramCities _getEkramCities;
  final BookCemetry _bookCemetry;
  final GetNationalityTypes _getNationalityTypes;
  final GetNationalities _getNationalities;
  final GetCountreies _getCountreies;

  EkramBookCemetryBloc(
      {required GetEkramLookUp getEkramLookUp,
      required CheckUserinfo checkUserInfo,
      required GetCemetries getCemetries,
      required GetActiveCities getCities,
      required BookCemetry bookCemetry,
      this.ekramRequestsBloc})
      : _getEkramLookUp = getEkramLookUp,
        _checkUserInfo = checkUserInfo,
        _getCemetries = getCemetries,
        _getCities = getCities,
        _bookCemetry = bookCemetry,
        _getNationalityTypes = GetNationalityTypes(repository: sl()),
        _getNationalities = GetNationalities(repository: sl()),
        _getCountreies = GetCountreies(repository: sl()),
        _getEkramCities = GetEkramCities(repository: sl()),
        super(EkramBookCemetryState(
            isFetus: false,
            fullName: CommonProperties.userInfo?.arName ?? "",
            mobileNumber: CommonProperties.userInfo?.getPhone() ?? "",
            requestType: trans("ekram_request_type"))) {
    on<EkramBookCemetryEvent>((event, emit) {});
    on<ChangeAgreementEvent>(_changeAgreementHandler);

    on<ChangeNationalId>(_changeNationalIdHandler);
    on<ChangeNationalIdDob>(_changeNationalIdDobHandler);
    on<ChangeNationalType>(_changeNationalTypeHandler);
    on<CheckUserInfoEvent>(_checkUserInfoHandler);

    on<ChangeBurialCityEvent>(_changeBurialCityEventHandler);
    on<ChangeCemetryTypeEvent>(_changeCemetryTypeEventHandler);
    on<ChangeCemetryEvent>(_changeCemetryEventHandler);
    on<ChangeBurialDateEvent>(_changeBurialDateEventHandler);
    on<ChangeBurialTimevent>(_changeBurialTimeventHandler);
    on<ChangeBurialTimeOtherNameEvent>(_changeBurialTimeOtherNameHandler);
    on<ChangeReligionEvent>(_changeReligionHandler);
    on<ChangeIsEpidamicEvent>(_changeIsEpidamicHandler);

    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GoToNextPageEvent>(_goToNextPageHandler);

    on<ChangeRelationShipEvent>(_changeRelationShipHanlder);
    on<ChangeIsFetus>(_changeIsFetus);
    on<SubmitRequestEvent>(_submitRequestEvent);
    on<ChangeGenderEvent>(_changeGenderHandler);
    on<ChangeNameEvent>(_changeNameHandler);
    on<GetNationalityEvent>(_changeNationalityHandler);

    on<ChangeCountryEvent>(_changeCountryHandler);
    on<ChangeDeathCityEvent>(_changeDeathCityHandler);

    on<ChangeOtherCityEvent>(_changeOtherCityyHandler);

    getCitiesHandler();
    getNationalTypesHandler();
    getCemetryTypeItemsHandler();
    getBurialTimesItemsHandler();
    getNationalities();
    getCountries();
    getDeathCities();
    //getReligionsHandler();
  }

  Future<void> _changeNameHandler(ChangeNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        firstName: e.firstName != null ? Nullable(e.firstName) : null,
        secondName: e.secondName != null ? Nullable(e.secondName) : null,
        thirdName: e.thirdName != null ? Nullable(e.thirdName) : null,
        fourthName: e.fourthName != null ? Nullable(e.fourthName) : null,
        errorMessage: ""));
  }

  Future<void> _changeNationalityHandler(
      GetNationalityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        selectedNationality: Nullable(e.item),
        errorMessage: "",
        cemetries: [],
        selectedCemetry: Nullable(null)));
  }

  Future<void> _changeOtherCityyHandler(
      ChangeOtherCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(otherDeathCity: e.text, errorMessage: ""));
  }

  Future<void> _changeCountryHandler(
      ChangeCountryEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCountry: e.item, errorMessage: ""));
  }

  Future<void> _changeDeathCityHandler(
      ChangeDeathCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedDeathCity: e.item, errorMessage: ""));
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    emitter(state.copyWith(agreement: e.isagree, errorMessage: ""));
  }

  Future<void> _changeNationalIdHandler(
      ChangeNationalId e, Emitter emitter) async {
    emitter(state.copyWith(
        deceassedId: Nullable(e.text),
        clearUserInfo: true,
        errorMessage: "",
        firstName: Nullable(null),
        secondName: Nullable(null),
        thirdName: Nullable(null),
        fourthName: Nullable(null),
        deceassedDOBGorgian: Nullable(null),
        deceassedDOBHijri: Nullable(null),
        isMuslim: Nullable(null),
        gender: Nullable(null),
        selectedNationality: Nullable(null)));

    firstNameController.text = "";
    secondNameController.text = "";
    thirdNameController.text = "";
    fourthNameController.text = "";
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
      var g_date = HijriCalendar();
      DateTime gorgianDate = g_date.hijriToGregorian(
          dateSplitted[0], dateSplitted[1], dateSplitted[2]);
      gorgian = DateFormat('yyyy/MM/dd').format(gorgianDate);
    }
    print(gorgian);
    print(hijri);

    emitter(state.copyWith(
        deceassedDOBGorgian: Nullable(CommonFunctions.padHijriDate(gorgian)),
        errorMessage: "",
        deceassedDOBHijri: Nullable(CommonFunctions.padHijriDate(hijri)),
        clearUserInfo: true));
  }

  Future<void> _changeNationalTypeHandler(
      ChangeNationalType e, Emitter emitter) async {
    emitter(state.copyWith(
      selectedNationalType: e.item,
      clearUserInfo: true,
      errorMessage: "",
      selectedNationality: Nullable(null),
      firstName: Nullable(null),
      secondName: Nullable(null),
      thirdName: Nullable(null),
      fourthName: Nullable(null),
      deceassedDOBGorgian: Nullable(null),
      deceassedDOBHijri: Nullable(null),
      isMuslim: Nullable(null),
      gender: Nullable(null),
    ));
    firstNameController.text = "";
    secondNameController.text = "";
    thirdNameController.text = "";
    fourthNameController.text = "";
  }

  Future<void> _changeBurialCityEventHandler(
      ChangeBurialCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        selectedCity: e.item,
        errorMessage: "",
        cemetries: [],
        selectedCemetry: Nullable(null)));

    //getCemetriesHandler();
  }

  Future<void> _changeCemetryTypeEventHandler(
      ChangeCemetryTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        selectedCemetryType: e.item,
        errorMessage: "",
        cemetries: [],
        selectedCemetry: Nullable(null)));

    //  getCemetriesHandler();
  }

  Future<void> _changeIsEpidamicHandler(
      ChangeIsEpidamicEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        isPandemicDeath: e.value,
        errorMessage: "",
        cemetries: [],
        selectedCemetry: Nullable(null)));

    // getCemetriesHandler();
  }

  Future<void> _changeCemetryEventHandler(
      ChangeCemetryEvent e, Emitter emitter) async {
    emitter(
        state.copyWith(selectedCemetry: Nullable(e.item), errorMessage: ""));
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
      List<int> dateSplitted =
          e.hijriDate!.split("/").map((e) => int.parse(e)).toList();
      var g_date = HijriCalendar();
      DateTime gorgianDate = g_date.hijriToGregorian(
          dateSplitted[0], dateSplitted[1], dateSplitted[2]);
      gorgian = DateFormat('yyyy/MM/dd').format(gorgianDate);
    }
    print(gorgian);

    emitter(state.copyWith(
        burialDateGorgian: CommonFunctions.padHijriDate(gorgian),
        errorMessage: "",
        cemetries: [],
        selectedCemetry: Nullable(null),
        burialDateHijri: CommonFunctions.padHijriDate(hijri)));
    // getCemetriesHandler();
  }

  Future<void> _changeBurialTimeventHandler(
      ChangeBurialTimevent e, Emitter emitter) async {
    emitter(state.copyWith(
        selectedTime: e.item,
        clearOtherBurialTime: true,
        errorMessage: "",
        cemetries: [],
        selectedCemetry: Nullable(null)));
  }

  Future<void> _changeBurialTimeOtherNameHandler(
      ChangeBurialTimeOtherNameEvent e, Emitter emitter) async {
    DateTime? time = await DatePicker.showTimePicker(
      NavigationService.navigatorKey.currentContext!,
      showSecondsColumn: false,
      showTitleActions: true,
      locale: LocaleType.ar,
      theme: DatePickerTheme(),
      onConfirm: (date) {
        print('confirm $date');
      },
      currentTime: DateTime.now(),
    );

    String formatted = DateFormat("hh:mm").format(time!).toString();
    emitter(state.copyWith(
      otherTimeName: formatted,
    ));
  }

  Future<void> _changeReligionHandler(
      ChangeReligionEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        isMuslim: Nullable(e.value),
        cemetries: [],
        selectedCemetry: Nullable(null)));
  }

  Future<void> _changeIsFetus(ChangeIsFetus e, Emitter emitter) async {
    emitter(state.copyWith(
        isFetus: e.value,
        selectedNationality: Nullable(null),
        clearUserInfo: true,
        errorMessage: "",
        cemetries: [],
        selectedCemetry: Nullable(null),
        firstName: Nullable(null),
        secondName: Nullable(null),
        thirdName: Nullable(null),
        fourthName: Nullable(null),
        deceassedDOBGorgian: Nullable(null),
        deceassedDOBHijri: Nullable(null),
        isMuslim: Nullable(null),
        gender: Nullable(null)));
    firstNameController.text = "";
    secondNameController.text = "";
    thirdNameController.text = "";
    fourthNameController.text = "";
  }

  Future<void> _changeGenderHandler(
      ChangeGenderEvent e, Emitter emitter) async {
    emitter(state.copyWith(gender: Nullable(e.value)));
  }

  Future<void> _changeRelationShipHanlder(
      ChangeRelationShipEvent e, Emitter emitter) async {
    emitter(state.copyWith(relation: e.text, errorMessage: ""));
  }

  Future<void> _checkUserInfoHandler(
      CheckUserInfoEvent e, Emitter emitter) async {
    if (state.nationalities?.isEmpty ?? true) {
      await getNationalities();
    }
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _checkUserInfo(UserInfoRequestParams(
        dob: state.deceassedDOBHijri ?? "",
        nationalId: state.deceassedId ?? ""));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      String firstName = success.data?.result?.firstName ?? "";
      String secondName = success.data?.result?.secondName ?? "";
      String thirdName = success.data?.result?.thirdName ?? "";
      String fourthName = success.data?.result?.familyName ?? "";
      int? gender = success.data?.result?.genderCode;
      bool? isMuslim = success.data?.result?.religionCode == 1
          ? true
          : (success.data?.result?.religionCode != null)
              ? false
              : null;

      LookUpItem? nationality = state.nationalities?.firstWhereOrNull(
          (element) => element.id == success.data?.result?.nationalityCode);
      emitter(state.copyWith(
          status: BlocStatus.success,
          userInfoResponse: success.data?.result,
          cemetries: [],
          selectedCemetry: Nullable(null),
          errorMessage: "",
          firstName: Nullable(firstName),
          secondName: Nullable(secondName),
          thirdName: Nullable(thirdName),
          fourthName: Nullable(fourthName),
          gender: Nullable(gender),
          selectedNationality: Nullable(nationality),
          isMuslim: Nullable(isMuslim)));

      firstNameController.text = firstName;
      secondNameController.text = secondName;
      thirdNameController.text = thirdName;
      fourthNameController.text = fourthName;
    });
  }

  Future<List<LookUpItem>?> getNationalTypesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getNationalityTypes(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        nationalTypes: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getNationalities() async {
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
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getDeathCities() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramCities(NoParams());
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        deathCities: success,
        errorMessage: "",
      ));
      return success;
    });
  }

  Future<List<LookUpItem>?> getCemetryTypeItemsHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramLookUp("GRAVE_TYPES");
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
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getBurialTimesItemsHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramLookUp("PRAYERS");
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        burialTimeItems: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getCitiesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getCities(NoParams());
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

  Future<List<LookUpItem>?> getCemetriesHandler() async {
    if (state.selectedCemetryType != null &&
        state.selectedCity != null &&
        state.burialDateHijri != null &&
        state.burialDateGorgian != null &&
        state.isPandemicDeath != null &&
        state.selectedNationality != null &&
        state.isFetus != null &&
        state.isMuslim != null &&
        state.selectedTime != null) {
      emit(state.copyWith(status: BlocStatus.loading));

      final failureOrSuccess = await _getCemetries(GetCemetriesParams(
          burialCityId: state.selectedCity!.id!,
          cemeteryTypeId: state.selectedCemetryType!.id!,
          burialDate: state.burialDateGorgian!,
          isPandemicDeath: state.isPandemicDeath!,
          nationalityId: state.selectedNationality!.id!,
          isFetus: state.isFetus!,
          isMuslim: state.isMuslim!,
          birthdate: state.deceassedDOBHijri,
          burailTimeId: state.selectedTime!.id!));

      return failureOrSuccess.fold((failure) {
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
        return null;
      }, (success) {
        emit(state.copyWith(
          status: BlocStatus.success,
          cemetries: success.data?.result,
          errorMessage: "",
        ));
        return success.data?.result;
      });
    } else {
      CommonFunctions.showError("FillFields".tr());
    }
  }

  Future<void> _submitRequestEvent(
      SubmitRequestEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.SelectAndReserveCemetery_Send_Request_Event);
    hideKeyboard();

    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _bookCemetry(BookCemetryParamas(
      firstName: state.firstName!,
      secondName: state.secondName,
      thirdName: state.thirdName,
      fourthName: state.fourthName,
      birthDate: state.deceassedDOBHijri,
      prayId: state.selectedTime?.id,
      prayOther:
          state.selectedTime?.id == 30976 ? state.otherTimeName ?? "" : null,
      nationalityId: state.selectedNationality?.id,
      isMuslim: state.isMuslim,
      gender: state.gender!,
      burialCityId: state.selectedCity!.id!,
      burialDate: state.burialDateGorgian!,
      cemeteryId: state.selectedCemetry!.id!,
      deceasedBirthDate: state.deceassedDOBHijri,
      deceasedIdentityNumber:
          state.isFetus == false ? state.deceassedId! : null,
      deceasedIdentityTypeId:
          state.isFetus == false ? state.selectedNationalType!.id! : null,
      isPandemicDeath: state.isPandemicDeath!,
      relationship: state.relation,
      fetus: state.isFetus!,
      graveTypeId: state.selectedCemetryType!.id!,
      deathCountryId: state.selectedCountry!.id,
      deathCityId: state.selectedCountry?.localCountry == true
          ? state.selectedDeathCity?.id
          : null,
      deathCityOther: state.selectedCountry?.localCountry == false
          ? state.otherDeathCity
          : null,
    ));

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      emitter(state.copyWith(
        status: BlocStatus.success,
        errorMessage: "",
      ));


      ekramRequestsBloc?.add(GetCemetryRequestsEvent());

      NavigationService.navigatorKey.currentState!
          .pushReplacementNamed(RouteName.successRoute,
              arguments: SuccessScreenArgs(
                type: PAGE_TYPE.ekramCemetry,
                thanksMessage: success.data?.result?.message,
                  idNumber:"${success.data?.result?.requestId}"
              ));
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.SelectAndReserveCemetery_Open_Success_Page_Event);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.finishServiceSelectAndReserveACemetery);
    });
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
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.SelectAndReserveCemetery_Open_Applicant_Info_Step_Event);
    } else if (page == 1) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.SelectAndReserveCemetery_Open_Deceased_Info_Step_Event);
    } else if (page == 2) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.SelectAndReserveCemetery_Open_Review_Info_Step_Event);
    }
  }
}
