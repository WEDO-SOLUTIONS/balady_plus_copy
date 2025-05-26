import 'package:balady_plus/app/features/ekram/domain/use_cases/get_cemetries.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:collection/collection.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/nullable.dart';
import '../../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../../domain/entities/active_grave_request_params.dart';
import '../../../domain/entities/deceased_transport_requests/get_orgnizations_params.dart';
import '../../../domain/entities/get_cemetries_params.dart';
import '../../../domain/entities/user_info_request_params.dart';
import '../../../domain/use_cases/baquie_approval.dart';
import '../../../domain/use_cases/check_user_info.dart';
import '../../../domain/use_cases/get_active_grave_request_details.dart';
import '../../../domain/use_cases/get_burial_cities.dart';
import '../../../domain/use_cases/get_ekram_lookups.dart';
import '../../../domain/use_cases/get_nationality_types.dart';
import '../../../domain/use_cases/get_orgnizations.dart';

part 'ekram_add_deceased_event.dart';
part 'ekram_add_deceased_state.dart';

class EkramAddDeceasedBloc
    extends Bloc<EkramAddDeceasedEvent, EkramAddDeceasedState> {
  final GetBurialCities _getCities;
  final GetNationalities _getNationalities;
  final BaquieApproval _baquieApproval;
  final GetEkramLookUp _getEkramLookUp;
  final CheckUserinfo _checkUserInfo;
  final GetCemetries _getCemetries;
  final GetEkramOrgnizations _getEkramOrgnizations;
  final GetNationalityTypes _getNationalityTypes;
  final GetActiveGraveRequestDetails getActiveGraveRequestDetails;
  final nationalIdController = TextEditingController();

  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final thirdNameController = TextEditingController();
  final fourthNameController = TextEditingController();

  EkramAddDeceasedBloc(
      {required GetNationalities getNationalities,
      required AddDeceasedDialogParams params})
      : _getCities = GetBurialCities(repository: sl()),
        _getNationalities = getNationalities,
        _getEkramLookUp = GetEkramLookUp(repository: sl()),
        _checkUserInfo = CheckUserinfo(repository: sl()),
        _getCemetries = GetCemetries(repository: sl()),
        getActiveGraveRequestDetails =
            GetActiveGraveRequestDetails(repository: sl()),
        _getNationalityTypes = GetNationalityTypes(repository: sl()),
        _getEkramOrgnizations = GetEkramOrgnizations(repository: sl()),
        _baquieApproval = BaquieApproval(repository: sl()),
        super(EkramAddDeceasedState(
            deathCity: params.deathCity,
            cities: params.cities,
            nationalities: params.nationalities,
            data: params.data.copyWith(deathCity: params.deathCity))) {
    on<EkramAddDeceasedEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ChangeNameEvent>(_changeNameHandler);
    on<ChangeGenderEvent>(_changeGenderHanlder);
    on<ChangeReligionEvent>(_changeReligionHanlder);
    on<ChangeNationalityEvent>(_changeNationalityHanlder);
    on<ChangeBurialDestinationEvent>(_changeBurialDestinationHanlder);
    on<ChangeBurialDestinationCityEvent>(_changeBurialDestinationCityHanlder);
    on<ChangeIsNeedSpecialTransferEvent>(_changeIsNeedSpecialTransferHanlder);
    on<ChangeNeedSpecialTransferEvent>(_changeNeedSpecialTransferHandler);
    on<ChangeNeedSpecialTransferReasonEvent>(
        _changeNeedSpecialTransferReasonHandler);

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
    on<ChangeIsEpidamicEvent>(_changeIsEpidamicHandler);

    on<ChangePermitNumberEvent>(_changePermitNoHandler);

    on<SelectOrgnizationEvent>(_changeOrgnizationHandler);
    on<GetBaquieApprovalEvent>(_getBaquieApprovalHandler);
    getNationalTypesHandler();
    getCitiesHandler();
    getCemetryTypeItemsHandler();
    getBurialTimesItemsHandler();
  }

  Future<void> _getBaquieApprovalHandler(
      GetBaquieApprovalEvent e, Emitter emitter) async {
    emitter(state.copyWith(errorMessage: "", status: BlocStatus.loading));

    final failOrSuccess = await _baquieApproval(ActiveGraveRequestParams(
        idNo: state.data.deceassedId ?? "",
        idType: state.data.selectedNationalType?.id ?? 0));

    failOrSuccess.fold((l) {
      emitter(state.copyWith(errorMessage: "", status: BlocStatus.failure));
    }, (r) {
      emitter(state.copyWith(
        errorMessage: "",
        status: BlocStatus.success,
        data: state.data.copyWith(baqieApproval: Nullable(r)),
      ));
    });
  }

  Future<void> _changeOrgnizationHandler(
      SelectOrgnizationEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      errorMessage: "",
      data: state.data.copyWith(selectedOrgnization: e.item),
    ));
  }

  Future<void> _changePermitNoHandler(
      ChangePermitNumberEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        data: state.data.copyWith(permitNo: e.text), errorMessage: ""));
  }

  Future<void> _changeNameHandler(ChangeNameEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        data: state.data.copyWith(
          firstName: e.firstName != null ? Nullable(e.firstName) : null,
          secondName: e.secondName != null ? Nullable(e.secondName) : null,
          thirdName: e.thirdName != null ? Nullable(e.thirdName) : null,
          fourthName: e.fourthName != null ? Nullable(e.fourthName) : null,
        ),
        errorMessage: ""));
  }

  Future<void> _changeGenderHanlder(
      ChangeGenderEvent e, Emitter emitter) async {
    if (!state.isFormDisabled()) {
      emitter(state.copyWith(
        errorMessage: "",
        data: state.data.copyWith(gender: Nullable(e.item)),
      ));
    }
  }

  Future<void> _changeReligionHanlder(
      ChangeReligionEvent e, Emitter emitter) async {
    if (!state.isFormDisabled()) {
      emitter(state.copyWith(
        errorMessage: "",
        data: state.data.copyWith(isMuslim: Nullable(e.item)),
      ));
    }
  }

  Future<void> _changeNationalityHanlder(
      ChangeNationalityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      errorMessage: "",
      data: state.data.copyWith(nationalityId: Nullable(e.item)),
    ));
  }

  Future<void> _changeBurialDestinationHanlder(
      ChangeBurialDestinationEvent e, Emitter emitter) async {
    if (!state.isFormDisabled()) {
      emitter(state.copyWith(
          errorMessage: "",
          data: state.data.copyWith(multipleCityRequest: !e.sameCity!)));
    }
  }

  Future<void> _changeBurialDestinationCityHanlder(
      ChangeBurialDestinationCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      errorMessage: "",
      data: state.data.copyWith(burialCityId: e.item),
    ));
  }

  Future<void> _changeIsNeedSpecialTransferHanlder(
      ChangeIsNeedSpecialTransferEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        data: state.data.copyWith(specialTransferNeeded: e.isNeeded)));
  }

  Future<void> _changeNeedSpecialTransferHandler(
      ChangeNeedSpecialTransferEvent e, Emitter emitter) async {
    print(state.data.specialTransferReasonId);
    emitter(state.copyWith(
      errorMessage: "",
      data: state.data.copyWith(specialTransferReasonId: Nullable(e.item)),
    ));
  }

  Future<void> _changeNeedSpecialTransferReasonHandler(
      ChangeNeedSpecialTransferReasonEvent e, Emitter emitter) async {
    emitter(state.copyWith(
      errorMessage: "",
      data: state.data.copyWith(specialTransferOtherReason: Nullable(e.text)),
    ));
  }

  Future<List<LookUpItem>?> getOrgnizations() async {
    if (state.data.selectedCemetry == null ||
        state.data.burialDateGorgian == null ||
        state.data.selectedTime == null) {
      CommonFunctions.showError("FillFields".tr());
      return null;
    }
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

    final failureOrSuccess = await _getEkramOrgnizations(GetOrgnizationsParams(
        deathCityId: state.deathCity!.id!,
        transportLocationId: 3,
        cemeteryId: state.data.selectedCemetry!.id!,
        burialDate: state.data.burialDateGorgian!,
        burailTimeId: state.data.selectedTime!.id!));
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        orgnizations: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getSpecialReasonsLookUp() async {
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

    final failureOrSuccess = await _getEkramLookUp("SPECIAL_TRANSPORT_REASONS");
    return failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
      return null;
    }, (success) {
      emit(state.copyWith(
        status: BlocStatus.success,
        specialNeeds: success.data?.result,
        errorMessage: "",
      ));
      return success.data?.result;
    });
  }

  Future<List<LookUpItem>?> getCitiesHandler() async {
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

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

  Future<List<LookUpItem>?> getNationalitiesHandler() async {
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

    final failureOrSuccess = await _getNationalities(null);

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

  Future<void> _changeNationalIdHandler(
      ChangeNationalId e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        data: state.data.copyWith(
            deceassedId: Nullable(e.text),
            userInfoResponse: Nullable(null),
            firstName: Nullable(null),
            secondName: Nullable(null),
            baqieApproval: Nullable(null),
            thirdName: Nullable(null),
            fourthName: Nullable(null),
            deceassedDOBGorgian: Nullable(null),
            deceassedDOBHijri: Nullable(null),
            isMuslim: Nullable(null),
            gender: Nullable(null),
            nationalityId: Nullable(null))));

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
        errorMessage: "",
        data: state.data.copyWith(
            deceassedDOBGorgian:
                Nullable(CommonFunctions.padHijriDate(gorgian)),
            deceassedDOBHijri: Nullable(CommonFunctions.padHijriDate(hijri)),
            userInfoResponse: Nullable(null))));
  }

  Future<void> _changeNationalTypeHandler(
      ChangeNationalType e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        data: state.data.copyWith(
          selectedNationalType: e.item,
          userInfoResponse: Nullable(null),
          nationalityId: Nullable(null),
          firstName: Nullable(null),
          secondName: Nullable(null),
          thirdName: Nullable(null),
          fourthName: Nullable(null),
          deceassedDOBGorgian: Nullable(null),
          deceassedDOBHijri: Nullable(null),
          isMuslim: Nullable(null),
          gender: Nullable(null),
        )));
    firstNameController.text = "";
    secondNameController.text = "";
    thirdNameController.text = "";
    fourthNameController.text = "";
  }

  Future<void> _changeBurialCityEventHandler(
      ChangeBurialCityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        cemetries: [],
        data: state.data.copyWith(
            burialCityId: e.item,
            selectedCemetry: Nullable(null),
            baqieApproval: Nullable(null))));

    //getCemetriesHandler();
  }

  Future<void> _changeCemetryTypeEventHandler(
      ChangeCemetryTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        cemetries: [],
        data: state.data.copyWith(
            selectedCemetryType: e.item,
            selectedCemetry: Nullable(null),
            baqieApproval: Nullable(null))));

    //  getCemetriesHandler();
  }

  Future<void> _changeIsEpidamicHandler(
      ChangeIsEpidamicEvent e, Emitter emitter) async {
    if (!state.isFormDisabled()) {
      emitter(state.copyWith(
          errorMessage: "",
          cemetries: [],
          data: state.data.copyWith(
              isPandemicDeath: e.value,
              selectedCemetry: Nullable(null),
              baqieApproval: Nullable(null))));
    }

    // getCemetriesHandler();
  }

  Future<void> _changeCemetryEventHandler(
      ChangeCemetryEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        data: state.data.copyWith(selectedCemetry: Nullable(e.item))));

    if (e.item?.id == 249) {
      add(GetBaquieApprovalEvent());
    }
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
        errorMessage: "",
        cemetries: [],
        data: state.data.copyWith(
            burialDateGorgian: CommonFunctions.padHijriDate(gorgian),
            selectedCemetry: Nullable(null),
            baqieApproval: Nullable(null),
            burialDateHijri: CommonFunctions.padHijriDate(hijri))));
    // getCemetriesHandler();
  }

  Future<void> _changeBurialTimeventHandler(
      ChangeBurialTimevent e, Emitter emitter) async {
    emitter(state.copyWith(
        errorMessage: "",
        cemetries: [],
        data: state.data.copyWith(
            selectedTime: e.item,
            selectedCemetry: Nullable(null),
            baqieApproval: Nullable(null))));
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
        errorMessage: "",
        data: state.data.copyWith(
          otherTimeName: Nullable(formatted),
        )));
  }

  Future<void> _checkUserInfoHandler(
      CheckUserInfoEvent e, Emitter emitter) async {
    if (state.nationalities?.isEmpty ?? true) {
      await getNationalitiesHandler();
    }

    emitter(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

    final failOrSuccess = await getActiveGraveRequestDetails(
        ActiveGraveRequestParams(
            idNo: state.data.deceassedId ?? "",
            idType: state.data.selectedNationalType?.id ?? 0));

    await failOrSuccess.fold((l) async {
      if (state.data.selectedNationalType?.fillInfo == true) {
        CommonFunctions.showSuccess("ekram_retrive_data_success_msg".tr());
        emitter(state.copyWith(
          status: BlocStatus.success,
          errorMessage: "",
        ));
        return;
      }

      emitter(state.copyWith(status: BlocStatus.loading));

      final failureOrSuccess = await _checkUserInfo(UserInfoRequestParams(
          dob: state.data.deceassedDOBHijri ?? "",
          nationalId: state.data.deceassedId ?? "",
          identityType: state.data.identityType ?? 0));

      failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) {
        String firstName = success.data?.result?.deceasedInfo?.firstName ?? "";
        String secondName =
            success.data?.result?.deceasedInfo?.secondName ?? "";
        String thirdName = success.data?.result?.deceasedInfo?.thirdName ?? "";
        String fourthName =
            success.data?.result?.deceasedInfo?.fourthName ?? "";
        // int? gender = success.data?.result?.genderCode;
        bool? isMuslim = success.data?.result?.deceasedInfo?.isMuslim;

        LookUpItem? nationality = state.nationalities?.firstWhereOrNull(
            (element) =>
                element.id ==
                success.data?.result?.deceasedInfo?.nationalityId);
        emitter(state.copyWith(
            status: BlocStatus.success,
            cemetries: [],
            errorMessage: "",
            data: state.data.copyWith(
                // userInfoResponse: Nullable(success.data?.result),
                selectedCemetry: Nullable(null),
                baqieApproval: Nullable(null),
                firstName: Nullable(firstName),
                secondName: Nullable(secondName),
                thirdName: Nullable(thirdName),
                fourthName: Nullable(fourthName),
                // gender: Nullable(gender),
                nationalityId: Nullable(nationality),
                isMuslim: Nullable(isMuslim))));

        firstNameController.text = firstName;
        secondNameController.text = secondName;
        thirdNameController.text = thirdName;
        fourthNameController.text = fourthName;
      });
    }, (r) async {
      String firstName = r.data?.result?.deceasedInfo?.firstName ?? "";
      String secondName = r.data?.result?.deceasedInfo?.secondName ?? "";
      String thirdName = r.data?.result?.deceasedInfo?.thirdName ?? "";
      String fourthName = r.data?.result?.deceasedInfo?.fourthName ?? "";
      int? gender = r.data?.result?.deceasedInfo?.gender == "MALE" ? 1 : 2;
      bool? isMuslim = r.data?.result?.deceasedInfo?.isMuslim;

      LookUpItem? nationality = state.nationalities?.firstWhereOrNull(
          (element) =>
              element.id == r.data?.result?.deceasedInfo?.nationalityId);

      LookUpItem? nationalType = state.nationalTypes?.firstWhereOrNull(
          (element) =>
              element.id == r.data?.result?.deceasedInfo?.identityType);
      emitter(state.copyWith(
          status: BlocStatus.success,
          cemetries: [],
          errorMessage: "",
          data: state.data.copyWith(
            graveDetails: Nullable(r.data?.result),
            selectedCemetryType: LookUpItem(
              id: r.data?.result?.burialInfo?.graveTypeId,
              name: r.data?.result?.burialInfo?.graveTypeName,
            ),
            selectedNationalType: nationalType,
            isPandemicDeath: r.data?.result?.burialInfo?.isPandemicDeath,
            burialCityId: LookUpItem(
                id: r.data?.result?.burialInfo?.cemeteryInfo?.municipality
                    ?.cityId,
                name: r.data?.result?.burialInfo?.cemeteryInfo?.municipality
                    ?.cityName),
            selectedTime: LookUpItem(
              id: r.data?.result?.burialInfo?.prayId,
              name: r.data?.result?.burialInfo?.prayName,
            ),
            multipleCityRequest: !(r.data?.result?.burialInfo?.cemeteryInfo
                    ?.municipality?.cityId ==
                r.data?.result?.burialInfo?.deathCityId),
            otherBurialCity: r.data?.result?.burialInfo?.deathCityOther,
            firstName: Nullable(firstName),
            secondName: Nullable(secondName),
            thirdName: Nullable(thirdName),
            fourthName: Nullable(fourthName),
            gender: Nullable(gender),
            nationalityId: Nullable(nationality),
            isMuslim: Nullable(isMuslim),
          )));

      add(ChangeNationalIdDob(
          hijriDate: r.data?.result?.deceasedInfo?.birthDate));

      add(ChangeBurialDateEvent(
        gorgianDate: r.data?.result?.burialInfo?.getHijriDate(),
      ));

      await Future.delayed(Duration(seconds: 1));
      if (r.data?.result?.burialInfo?.getHijriDate() != null) {
        emitter(state.copyWith(
            status: BlocStatus.success,
            data: state.data.copyWith(
                selectedCemetry: Nullable(LookUpItem(
              id: r.data?.result?.burialInfo?.cemeteryInfo?.cemeteryId,
              name: r.data?.result?.burialInfo?.cemeteryInfo?.cemeteryName,
            )))));
      }

      firstNameController.text = firstName;
      secondNameController.text = secondName;
      thirdNameController.text = thirdName;
      fourthNameController.text = fourthName;
      CommonFunctions.showSuccess("ekram_retrive_grave_data_success_msg"
          .tr()
          .replaceAll("{}", r.data?.result?.deceasedInfo?.fullName ?? ""));
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

  Future<List<LookUpItem>?> getCemetryTypeItemsHandler() async {
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

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
    emit(state.copyWith(
      status: BlocStatus.loading,
      errorMessage: "",
    ));

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

  Future<List<LookUpItem>?> getCemetriesHandler() async {
    if (state.data.selectedCemetryType != null &&
            (state.data.burialCityId != null &&
                state.data.multipleCityRequest == true) ||
        (state.data.multipleCityRequest == false) &&
            state.data.burialDateHijri != null &&
            state.data.burialDateGorgian != null &&
            state.data.isPandemicDeath != null &&
            state.data.nationalityId != null &&
            state.data.isMuslim != null &&
            state.data.selectedTime != null) {
      emit(state.copyWith(status: BlocStatus.loading));

      final failureOrSuccess = await _getCemetries(GetCemetriesParams(
          burialCityId: state.data.multipleCityRequest == true
              ? state.data.burialCityId!.id!
              : state.deathCity!.id!,
          cemeteryTypeId: state.data.selectedCemetryType!.id!,
          burialDate: state.data.burialDateGorgian!,
          isPandemicDeath: state.data.isPandemicDeath!,
          nationalityId: state.data.nationalityId!.id!,
          isFetus: false,
          isMuslim: state.data.isMuslim!,
          birthdate: state.data.deceassedDOBHijri,
          burailTimeId: state.data.selectedTime!.id!));

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

  bool numberOnlyInNationalId() {
    return [1, 3, 9, 10].contains(state.data.selectedCemetryType?.id);
  }

  String? validateNationalId(String? input) {
    if (state.data.selectedNationalType?.id == 1) {
      if (!(input?.startsWith("1") ?? false) || (input?.length ?? 0) < 10) {
        return "wrong_input_data".tr();
      } else {
        return null;
      }
    } else if (state.data.selectedNationalType?.id == 3) {
      if (!(input?.startsWith("2") ?? false) || (input?.length ?? 0) < 10) {
        return "wrong_input_data".tr();
      } else {
        return null;
      }
    } else if (state.data.selectedNationalType?.id == 9 ||
        state.data.selectedNationalType?.id == 10) {
      if ((input?.startsWith("2") ?? false) ||
          (input?.startsWith("1") ?? false) ||
          (input?.length ?? 0) < 10) {
        return "wrong_input_data".tr();
      } else {
        return null;
      }
    }
    return null;
  }
}
