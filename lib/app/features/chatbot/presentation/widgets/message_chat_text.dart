import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';

class MessageChatText extends StatelessWidget {
  final String text;
  const MessageChatText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: (link) => CommonFunctions.openBaladyWebView(link.url),
      text: text,
      softWrap: true,
      textAlign: TextAlign.start,
      style: AppStyle.textFieldTitleTextStyle.copyWith(
        color: AppColor.blackModern700Light,
      ),
    );
  }
}
