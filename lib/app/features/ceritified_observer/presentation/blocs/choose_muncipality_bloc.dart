import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/pages/registration_sequence/fill_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../domain/entity/observer_status_entity.dart';
import '../../domain/entity/register_observer_request.dart';
import '../../domain/use_cases/check_muncipality_acceptance.dart';
import '../../domain/use_cases/get_city_list.dart';
import '../../domain/use_cases/get_muncipality_list.dart';
import '../../domain/use_cases/get_registered_observer_status.dart';
import '../widget/choose_muncipality_widget.dart';

part 'choose_muncipality_state.dart';

part 'choose_muncipality_event.dart';

class ChooseMuncipalityBloc
    extends Bloc<ChooseMuncipalityEvent, CertifiedObserverState> {
  final GetRegisteredObserverStatus _getRegisteredObserverStatus;
  final GetMuncipalityList _getMuncipalityList;
  final GetCityList _getCityList;
  final GetDistrictList _getDistrictList;

  final CheckMuncipalityAcceptance _checkMuncipalityAcceptance;

  PageController controller = PageController();

  ChooseMuncipalityBloc()
      : _getRegisteredObserverStatus =
            GetRegisteredObserverStatus(repository: sl()),
        _getCityList = GetCityList(repository: sl()),
        _getDistrictList = GetDistrictList(repository: sl()),
        _getMuncipalityList = GetMuncipalityList(repository: sl()),
        _checkMuncipalityAcceptance =
            CheckMuncipalityAcceptance(repository: sl()),
        super(ChooseMuncipalityState(pagesList: const [])) {
    // getObserverStatus("1006966525");

    on<GetObserverStatusEvent>(_etObserverStatus);

    add(GetObserverStatusEvent(identityNumber: "1006966525"));

    ///////////////////////////////////////////////////////////
    on<SetRequestDataEvent>(_setRequestDataHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GoToNextPageEvent>(_goToNextPageHandler);
  }

  Future<void> _etObserverStatus(
      GetObserverStatusEvent e, Emitter emitter) async {
    emitter(const LoadingApprovalState());
    final failureOrSuccess =
        await _getRegisteredObserverStatus(e.identityNumber);
    failureOrSuccess.fold(
      (failure) {
        emitter(
          FailureApprovalState(failure: failure.toString()),
        );
      },
      (response) {
        ObserverStatusEntity obj =
            (response.data!.result) as ObserverStatusEntity;
        if (obj.isCertifiedObserver == true) {
          emitter(
            ChooseMuncipalityState(
              status: BlocStatus.success,
              pagesList: const [ChooseMuncipalityWidget(), FillInfoScreen()],
              observerStatusEntity: obj,
              requestData: RegisterObserverRequest(),
            ),
          );
          getMuncipalityList();
        } else {
          if (response.data!.result?.qualification == "Waiting for approval") {
            emitter(
              WaitingApprovalState(observerStatusEntity: obj),
            );
          }
        }
      },
    );
  }

  ///// Start Location   Functions
  Future<void> getMuncipalityList() async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      emit(
        state.copyWith(status: BlocStatus.loading),
      );
      final failureOrSuccess = await _getMuncipalityList(null);
      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BlocStatus.failure,
            ),
          );
          CommonFunctions.showError(
              failure is ServerFailure ? (failure).errorMessage : "");
        },
        (response) {
          List<LookUpItem> lstMunicipalityLookUp = [];
          if (response.data != null &&
              response.data!.result != null &&
              response.data!.result!.isNotEmpty) {
            for (var item in response.data!.result!) {
              lstMunicipalityLookUp.add(LookUpItem(
                  strId: item.municipalityID, name: item.municipalityName));
            }
          }
          emit(
            state.copyWith(
              status: BlocStatus.success,
              lstMunicipalityLookUp: lstMunicipalityLookUp,
            ),
          );
        },
      );
    }
  }

  Future<void> getCityList(String municipalityID) async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      emit(
        state.copyWith(status: BlocStatus.loading),
      );
      final failureOrSuccess = await _getCityList(municipalityID);
      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BlocStatus.failure,
            ),
          );
          CommonFunctions.showError(
            failure is ServerFailure ? (failure).errorMessage : "",
          );
        },
        (response) {
          List<LookUpItem> lstCites = [];
          if (response.data != null &&
              response.data!.result != null &&
              response.data!.result!.isNotEmpty) {
            for (var item in response.data!.result!) {
              lstCites.add(
                LookUpItem(
                  strId: item.cityID,
                  name: item.cityName,
                ),
              );
            }
          }
          emit(
            state.copyWith(
              status: BlocStatus.success,
              lstCitesLookUp: lstCites,
            ),
          );
        },
      );
    }
  }

  Future<void> getDistrictByCityIdList(String cityId) async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      emit(state.copyWith(status: BlocStatus.loading));
      final failureOrSuccess = await _getDistrictList(cityId);
      failureOrSuccess.fold(
        (failure) {
          emit(state.copyWith(status: BlocStatus.failure));
          CommonFunctions.showError(
            failure is ServerFailure ? (failure).errorMessage : "",
          );
        },
        (response) {
          List<LookUpItem> lstDistrict = [];
          if (response.isNotEmpty) {
            for (var item in response) {
              lstDistrict.add(
                LookUpItem(
                  strId: item.districtID,
                  name: item.districtName,
                ),
              );
            }
          }

          ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
          emit(
            state.copyWith(
              status: BlocStatus.success,
              lstDistrictLookUp: lstDistrict,
            ),
          );
        },
      );
    }
  }

  ///// End Location   Functions
  Future<void> getMaritalStatusList() async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      List<LookUpItem>? lstMaritalStatus = MaritalStatus.values
          .map(
            (maritalStatus) => LookUpItem(
              id: maritalStatus.index,
              name: maritalStatus.name.tr(),
            ),
          )
          .toList();
      emit(
        state.copyWith(
          status: BlocStatus.success,
          lstMaritalStatus: lstMaritalStatus,
        ),
      );
    }
  }

  Future<void> getDegreeList() async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      List<LookUpItem>? lstDegrees = Degree.values
          .map(
            (degree) => LookUpItem(id: degree.index, name: degree.name.tr()),
          )
          .toList();
      emit(
        state.copyWith(
          status: BlocStatus.success,
          lstDegrees: lstDegrees,
        ),
      );
    }
  }

  ////// Bank Functions

  Future<void> getBanksList() async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      List<LookUpItem>? lstBanks = Bank.values
          .map(
            (bank) => LookUpItem(
              id: (bank.index + 1),
              name: bank.name.tr(),
            ),
          )
          .toList();
      emit(
        state.copyWith(
          status: BlocStatus.success,
          lstBanks: lstBanks,
        ),
      );
    }
  }

  Future<void> _setRequestDataHandler(
      SetRequestDataEvent e, Emitter emitter) async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      emitter(state.copyWith(requestData: e.dataModel));
    }
  }

  Future<void> checkMuncipalityAcceptance() async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      emit(
        state.copyWith(status: BlocStatus.loading),
      );
      final failureOrSuccess = await _checkMuncipalityAcceptance(
        state.requestData?.municipality!.strId,
      );
      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BlocStatus.failure,
              isAcceptNewObservers: false,
            ),
          );
          CommonFunctions.showError(
            failure is ServerFailure ? (failure).errorMessage : "",
          );
        },
        (response) {
          emit(
            state.copyWith(
              status: BlocStatus.success,
              isAcceptNewObservers: (response.data!.result) as bool,
            ),
          );
          _getCityList(state.requestData?.municipality!.strId);
          if (response.data!.result == true) {
            add(const GoToNextPageEvent());
          }
        },
      );
    }
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      if (state.currentPageValue == 0) {
        NavigationService.navigatorKey.currentState!.pop();
      } else {
        if (state.status == BlocStatus.performing) return;
        int prvoiusPage = state.currentPageValue - 1;

        emitter(state.copyWith(
          status: BlocStatus.performing,
        ));
        controller.jumpToPage(prvoiusPage);

        emitter(state.copyWith(
          status: BlocStatus.success,
          currentPageValue: prvoiusPage,
        ));
      }
      hideKeyboard();
    }
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      controller.jumpToPage(nextPage);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));

      // if (nextPage == 1) {
      //   add(getRequestDetailsEvent(requestId: state.requestId!));
      // }
    }
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
