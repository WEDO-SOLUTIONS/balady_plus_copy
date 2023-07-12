import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../municipal_advisor_exports.dart';

part 'municipal_advisor_event.dart';
part 'municipal_advisor_state.dart';

class MunicipalAdvisorBloc
    extends Bloc<MunicipalAdvisorEvent, MunicipalAdvisorState> {
  final GetIsicActivities getIsicActivities;
  final GetIsicSubActivities getIsicSubActivities;
  final GetActivityDetails getActivityDetails;

  MunicipalAdvisorBloc({
    required this.getIsicActivities,
    required this.getIsicSubActivities,
    required this.getActivityDetails,
  }) : super(const MunicipalAdvisorState()) {
    on<MunicipalAdvisorAddMessageEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
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
        if (showNextSteps(event.step)) {
          final nextSteps = nextStep(
            state.changingInfo
                ? MunicipalAdvisorSteps.inputSummary
                : event.step,
            event.data,
          );
          await delay();
          for (int i = 0; i < nextSteps.length; i++) {
            emit(botResponse(event, nextSteps[i], i < nextSteps.length - 1));
            if (i != nextSteps.length - 1) await delay();
          }
        } else if (event.step == MunicipalAdvisorSteps.confirmLocation) {
          add(MunicipalAdvisorGetIsicActivitiesEvent());
        }
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
          message: event.location.address,
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
        final failureOrSuccess = await getIsicActivities(NoParams());
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
        final failureOrSuccess = await getIsicSubActivities(event.params);
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
        final failureOrSuccess = await getActivityDetails(params);
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

    on<MunicipalAdvisorRetryEvent>(
      (event, emit) {
        if (state.lastEvent != null) add(state.lastEvent!);
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
        return [];
    }
  }
}
