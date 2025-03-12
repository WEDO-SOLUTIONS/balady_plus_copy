import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/app_bar_chat_bot.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/chat_bot_list.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/prompt_questions_widget.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/send_mseeage_card_chat_bot.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../data/models/session_details.dart';
import '../widgets/chat_history.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  ChatBotProvider provider = ChatBotProvider(
    sl(),
    sectionId: DateTime.now().millisecondsSinceEpoch,
  );

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.openChatBotScreen);
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;

    SessionDetails? intailData = data is SessionDetails ? data : null;
    if (intailData != null) {
      provider.intaiteChat(intailData);
    }

    return ChangeNotifierProvider(
      create: (context) => provider,
      child: Scaffold(
        drawer: ChatHistory(),
        body: Column(
          children: [
            const AppBarChatBot(),
            Expanded(
              child: Selector<ChatBotProvider, bool>(
                selector: (_, provider) => provider.isLoadingEnabled,
                builder: (_, isLoading, __) {
                  return isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.isEnabled
                          ? Column(
                              children: [
                                ChatBotList(),
                                PromptQuestionsWidget(),
                                SendMessageCardChatBot(),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'chat_bot_not_working_title'.tr(),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'chat_bot_not_working_message'.tr(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    CommonFunctions.sendUXCamEvent(UXCamEvents.closeChatBotScreen);
    super.deactivate();
  }
}
