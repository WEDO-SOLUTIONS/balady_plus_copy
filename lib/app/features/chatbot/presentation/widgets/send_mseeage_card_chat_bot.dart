import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/border_types.dart';
import 'package:balady_plus/app/core/utils/extensions/enum_conversion.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message_model.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class SendMessageCardChatBot extends StatefulWidget {
  const SendMessageCardChatBot({super.key});

  @override
  State<SendMessageCardChatBot> createState() => _SendMessageCardChatBotState();
}

class _SendMessageCardChatBotState extends State<SendMessageCardChatBot> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ChatBotProvider provider = context.watch<ChatBotProvider>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        top: false,
        child: IgnorePointer(
          ignoring: false,
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    hintText: 'chat_bot_hint'.tr(),
                    fillColor: AppColor.blackModern100Light,
                    filled: true,
                    border: BorderType.outline.inputBorder(
                      color: AppColor.blackModern100Light,
                      radius: 8,
                    ),
                    enabledBorder: BorderType.outline.inputBorder(
                      color: AppColor.blackModern100Light,
                      radius: 8,
                    ),
                    focusedBorder: BorderType.outline.inputBorder(
                      color: AppColor.blackModern100Light,
                      radius: 8,
                    ),
                    errorBorder: BorderType.outline.inputBorder(
                      color: AppColor.error,
                      radius: 8,
                    ),
                  ),
                  // onSubmitted: (text) => sendMessage(provider, text),
                  textInputAction: TextInputAction.newline,
                ),
              ),
              const SizedBox(width: 16),
              Selector<ChatBotProvider, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (_, isLoading, __) {
                  return InkWell(
                    onTap: () => isLoading
                        ? provider.chatBotMessage.value.last.closeAnswer()
                        : sendMessage(provider),
                    child: CircleIcon(
                      icon: isLoading ? Icons.stop : IconPath.send,
                      iconSize: 24,
                      circleSize: 40,
                      backgroundColor: AppColor.primary900Light,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage(ChatBotProvider provider, [String? message]) {
    final text = message ?? _controller.text;
    if (text.isEmpty) return;
    // provider.setMessage(ChatBotMessageModel(message: text));
    if(provider.countFullUpQuestions.value >= 4) {
      provider.countFullUpQuestions.value = 0;
    }
    provider.sendQuestion(text);
    _controller.text = '';
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
