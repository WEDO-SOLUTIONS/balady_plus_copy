import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../municipal_advisor_exports.dart'
    show ChatBubble, LoadingBubble, MunicipalAdvisorBloc, MunicipalAdvisorState;

class ChatList extends StatefulWidget {
  const ChatList({
    super.key,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      },
      builder: (context, state) {
        if (state.messages.isEmpty) return const SizedBox.shrink();

        return Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
