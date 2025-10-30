import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../mvvm/message_chatboot_provider.dart';

class MessageChatText extends StatelessWidget {
  final String text;
  final MessageChatBotProvider provider;
  const MessageChatText({super.key, required this.text,required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Linkify(
          onOpen: (link) => CommonFunctions.openBaladyWebView(link.url),
          text: text,
          softWrap: true,
          textAlign: TextAlign.start,
          style: AppStyle.textFieldTitleTextStyle.copyWith(
            color: AppColor.blackModern700Light,
          ),
        ),
        Row(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [


            IconButton(onPressed: () {
              if( provider.message.value.messID != null) {
                provider.sendFeedBack(provider.message.value.messID!, true);
              }
              else
                {
                  CommonFunctions.showError("cannotdothisaction".tr());
                }

            },
              icon: SvgPicture.asset(
                IconPath.chat_bot_like_icon,
                color:  provider.message.value.isLiked == true?Colors.blue:Colors.grey,),
              iconSize: 30 ,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),),


            IconButton(onPressed: () {
              if( provider.message.value.messID != null) {
                provider.sendFeedBack(provider.message.value.messID!, false);
              }
              else

                {
                  CommonFunctions.showError("cannotdothisaction".tr());
                }

            },

              icon: SvgPicture.asset(
                IconPath.chat_bot_dislike_icon,
                color:  provider.message.value.isLiked == false?Colors.blue:Colors.grey,
              ),iconSize: 30 ,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),),


            IconButton(onPressed: () async {

              await Clipboard.setData(ClipboardData(text: provider.message.value.answer));
              CommonFunctions.showSuccess("answer_copy_to_Clipboard".tr());

            }, icon: SvgPicture.asset(
              IconPath.chat_bot_copy_icon,
              color:  Colors.grey,
            ),iconSize: 30 ,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),),


            // IconButton(onPressed: () {  }, icon: SvgPicture.asset(
            //   IconPath.chat_bot_like_icon,
            //   color:  Colors.grey,
            // ),iconSize: 30 ,
            //   padding: EdgeInsets.zero,
            //   constraints: BoxConstraints(),),


          ],
        )
      ],
    );
  }
}
