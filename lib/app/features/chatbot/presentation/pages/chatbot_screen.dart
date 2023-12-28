import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/app_bar_chat_bot.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/chat_bot_list.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/send_mseeage_card_chat_bot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  ChatBotProvider provider = ChatBotProvider(sl());

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.openChatBotScreen);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => provider,
      child: const Scaffold(
        body: Column(
          children: [
            AppBarChatBot(),
            ChatBotList(),
            SendMessageCardChatBot(),
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
