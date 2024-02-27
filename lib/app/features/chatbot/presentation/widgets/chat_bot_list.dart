import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/message_chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/chat_bot_bubble.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/message_bot_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class ChatBotList extends StatelessWidget {
  const ChatBotList({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBotProvider provider = context.watch<ChatBotProvider?>()!;

    return Expanded(
      child: ValueListenableBuilder<List>(
        valueListenable: provider.chatBotMessage,
        builder: (_, listMessages, child) {
          return ListView.builder(
            controller: provider.scrollController,
            itemBuilder: (_, index) {
              // int size = listMessages.length - 1;
              // ChatBotMessageEntities message = listMessages[index];
              // return ChatBotBubble(chatMessage: listMessages[index]);
              return MessageBotBubble(messageProvide: listMessages[index]);
            },
            itemCount: listMessages.length,
            // reverse: true,
          );
        },
      ),
    );
  }
}
