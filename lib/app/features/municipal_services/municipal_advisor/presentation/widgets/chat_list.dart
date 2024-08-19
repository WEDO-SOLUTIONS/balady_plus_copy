import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../municipal_advisor_exports.dart'
    show
        ChatBubble,
        LoadingBubble,
        MunicipalAdvisorBloc,
        MunicipalAdvisorState,
        RetryBubble;

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
        if (state.messages.isNotEmpty &&
            state.messages.last.isResponse &&
            state.messages.last.message == "municipalAdvisorPermitsCost".tr()) {
          return;
        }
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

        return Stack(
          children: [
            SizedBox.expand(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < state.messages.length; i++)
                      ChatBubble(
                        chatMessage: state.messages[i],
                        currentStep:
                        state.currentStep == state.messages[i].step,
                        isLastResponse: state.messages.last.isResponse,
                      ),
                    if (state.status ==
                        BlocRequestStatus.submissionGetLoading)
                      const LoadingBubble(),
                    if (state.status ==
                        BlocRequestStatus.submissionGetFailure)
                      const RetryBubble(),
                  ],
                ),
              ),
            ),

            //////////////////////////////////
            // Align(
            // alignment: AlignmentDirectional.topStart,
            //   child: Padding(
            //     padding: const EdgeInsets.all(16),
            //     child: InkWell(
            //       onTap: () {
            //         Navigator.of(context).pushNamed(RouteName.chatbot);
            //       },
            //       radius: 40,
            //       child: SizedBox(
            //         height: 57,
            //         width: 57,
            //         child: CircleAvatar(
            //           backgroundColor: const Color(0xff1E697F),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.max,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               SvgPicture.asset(
            //                 IconPath.chat_bot_icon,
            //                 width: 20,
            //                 height: 20,
            //               ),
            //               Text(
            //                 'chat_bot'.tr(),
            //                 style: const TextStyle(
            //                   fontSize: 11,
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.w900,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

          ],
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
