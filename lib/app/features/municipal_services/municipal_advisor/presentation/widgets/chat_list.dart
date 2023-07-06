import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../municipal_advisor_exports.dart'
    show ChatBubble, LoadingBubble, MunicipalAdvisorBloc, MunicipalAdvisorState;

class ChatList extends StatelessWidget {
  const ChatList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        if (state.messages.isEmpty) return const SizedBox.shrink();
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < state.messages.length; i++)
                  ChatBubble(
                    chatMessage: state.messages[i],
                    currentStep: i == state.messages.length - 1,
                  ),
                if (state.status == BlocRequestStatus.submissionGetLoading)
                  const LoadingBubble(),
              ],
            ),
          ),
        );
      },
    );
  }
}
