import 'package:balady_new_app/app/core/shared_local_services/common.dart';
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:balady_new_app/shared/core/data/models/lookup_item_model.dart';
import 'package:balady_new_app/shared/core/errors/errors_exports.dart';
import 'package:balady_new_app/shared/core/services/local/use_case.dart';
import 'package:balady_new_app/shared/core/utils/common_properties.dart';
import 'package:balady_new_app/shared/core/utils/enums/bloc_status.dart';

import 'package:balady_new_app/shared/core/services/services_exports.dart'
    show NavigationService;
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:balady_new_app/shared/features/_shared_feature_/shared/data/entities/file_data_item.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:balady_new_app/app/core/core_exports.dart' show RoutesNames;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'ekram_request_transportation_event.dart';

part 'ekram_request_transportation_state.dart';

class EkramRequestTransportationBloc extends Bloc<
    EkramRequestTransportationEvent, EkramRequestTransportationState> {
  PageController controller = PageController();
  EkramRequestsBloc? ekramRequestsBloc;
  late List pagesList = [
    ApplicantInfoSection(),
    DeceasedInfoSection(),
    DeathAndBurialInfoSection(),
    AgreementSection()
  ];

  final GetCities _getCities;
  final GetHospitals _getHospitals;
  final GetNationalities _getNationalities;
  final ApplyDeceasedTransport _applyDeceasedTransport;

  EkramRequestTransportationBloc(
      {required GetCities getCities,
      required GetHospitals getHospitals,
      required GetNationalities getNationalities,
      required ApplyDeceasedTransport applyDeceasedTransport,
      this.ekramRequestsBloc})
      : _getCities = getCities,
        _getHospitals = getHospitals,
        _getNationalities = getNationalities,
        _applyDeceasedTransport = applyDeceasedTransport,
        super(EkramRequestTransportationState(
            fullName: CommonProperties.getSSOProfile?.arName ?? "",
            mobileNumber: CommonProperties.getSSOProfile?.getPhone() ?? "",
            requestType: trans("ekram_request_type"))) {
    on<EkramRequestTransportationEvent>((event, emit) {});
    on<ChangeAgreementEvent>(_changeAgreementHandler);
    on<SelectHospitalEvent>(_selectHospitalHanlder);
    on<SubmitRequestEvent>(_submitRequestEvent);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GoToNextPageEvent>(_goToNextPageHandler);

    on<ChangeRelationShipEvent>(_changeRelationShipHanlder);
    on<ChangeDeathLocationEvent>(_changeDeathLocationHanlder);

    on<ChangeHospitalOtherNameEvent>(_changeOtherHospitalNameHanlder);

    /*  on<GetCitiesEvent>(_getCitiesHandler);
    on<GetNationalitiesEvent>(_getNationalitiesHandler);*/
    on<GetHospitalsEvent>(_getHospitalsHandler);
    on<AddDeceasedEvent>(_addDeceasedHandler);
    on<DeleteDeceasedEvent>(_deleteDeceasedHandler);
    on<EditDeceasedEvent>(_editDeceasedHandler);
    on<AddFileEvent>(_addFileHandler);
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

  Future<void> _getHospitalsHandler(
      GetHospitalsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getHospitals(e.city.id!);

    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      success.data?.result
          ?.insert(0, LookUpItemModel(id: -1, name: trans("other_hospital")));

      emitter(state.copyWith(
        status: BlocStatus.success,
        hospitals: success.data?.result,
        selectedCity: e.city,
        clearHospital: true,
        errorMessage: "",
      ));
    });
  }

  Future<void> _addDeceasedHandler(AddDeceasedEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];

    if (e != null) {
      DeceasedInfoDto info = e.data as DeceasedInfoDto;
      deceasedInfoDto.add(info);
    }

    emitter(state.copyWith(
        status: BlocStatus.success, deceasedInfoDto: deceasedInfoDto));
  }

  Future<void> _editDeceasedHandler(
      EditDeceasedEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<DeceasedInfoDto> deceasedInfoDto = state.deceasedInfoDto ?? [];

    if (e != null) {
      DeceasedInfoDto info = e.data as DeceasedInfoDto;
      deceasedInfoDto[e.index] = info;
    }

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

    showSuccess(trans("delete_deceassed_success"));
  }

  Future<void> _addFileHandler(AddFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    emitter(state.copyWith(status: BlocStatus.success, letter: e.data));
  }

  Future<void> _submitRequestEvent(
      SubmitRequestEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
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
          RoutesNames.ekramSuccessScreen,
          arguments: success.data?.responseMessage);
    });
  }

  void cancelRequest() {
    hideKeyboard();
    NavigationService.navigatorKey.currentState!
        .popUntil(ModalRoute.withName(RoutesNames.bottomNavigationRoute));
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
