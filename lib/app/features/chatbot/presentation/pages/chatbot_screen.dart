import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/app_bar_chat_bot.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/chat_bot_list.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/send_mseeage_card_chat_bot.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
}
