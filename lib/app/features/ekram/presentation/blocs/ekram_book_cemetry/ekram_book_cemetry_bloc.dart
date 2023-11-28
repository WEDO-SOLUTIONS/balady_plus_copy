import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/book_cemetry_params.dart';
import '../../../domain/entities/get_cemetries_params.dart';
import '../../../domain/entities/user_info_request_params.dart';
import '../../../domain/entities/user_info_response.dart';
import '../../../domain/use_cases/book_cemetry.dart';
import '../../../domain/use_cases/check_user_info.dart';
import '../../../domain/use_cases/get_active_cities.dart';
import '../../../domain/use_cases/get_cemetries.dart';
import '../../../domain/use_cases/get_ekram_lookups.dart';
import '../../widgets/ekram_book_cemetry/agreement_section.dart';
import '../../widgets/ekram_book_cemetry/applicant_info_section.dart';
import '../../widgets/ekram_book_cemetry/cemetry_burial_info_section.dart';
import '../../widgets/ekram_book_cemetry/cemetry_deceased_info_section.dart';
import '../ekram_requests_bloc/ekram_requests_bloc.dart';

part 'ekram_book_cemetry_event.dart';

part 'ekram_book_cemetry_state.dart';

class EkramBookCemetryBloc
    extends Bloc<EkramBookCemetryEvent, EkramBookCemetryState> {
  PageController controller = PageController();
  EkramRequestsBloc? ekramRequestsBloc;
  late List pagesList = [
    ApplicantInfoSection(),
    CemetryDeceasedInfoSection(),
    CemetryBurialInfoSection(),
    AgreementSection()
  ];

  final GetEkramLookUp _getEkramLookUp;
  final CheckUserinfo _checkUserInfo;
  final GetCemetries _getCemetries;

  final GetActiveCities _getCities;
  final BookCemetry _bookCemetry;

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
        super(EkramBookCemetryState(
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
    on<ChangeCemetrySizeEvent>(_changeCemetrySizeEventHandler);
    on<ChangeCemetryEvent>(_changeCemetryEventHandler);
    on<ChangeBurialDateEvent>(_changeBurialDateEventHandler);
    on<ChangeBurialTimevent>(_changeBurialTimeventHandler);
    on<ChangeBurialTimeOtherNameEvent>(_changeBurialTimeOtherNameHandler);
    on<ChangeReligionEvent>(_changeReligionHandler);

    on<ChangeIsEpidamicEvent>(_changeIsEpidamicHandler);

    on<GetCemetriesEvent>(_getCemetriesHandler);

    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GoToNextPageEvent>(_goToNextPageHandler);

    on<ChangeRelationShipEvent>(_changeRelationShipHanlder);

    on<SubmitRequestEvent>(_submitRequestEvent);

    getCitiesHandler();
    getNationalTypesHandler();
    getCemetrySizeItemsHandler();
    getCemetryTypeItemsHandler();
    getBurialTimesItemsHandler();
    getReligionsHandler();
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    emitter(state.copyWith(agreement: e.isagree, errorMessage: ""));
  }

  Future<void> _changeNationalIdHandler(
      ChangeNationalId e, Emitter emitter) async {
    emitter(state.copyWith(
        deceassedId: e.text, clearUserInfo: true, errorMessage: ""));
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
      List<int> dateSplitted =
          e.hijriDate!.split("/").map((e) => int.parse(e)).toList();
      var g_date = HijriCalendar();
      DateTime gorgianDate = g_date.hijriToGregorian(
          dateSplitted[0], dateSplitted[1], dateSplitted[2]);
      gorgian = DateFormat('yyyy/MM/dd').format(gorgianDate);
    }
    print(gorgian);

    emitter(state.copyWith(
        deceassedDOBGorgian: CommonFunctions.padHijriDate(gorgian),
        errorMessage: "",
        deceassedDOBHijri: CommonFunctions.padHijriDate(hijri),
        clearUserInfo: true));
  }

  Future<void> _changeNationalTypeHandler(
      ChangeNationalType e, Emitter emitter) async {
    emitter(state.copyWith(
        selectedNationalType: e.item, clearUserInfo: true, errorMessage: ""));
  }

  Future<void> _changeBurialCityEventHandler(
      ChangeBurialCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCity: e.item, errorMessage: ""));

    add(GetCemetriesEvent());
  }

  Future<void> _changeCemetryTypeEventHandler(
      ChangeCemetryTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCemetryType: e.item, errorMessage: ""));

    add(GetCemetriesEvent());
  }

  Future<void> _changeCemetrySizeEventHandler(
      ChangeCemetrySizeEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCemetrySize: e.item, errorMessage: ""));

    add(GetCemetriesEvent());
  }

  Future<void> _changeIsEpidamicHandler(
      ChangeIsEpidamicEvent e, Emitter emitter) async {
    emitter(state.copyWith(isPandemicDeath: e.value, errorMessage: ""));

    add(GetCemetriesEvent());
  }

  Future<void> _changeCemetryEventHandler(
      ChangeCemetryEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedCemetry: e.item, errorMessage: ""));
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
        burialDateHijri: CommonFunctions.padHijriDate(hijri)));
    add(GetCemetriesEvent());
  }

  Future<void> _changeBurialTimeventHandler(
      ChangeBurialTimevent e, Emitter emitter) async {
    emitter(state.copyWith(
        selectedTime: e.item, clearOtherBurialTime: true, errorMessage: ""));
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
    emitter(state.copyWith(selectedReligion: e.item));
    add(GetCemetriesEvent());
  }

  Future<void> _changeRelationShipHanlder(
      ChangeRelationShipEvent e, Emitter emitter) async {
    emitter(state.copyWith(relation: e.text, errorMessage: ""));
  }

  Future<void> _checkUserInfoHandler(
      CheckUserInfoEvent e, Emitter emitter) async {
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
      emitter(state.copyWith(
        status: BlocStatus.success,
        userInfoResponse: success.data?.result,
        errorMessage: "",
      ));
    });
  }

  Future<List<LookUpItem>?> getNationalTypesHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramLookUp(1002);
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

  Future<List<LookUpItem>?> getReligionsHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramLookUp(100);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        religions: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getCemetrySizeItemsHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramLookUp(8000);
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        cemetrySizeItems: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getCemetryTypeItemsHandler() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getEkramLookUp(400);
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

    final failureOrSuccess = await _getEkramLookUp(30970);
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

  Future<void> _getCemetriesHandler(
      GetCemetriesEvent e, Emitter emitter) async {
    if (state.selectedCemetrySize != null &&
        state.selectedCemetryType != null &&
        state.selectedCity != null &&
        state.burialDateHijri != null &&
        state.burialDateGorgian != null &&
        state.isPandemicDeath != null &&
        state.userInfoResponse != null) {
      emitter(state.copyWith(status: BlocStatus.loading));

      final failureOrSuccess = await _getCemetries(GetCemetriesParams(
          burialCityId: state.selectedCity!.id!,
          cemeterySizeId: state.selectedCemetrySize!.id!,
          cemeteryTypeId: state.selectedCemetryType!.id!,
          burialDate: state.burialDateGorgian!,
          isPandemicDeath: state.isPandemicDeath!,
          nationalityId: state.userInfoResponse!.nationalityCode!,
          religionId: state.showReligion()
              ? state.selectedReligion!.id!
              : state.userInfoResponse!.religionCode!));

      failureOrSuccess.fold((failure) {
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
  }

  Future<void> _submitRequestEvent(
      SubmitRequestEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    hideKeyboard();

    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _bookCemetry(BookCemetryParamas(
        burialCityId: state.selectedCity!.id!,
        burialDate: state.burialDateGorgian!,
        burialTimeId: state.selectedTime!.id!,
        burialTimeOther: state.otherTimeName ?? "",
        cemeteryId: state.selectedCemetry!.id!,
        cemeterySizeId: state.selectedCemetrySize!.id!,
        cemeteryTypeId: state.selectedCemetryType!.id!,
        deceasedBirthDate: state.deceassedDOBHijri!,
        deceasedIdentityNumber: state.deceassedId!,
        deceasedIdentityTypeId: state.selectedNationalType!.id!,
        isPandemicDeath: state.isPandemicDeath!,
        relationship: state.relation,
        religionId: state.showReligion()
            ? state.selectedReligion!.id!
            : state.userInfoResponse!.religionCode!));

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

      /*  ekramRequestsBloc
          ?.add(GetDeceasedTransportRequestsEvent(isDriver: false));
     
     */
      //MM Ekram
      /*   NavigationService.navigatorKey.currentState!.pushReplacementNamed(
          RouteName.ekramSuccessScreen,
          arguments: EkramSuccessPageParams(
              type: EkramType.cemetry,
              msg: success.data?.responseMessage,
              ekramBloc: ekramRequestsBloc));*/
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
    await controller.animateToPage(nextPage,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
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
      await controller.animateToPage(prvoiusPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
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
}
