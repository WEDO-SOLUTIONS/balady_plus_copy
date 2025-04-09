import 'dart:async';

import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/lookups.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/use_cases/freelancer_certificate.dart';
import 'package:balady_plus/app/features/ceritified_observer/domain/use_cases/register_observer.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/pages/registration_sequence/conclusion_screen.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/pages/registration_sequence/fill_info_screen.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/pages/registration_sequence/pledge_question_screen.dart';
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
  final RegisterObserver _registerObserver;
  final CheckMuncipalityAcceptance _checkMuncipalityAcceptance;

  ////// For freelancer certificate
  CreateNewFreelancerCertificate _createNewFreelancerCertificateStatus;
  GetFreelancerCertificateStatus _getFreelancerCertificateStatus;
  UpdateFreelancerCertificate _updateFreelancerCertificateStatus;

  PageController controller = PageController();

  ChooseMuncipalityBloc()
      : _getRegisteredObserverStatus =
            GetRegisteredObserverStatus(repository: sl()),
        _getCityList = GetCityList(repository: sl()),
        _getDistrictList = GetDistrictList(repository: sl()),
        _getMuncipalityList = GetMuncipalityList(repository: sl()),
        _registerObserver = RegisterObserver(repository: sl()),
        _checkMuncipalityAcceptance =
            CheckMuncipalityAcceptance(repository: sl()),
        ////// For freelancer certificate
        _createNewFreelancerCertificateStatus =
            CreateNewFreelancerCertificate(repository: sl()),
        _getFreelancerCertificateStatus =
            GetFreelancerCertificateStatus(repository: sl()),
        _updateFreelancerCertificateStatus =
            UpdateFreelancerCertificate(repository: sl()),
        super(const LoadingApprovalState()) {
    // getObserverStatus("1006966525");

    on<GetObserverStatusEvent>(_etObserverStatus);

    add(GetObserverStatusEvent(
      // identityNumber: "1006966525",
      identityNumber: CommonProperties.userInfo?.idNo ?? "",
    ));

    ///////////////////////////////////////////////////////////
    on<SetRequestDataEvent>(_setRequestDataHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GoToNextPageEvent>(_goToNextPageHandler);

    /////////////////////////////////////////////
    on<SubmitCertifiedObserverRequestEvent>(_submitCertifiedObserverRequest);
    /////////////////////////////////////////////

    ///////// For Freelancer Certificate //////////

    on<CheckOnStateOfFreelancerCertificate>(
        _checkOnStateOfFreelancerCertificate);
    on<CreateNewFreelancerCertificateEvent>(_createNewFreelancerCertificate);
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
      (obj) {
        // check if the user is registered observer or not
        if (!obj.isCertifiedObserver) {
          // emitter(
          //   HaveFreelanceCertificateState(
          //     title: 'completing_the_certified_observer_request',
          //     description: 'no_have_freelancer_certificate_certified_observer',
          //     textAction: 'agree',
          //     icon: IconPath.elementsIcon,
          //   ),
          // );

          // emitter(
          //   const HaveFreelanceCertificateState(
          //     title: 'title_congratulations_certified_observer',
          //     description: 'description_monitoring_process_momtathel',
          //     textAction: 'open_momtathl_app',
          //     icon: IconPath.medalIcon,
          //   ),
          // );

          emitter(
            ChooseMuncipalityState(
              status: BlocStatus.success,
              pagesList: const [
                ChooseMuncipalityWidget(),
                FillInfoScreen(),
                PledgeQuestionScreen(),
                ConclusionScreen(),
              ],
              observerStatusEntity: obj,
              requestData: RegisterObserverRequest(
                mobileNumber: CommonProperties.userInfo?.phone ?? "",
              ),
              bankIbanController: TextEditingController(),
              emailController: TextEditingController(),
            ),
          );
          getMaritalStatusList();
          getDegreeList();
          getBanksList();
          getMuncipalityList();
        } else {
          add(CheckOnStateOfFreelancerCertificate(observerStatus: obj));
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
              currentPageValue: 1
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
  void getMaritalStatusList() async {
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

  void getDegreeList() async {
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

  void getBanksList() async {
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
          getCityList(state.requestData!.municipality!.strId!);
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

        emit(state.copyWith(
          status: BlocStatus.performing,
        ));
        controller.jumpToPage(prvoiusPage);

        emit(state.copyWith(
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
    //  if (state.status == BlocStatus.performing) return;

      emit(state.copyWith(
        status: BlocStatus.performing,
      ));
      int nextPage = state.currentPageValue + 1;


      controller.jumpToPage(nextPage);

      emit(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));


    }
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  FutureOr<void> _submitCertifiedObserverRequest(
      SubmitCertifiedObserverRequestEvent event,
      Emitter<CertifiedObserverState> emit) async {
    if (state is ChooseMuncipalityState) {
      ChooseMuncipalityState state = this.state as ChooseMuncipalityState;
      emit(state.copyWith(status: BlocStatus.loading));
      final failureOrSuccess = await _registerObserver(event.dataModel);
      failureOrSuccess.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BlocStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
        },
        (response) {
          emit(
            const WaitingApprovalState(),
          );
        },
      );
    }
  }

  FutureOr<void> _checkOnStateOfFreelancerCertificate(
      CheckOnStateOfFreelancerCertificate event,
      Emitter<CertifiedObserverState> emitter) async {
    // Hear The User is finished form the training and is Certified Observer
    if (event.observerStatus.qualification == "Qualified") {
      /// TODO : hear check if the user have the Freelance certificate
      // if (event.observerStatus.freelanceCertificateNumber?.isNotEmpty ??
      //     false) {
        /// TODO : if have show need check expiry date and states of the certificate
        var respons = await _getFreelancerCertificateStatus(NoParams());
        respons.fold((error) {
          emitter(
            const NoHaveFreelanceCertificateState(
              title: 'completing_the_certified_observer_request',
              description: 'no_have_freelancer_certificate_certified_observer',
              textAction: 'agree',
              icon: IconPath.elementsIcon,
            ),
          );
        }, (seccs) {
          if(seccs.isNotEmpty ==true) {
            emitter(
              const HaveFreelanceCertificateState(
                title: 'title_congratulations_certified_observer',
                description: 'description_monitoring_process_momtathel',
                textAction: 'open_momtathl_app',
                icon: IconPath.medalIcon,
              ),
            );
          }
          else
            {
                emitter(
                  const NoHaveFreelanceCertificateState(
                    title: 'completing_the_certified_observer_request',
                    description: 'no_have_freelancer_certificate_certified_observer',
                    textAction: 'agree',
                    icon: IconPath.elementsIcon,
                  ),
                );
            }
        });


     // }

      // else {
      //   /// TODO : if not have show show button create new Freelance certificate
      //   emitter(
      //     const NoHaveFreelanceCertificateState(
      //       title: 'completing_the_certified_observer_request',
      //       description: 'no_have_freelancer_certificate_certified_observer',
      //       textAction: 'agree',
      //       icon: IconPath.elementsIcon,
      //     ),
      //   );
      // }


    } else {
      //response.data!.result?.qualification == "Waiting for approval" ||
      //response.data!.result?.qualification == "Not qualified"
      emitter(
        WaitingApprovalState(observerStatusEntity: event.observerStatus),
      );
    }
  }

  FutureOr<void> _createNewFreelancerCertificate(
      CreateNewFreelancerCertificateEvent event,
      Emitter<CertifiedObserverState> emit) async {
    if (state is NoHaveFreelanceCertificateState) {
      NoHaveFreelanceCertificateState state =
          this.state as NoHaveFreelanceCertificateState;
      emit(
        state.copyWith(
          isLoading: true,
        ),
      );
      final failureOrSuccess =
          await _createNewFreelancerCertificateStatus(NoParams());
      failureOrSuccess.fold(
        (failure) {
          emit(
            NoHaveFreelanceCertificateState(
              isLoading: false,
              errorMessage: failure.toString(),
              icon: state.icon,
              title: state.title,
              description: state.description,
              textAction: state.textAction,
            ),
          );
        },
        (response) {
          emit(
            const HaveFreelanceCertificateState(
              title: 'title_congratulations_certified_observer',
              description: 'description_monitoring_process_momtathel',
              textAction: 'open_momtathl_app',
              icon: IconPath.medalIcon,
            ),
          );
        },
      );
    }
  }
}
