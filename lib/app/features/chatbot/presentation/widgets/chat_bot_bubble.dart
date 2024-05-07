import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBotBubble extends StatelessWidget {
  final Widget body;
  final DateTime? timeStamp;
  final bool isResponse;

  const ChatBotBubble({
    super.key,
    required this.body,
    required this.timeStamp,
    this.isResponse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment:
            isResponse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isResponse
                  ? AppColor.blackModern50Light
                  : AppColor.primary800Light,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: isResponse ? Radius.zero : const Radius.circular(10),
                topStart: isResponse ? const Radius.circular(10) : Radius.zero,
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
              child: body,
            ),
          ),
          const SizedBox(height: 4, width: double.maxFinite),
          CustomTextWidget(
            timeStamp?.toTime() ?? "",
            textStyle: AppStyle.dateTextStyle,
          ),
        ],
      ),
    );
  }
}
