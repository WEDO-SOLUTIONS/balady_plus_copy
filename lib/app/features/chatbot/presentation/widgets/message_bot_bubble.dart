import 'dart:async';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/chatbot/domain/entities/chat_bot_message_entities.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/message_chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/chat_bot_bubble.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../municipal_services/municipal_advisor/presentation/widgets/loading_bubble.dart';
import 'message_chat_text.dart';

class MessageBotBubble extends StatelessWidget {
  final MessageChatBotProvider messageProvide;

  const MessageBotBubble({super.key, required this.messageProvide});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: messageProvide,
      child: Selector<MessageChatBotProvider, bool>(
          selector: (_, provider) => provider.isLoading,
          builder: (_, isLoading, __) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ChatBotBubble(
                    body: CustomTextWidget(
                      messageProvide.message.value.question,
                      // "\u0631,\u0631, \u0631,\u0631,\u0631, \u0631",
                      textStyle: AppStyle.textFieldTitleTextStyle.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 100,
                    ),
                    timeStamp: messageProvide.message.value.timeStampSend,
                    // messageProvide.message.value,
                  ),
                  isLoading
                      ? const LoadingBubble()
                      :
                  ////////////////////////////////////////////////////////
                  Selector<MessageChatBotProvider, StreamSubscription?>(
                    selector: (_, provider) => provider.listen,
                    builder: (_, listen, __) {
                      // provider.isLoading = isLoading;
                      return ChatBotBubble(
                        body: Wrap(
                          alignment: WrapAlignment.end,
                          children: [
                            ValueListenableBuilder<
                                ChatBotMessageEntities>(
                              valueListenable: messageProvide.message,
                              builder: (_, listMessages, child) {
                                return MessageChatText(
                                  text: messageProvide
                                      .message.value.answer, provider: messageProvide,);
                              },
                            ),

                            Selector<MessageChatBotProvider, bool>(
                              selector: (_, provider) =>
                              provider.isLoading,
                              builder: (_, isLoading, __) {
                                // provider.isLoading = isLoading;
                                return isLoading
                                    ? const CustomCircularLoadingWidget()
                                    : messageProvide
                                    .message.value.haveError
                                    ? CustomPrimaryButton(
                                  onPressed: () {
                                    messageProvide.sendQuestion(
                                      messageProvide.message
                                          .value.question,
                                    );
                                  },
                                  btnText: 'retry'.tr(),
                                )
                                    : const SizedBox();
                              },
                            ),
                          ],
                        ),
                        timeStamp: messageProvide
                            .message.value.timeStampReceived,
                        isResponse: true,
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
