import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message.dart';
import 'package:flutter/material.dart';

class ChatBotBubble extends StatelessWidget {
  final ChatBotMessage chatMessage;

  const ChatBotBubble({
    super.key,
    required this.chatMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: chatMessage.isResponse
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: chatMessage.isResponse
                  ? AppColor.blackModern50Light
                  : AppColor.primary800Light,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: chatMessage.isResponse
                    ? Radius.zero
                    : const Radius.circular(10),
                topStart: chatMessage.isResponse
                    ? const Radius.circular(10)
                    : Radius.zero,
                bottomStart: const Radius.circular(10),
                bottomEnd: const Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.black.withOpacity(0.03),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: CustomTextWidget(
                chatMessage.message,
                textStyle: AppStyle.textFieldTitleTextStyle.copyWith(
                  color: chatMessage.isResponse
                      ? AppColor.blackModern700Light
                      : Colors.white,
                ),
                maxLines: 100,
              ),
            ),
          ),
          const SizedBox(height: 4),
          CustomTextWidget(
            chatMessage.timeStamp.toTime(),
            textStyle: AppStyle.dateTextStyle,
          ),
        ],
      ),
    );
  }
}
