import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/ekram/data/model/save_deceased_info_params/deceased_info.dart';
import 'package:balady_plus/app/features/ekram/data/model/save_deceased_info_params/main_info.dart';
import 'package:balady_plus/app/features/ekram/data/model/save_deceased_info_params/save_deceased_info_params.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/domain/use_cases/verify_deceased.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:balady_plus/app/features/ekram/presentation/widgets/transportation_request_page_view/deceased_transportation_info.dart';
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
import '../../../domain/use_cases/get_death_cities.dart';
import '../../../../../core/utils/nullable.dart';
part 'ekram_request_transportation_event.dart';
part 'ekram_request_transportation_state.dart';

class EkramRequestTransportationBloc extends Bloc<
    EkramRequestTransportationEvent, EkramRequestTransportationState> {
  final GetEkramIdentityTypes _getEkramIdentityTypes;

  PageController controller = PageController();
  TransportRequestsBloc? ekramRequestsBloc;
  late List pagesList = [
    const DeceasedVerificationSection(),
    const DeceasedInfoSection(),
    const ApplicantInfoSection(),
    const DeathAndBurialInfoSection(),
    const EmirateApprovalInfoSection(),
    const DeceasedTransportationInfo()
  ];

  final GetCities _getCities;
  final GetHospitals _getHospitals;
  final GetNationalities _getNationalities;
  final ApplyDeceasedTransport _applyDeceasedTransport;
  final GetDeathCities _deathCities;
  final VerifyDeceased _verifyDeceased;

  EkramRequestTransportationBloc(
      {required GetCities getCities,
      required GetHospitals getHospitals,
      required GetNationalities getNationalities,
      required ApplyDeceasedTransport applyDeceasedTransport,
      this.ekramRequestsBloc})
      : _getEkramIdentityTypes = GetEkramIdentityTypes(repository: sl()),
        _getCities = getCities,
        _getHospitals = getHospitals,
        _getNationalities = getNationalities,
        _applyDeceasedTransport = applyDeceasedTransport,
        _deathCities = GetDeathCities(repository: sl()),
        _verifyDeceased = VerifyDeceased(repository: sl()),
        super(EkramRequestTransportationState(
            fullName: CommonProperties.userInfo?.arName ?? "",
            mobileNumber: CommonProperties.userInfo?.getPhone() ?? "",
            requestType: trans("ekram_request_type"))) {
    on<EkramRequestTransportationEvent>((event, emit) {});
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
    on<ChangeNationalityEvent>(_changeNationalityHanlder);

    on<GetHospitalsEvent>(_getHospitalsHandler);
    on<AddDeceasedEvent>(_addDeceasedHandler);
    on<DeleteDeceasedEvent>(_deleteDeceasedHandler);
    on<EditDeceasedEvent>(_editDeceasedHandler);
    on<AddFileEvent>(_addFileHandler);
    on<ChangeNationalIdDob>(_changeNationalIdDobHandler);
    on<ChangeIdEvent>(_changeIdHandler);
    on<VerifyDeceasedEvent>(_verifyDeceasedHandler);
    getNationalitiesHandler();
    getCitiesHandler();
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

  Future<void> _changeNationalityHanlder(
      ChangeNationalityEvent e, Emitter emitter) async {
    SaveDeceasedInfoParams? params = state.saveDeceasedInfoParams;
    params ??= SaveDeceasedInfoParams(
        deceasedInfo: DeceasedInfo(), mainInfo: MainInfo());

    DeceasedInfo info = params.deceasedInfo!;

    info = info.copyWith(nationalityId: e.item?.id!);
    params = params.copyWith(deceasedInfo: info);

    emitter(state.copyWith(
        errorMessage: "",
        status: BlocStatus.success,
        saveDeceasedInfoParams: params));
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

    final failureOrSuccess = await _getHospitals(e.city.id!);

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
        selectedCity: e.city,
        clearHospital: true,
        errorMessage: "",
      ));

      print("Succ3ess 555 ${state.hospitals}");
    });
  }

  Future<void> _addDeceasedHandler(AddDeceasedEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];

    DeceasedInfoDto info = e.data as DeceasedInfoDto;
    deceasedInfoDto.add(info);

    emitter(state.copyWith(
        status: BlocStatus.success, deceasedInfoDto: deceasedInfoDto));
  }

  Future<void> _editDeceasedHandler(
      EditDeceasedEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];

    DeceasedInfoDto info = e.data as DeceasedInfoDto;
    deceasedInfoDto[e.index] = info;

    emitter(state.copyWith(
        status: BlocStatus.success, deceasedInfoDto: deceasedInfoDto));
  }

  Future<void> _deleteDeceasedHandler(
      DeleteDeceasedEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];

    deceasedInfoDto.removeAt(e.index);

    emitter(state.copyWith(
        status: BlocStatus.success, deceasedInfoDto: deceasedInfoDto));

    CommonFunctions.showSuccess(trans("delete_deceassed_success"));
  }

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

    final failureOrSuccess = await _applyDeceasedTransport(ApplyDeceasedParams(
        deathCityId: state.selectedCity?.id,
        hospitalId: state.selectedHospital?.id,
        relationship: state.relation,
        locationAddress: state.deathLocation,
        deathTransferStatusId: 3,
        deceasedInfoDtoList: state.deceasedInfoDto,
        hospitalOtherName:
            state.selectedHospital?.id == -1 ? state.otherHospitalName : null,
        letter: state.letter));

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
      ekramRequestsBloc
          ?.add(GetDeceasedTransportRequestsEvent(isDriver: false));
      NavigationService.navigatorKey.currentState!.pushReplacementNamed(
          RouteName.successRoute,
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.ekramCemetry,
              thanksMessage: success.data?.responseMessage));

      CommonFunctions.sendUXCamEvent(UXCamEvents
          .RequestsTransportingAndPreparingDeceased_Open_Success_Page_Event);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.finishServiceBodyTransportation);
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
        addTransportBurialId:
            success.data?.result != null ? "${success.data?.result}" : null,
        errorMessage: "",
      ));
    });
  }
}
