import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../vd/vd_exports.dart' show GISParams, GISResponse, GetGISData;
import '../../municipal_advisor_exports.dart';

part 'municipal_advisor_event.dart';
part 'municipal_advisor_state.dart';

class MunicipalAdvisorBloc
    extends Bloc<MunicipalAdvisorEvent, MunicipalAdvisorState> {
  final GetConsultationKey _getConsultationKey;
  final GetIsicActivities _getIsicActivities;
  final GetIsicSubActivities _getIsicSubActivities;
  final GetActivityDetails _getActivityDetails;
  final GetGISData _getGISData;
  final GetCivilDefensePredefinedConditions
      _getCivilDefensePredefinedConditions;
  final GetCleaningMechanisms _getCleaningMechanisms;
  final GetCommercialOffices _getCommercialOffices;
  final GetIssuingPredefinedConditions _getIssuingPredefinedConditions;
  final GetLicensePermits _getLicensePermits;
  final GetSupervisingAuthorities _getSupervisingAuthorities;

  MunicipalAdvisorBloc({
    required GetConsultationKey getConsultationKey,
    required GetIsicActivities getIsicActivities,
    required GetIsicSubActivities getIsicSubActivities,
    required GetActivityDetails getActivityDetails,
    required GetGISData getGISData,
    required GetCivilDefensePredefinedConditions
        getCivilDefensePredefinedConditions,
    required GetCleaningMechanisms getCleaningMechanisms,
    required GetCommercialOffices getCommercialOffices,
    required GetIssuingPredefinedConditions getIssuingPredefinedConditions,
    required GetLicensePermits getLicensePermits,
    required GetSupervisingAuthorities getSupervisingAuthorities,
  })  : _getConsultationKey = getConsultationKey,
        _getIsicActivities = getIsicActivities,
        _getIsicSubActivities = getIsicSubActivities,
        _getActivityDetails = getActivityDetails,
        _getGISData = getGISData,
        _getCivilDefensePredefinedConditions =
            getCivilDefensePredefinedConditions,
        _getCleaningMechanisms = getCleaningMechanisms,
        _getCommercialOffices = getCommercialOffices,
        _getIssuingPredefinedConditions = getIssuingPredefinedConditions,
        _getLicensePermits = getLicensePermits,
        _getSupervisingAuthorities = getSupervisingAuthorities,
        super(const MunicipalAdvisorState()) {
    on<MunicipalAdvisorAddMessageEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
            messages: [
              ...state.messages,
              ChatMessage(
                message: event.message,
                step: event.step,
                data: event.data,
                isResponse: false,
              )
            ],
          ),
        );
        if (event.step == MunicipalAdvisorSteps.start) {
          final didGetKey = await getConsultationKeyEventHandler(event, emit);
          if (!didGetKey) {
            return;
          }
        }
        if (showNextSteps(event.step)) {
          final nextSteps = nextStep(
            state.changingInfo
                ? MunicipalAdvisorSteps.inputSummary
                : event.step,
            event.data,
          );
          if (event.step != MunicipalAdvisorSteps.start) await delay();
          for (int i = 0; i < nextSteps.length; i++) {
            emit(botResponse(event, nextSteps[i], i < nextSteps.length - 1));
            if (i != nextSteps.length - 1) await delay();
          }
        } else if (event.step == MunicipalAdvisorSteps.confirmLocation) {
          add(MunicipalAdvisorGetIsicActivitiesEvent());
        }
      },
    );

    on<MunicipalAdvisorGetConsultationKeyEvent>(
      (event, emit) async {
        await getConsultationKeyEventHandler(event, emit);
      },
    );

    on<MunicipalAdvisorGetGisLocationEvent>(
      (event, emit) async {
        emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
        final failureOrSuccess = await _getGISData(
          GISParams(x: event.latLng.longitude, y: event.latLng.latitude),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (gisResponse) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                gisResponse: gisResponse,
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectLocationEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            activityLocation: event.location,
            messages: [
              ...state.messages,
            ],
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.location.gisResponse.getFullAddress(),
          step: MunicipalAdvisorSteps.location,
          data: event.location.latLng,
        ));
      },
    );

    on<MunicipalAdvisorRemoveLastChatEvent>(
      (event, emit) {
        final messages = state.messages;
        messages.removeLast();
        messages.removeLast();
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            messages: [...messages],
          ),
        );
      },
    );

    on<MunicipalAdvisorGetIsicActivitiesEvent>(
      (event, emit) async {
        if (state.isicActivities.isNotEmpty) {
          emit(
            state.copyWith(
              status: BlocRequestStatus.submissionGetSuccess,
              messages: [
                ...state.messages,
                ...nextStep(MunicipalAdvisorSteps.confirmLocation),
              ],
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getIsicActivities(NoParams());
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (isicActivities) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                isicActivities: isicActivities,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.confirmLocation),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectIsicActivityEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedIsicActivity: event.isicActivity,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.isicActivity.name,
          step: MunicipalAdvisorSteps.activity,
          data: event.isicActivity.id,
        ));
        add(MunicipalAdvisorGetIsicSubActivitiesEvent(
          params: IsicSubActivityParams(
            id: event.isicActivity.id,
          ),
        ));
      },
    );

    on<MunicipalAdvisorGetIsicSubActivitiesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getIsicSubActivities(event.params);
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (isicSubActivities) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                isicSubActivities: isicSubActivities,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.activity),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectIsicSubActivityEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedIsicSubActivity: event.isicSubActivity,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.isicSubActivity.name,
          step: MunicipalAdvisorSteps.subActivity,
        ));
        add(MunicipalAdvisorGetActivityDetailsEvent());
      },
    );

    on<MunicipalAdvisorGetActivityDetailsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final params = ActivityDetailsParams(
          id: state.selectedIsicSubActivity!.id,
        );
        final failureOrSuccess = await _getActivityDetails(params);
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (activityDetails) {
            emit(
              state.copyWith(
                activityDetails: activityDetails,
              ),
            );
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.subActivity),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectAreaEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedArea: event.area,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: '${event.area.toStringAsFixed(0)} ${"m2".tr()}',
          step: MunicipalAdvisorSteps.area,
        ));
      },
    );

    on<MunicipalAdvisorChangeInfo>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.changeInfo ? 'yes'.tr() : 'no'.tr(),
          step: MunicipalAdvisorSteps.confirmInformation,
          data: event.changeInfo ? 'changeInfo' : null,
        ));
      },
    );

    on<MunicipalAdvisorChangeStepEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            changingInfo: true,
            lastEvent: event,
            messages: [
              ...state.messages,
              ChatMessage(
                message: event.message,
                step: MunicipalAdvisorSteps.changeInformation,
                isResponse: false,
              )
            ],
          ),
        );
        await delay();
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            messages: [
              ...state.messages,
              ...nextStep(event.step),
            ],
          ),
        );
      },
    );

    on<MunicipalAdvisorGetIssuingPredefinedConditionsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess =
            await _getIssuingPredefinedConditions(NoParams());
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (issuingPredefinedConditions) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                issuingPredefinedConditions: issuingPredefinedConditions,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.issuingPredefinedConditions,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetLicensePermitsEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetLicensePermitsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getLicensePermits(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (licensePermits) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                licensePermits: licensePermits,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.licensePermits),
                ],
              ),
            );
            add(MunicipalAdvisorGetCivilDefensePredefinedConditionsEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetCivilDefensePredefinedConditionsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getCivilDefensePredefinedConditions(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (civilDefensePredefinedConditions) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                civilDefensePredefinedConditions:
                    civilDefensePredefinedConditions,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.civilDefensePredefinedConditions,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetSupervisingAuthoritiesEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetSupervisingAuthoritiesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getSupervisingAuthorities(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (supervisingAuthorities) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                supervisingAuthorities: supervisingAuthorities,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.supervisingAuthorities,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetCleaningMechanismsEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetCleaningMechanismsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getCleaningMechanisms(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (cleaningMechanisms) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                cleaningMechanisms: cleaningMechanisms,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.cleaningMechanisms,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetCommercialOfficesEvent());
          },
        );
      },
    );
    on<MunicipalAdvisorGetCommercialOfficesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getCommercialOffices(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (commercialOffices) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                commercialOffices: commercialOffices,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.commercialOffices,
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorRetryEvent>(
      (event, emit) {
        if (state.lastEvent != null) add(state.lastEvent!);
      },
    );
  }

  Future<bool> getConsultationKeyEventHandler(event, emit) async {
    final userInfo = CommonProperties.userInfo;
    if (userInfo == null) {
      emit(
        state.copyWith(
          status: BlocRequestStatus.submissionGetFailure,
          errorMessage: 'user not found',
        ),
      );
    }
    emit(state.copyWith(
      lastEvent: MunicipalAdvisorGetConsultationKeyEvent(),
      status: BlocRequestStatus.submissionGetLoading,
    ));
    final failureOrSuccess = await _getConsultationKey(
      ConsultationKeyParams(
        mobile: userInfo!.getPhone(),
        submitterBirthDate: "1378/07/01",
        gender: userInfo.sex ?? "1",
      ),
    );
    return failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
        return false;
      },
      (consultationKey) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            consultationKey: consultationKey,
          ),
        );
        return true;
      },
    );
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  MunicipalAdvisorState botResponse(
    MunicipalAdvisorEvent event,
    ChatMessage message,
    bool loading,
  ) {
    return state.copyWith(
      status: loading
          ? BlocRequestStatus.submissionGetLoading
          : BlocRequestStatus.submissionGetSuccess,
      changingInfo: false,
      lastEvent: event,
      messages: [
        ...state.messages,
        message,
      ],
    );
  }

  bool showNextSteps(MunicipalAdvisorSteps step) {
    return step.index < MunicipalAdvisorSteps.confirmLocation.index ||
        step == MunicipalAdvisorSteps.area ||
        step == MunicipalAdvisorSteps.inputSummary ||
        step == MunicipalAdvisorSteps.confirmInformation;
  }

  List<ChatMessage> nextStep(MunicipalAdvisorSteps step, [dynamic data]) {
    switch (step) {
      case MunicipalAdvisorSteps.start:
        return [
          ChatMessage(
            message: 'municipalAdvisorWelcome'.tr(),
            step: MunicipalAdvisorSteps.start,
            isResponse: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorHint'.tr(),
            step: MunicipalAdvisorSteps.start,
            isResponse: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorTopic'.tr(),
            step: MunicipalAdvisorSteps.topic,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.topic:
        return [
          ChatMessage(
            message: 'municipalAdvisorLocation'.tr(),
            step: MunicipalAdvisorSteps.location,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.location:
        return [
          ChatMessage(
            message: 'municipalAdvisorLocationCorrect'.tr(),
            step: MunicipalAdvisorSteps.confirmLocation,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.confirmLocation:
        return [
          ChatMessage(
            message: 'municipalAdvisorActivity'.tr(),
            step: MunicipalAdvisorSteps.activity,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.activity:
        return [
          ChatMessage(
            message: 'municipalAdvisorSubActivity'.tr(),
            step: MunicipalAdvisorSteps.subActivity,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.subActivity:
        return [
          ChatMessage(
            message:
                '${'facilityType'.tr()}: ${state.activityDetails!.facilityName}',
            step: MunicipalAdvisorSteps.area,
            isResponse: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorArea'.tr(),
            step: MunicipalAdvisorSteps.area,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.area:
        return [
          ChatMessage(
            message: 'municipalAdvisorInputSummery'.tr(),
            step: MunicipalAdvisorSteps.inputSummary,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorConfirmSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.inputSummary:
        return [
          ChatMessage(
            message: 'municipalAdvisorConfirmSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.confirmInformation:
        if (data == 'changeInfo') {
          return [
            ChatMessage(
              message: 'municipalAdvisorChangeInfo'.tr(),
              step: MunicipalAdvisorSteps.changeInformation,
              isResponse: true,
            ),
          ];
        } else {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            add(MunicipalAdvisorGetIssuingPredefinedConditionsEvent());
          });

          return [
            ChatMessage(
              message: 'municipalAdvisorRequirements'.tr(),
              step: MunicipalAdvisorSteps.requirements,
              isResponse: true,
            ),
          ];
        }
      case MunicipalAdvisorSteps.changeInformation:
        return [
          ChatMessage(
            message: 'municipalAdvisorInputSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorConfirmSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.requirements:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.issuingPredefinedConditions,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.issuingPredefinedConditions:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.licensePermits,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.licensePermits:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.civilDefensePredefinedConditions,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.civilDefensePredefinedConditions:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.supervisingAuthorities,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.supervisingAuthorities:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.cleaningMechanisms,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.cleaningMechanisms:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.commercialOffices,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.commercialOffices:
        return [
          ChatMessage(
            message: 'municipalAdvisorFinancial'.tr(),
            step: MunicipalAdvisorSteps.continueToFinancial,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.continueToFinancial:
        return [];
    }
  }
}
