import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../municipal_advisor_exports.dart';

part 'municipal_advisor_event.dart';
part 'municipal_advisor_state.dart';

class MunicipalAdvisorBloc
    extends Bloc<MunicipalAdvisorEvent, MunicipalAdvisorState> {
  MunicipalAdvisorBloc() : super(const MunicipalAdvisorState()) {
    on<MunicipalAdvisorStartChatEvent>(
      (event, emit) async {
        emit(userResponse(event.message));
        await delay();
        final nextSteps = nextStep(event.step);
        for (int i = 0; i < nextSteps.length; i++) {
          emit(botResponse(nextSteps[i], i < nextSteps.length - 1));
          if (i != nextSteps.length - 1) await delay();
        }
      },
    );
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  MunicipalAdvisorState userResponse(String message) {
    return state.copyWith(
      status: BlocRequestStatus.submissionGetLoading,
      messages: [
        ...state.messages,
        ChatMessage(
          message: message,
          step: MunicipalAdvisorSteps.start,
          isResponse: false,
        )
      ],
    );
  }

  MunicipalAdvisorState botResponse(
    ChatMessage message,
    bool loading,
  ) {
    return state.copyWith(
      status: loading
          ? BlocRequestStatus.submissionGetLoading
          : BlocRequestStatus.submissionGetSuccess,
      messages: [
        ...state.messages,
        message,
      ],
    );
  }

  List<ChatMessage> nextStep(MunicipalAdvisorSteps step) {
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
            message: 'municipalAdvisorLocation'.tr(),
            step: MunicipalAdvisorSteps.location,
            isResponse: true,
          ),
        ];
    }
  }
}
