import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/chatbot/data/models/chat_bot_message.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class AppBarChatBot extends StatelessWidget {

  const AppBarChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBotProvider provider = context.watch<ChatBotProvider>();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xff78EA06).withOpacity(.13),
              const Color(0xff78EA06).withOpacity(.10),
              const Color(0xff78EA06).withOpacity(.05),
              const Color(0xff78EA06).withOpacity(.03),
            ],
            begin: AlignmentDirectional.centerStart,
            end: AlignmentDirectional.bottomEnd,
            tileMode: TileMode.clamp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).viewPadding.top),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 16,
              left: 16,
              bottom: 16,
            ),
            child: ValueListenableBuilder<List<ChatBotMessage>>(
              valueListenable: provider.chatBotMessage,
              builder: (_, listMessages, child) {
                List<Widget> list = [
                  SizedBox(
                    width: listMessages.isEmpty ? 100 : 50,
                    height: listMessages.isEmpty ? 100 : 50,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(
                          listMessages.isEmpty ? 16 : 8,
                        ),
                        child: Image.asset(IconPath.chatBot),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12, height: 12),
                  Text(
                    'municipal_advisor'.tr(),
                    style: AppStyle.violationCreateTitle.copyWith(),
                  ),
                  listMessages.isEmpty
                      ? Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'chat_bot_message_welcome'.tr(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox()
                ];
                return listMessages.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: list,
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: list,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
