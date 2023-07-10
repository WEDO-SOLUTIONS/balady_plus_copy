import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, DateTimeExtension, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../municipal_advisor_exports.dart'
    show
        ChatBubbleCurrentStep,
        LocationChatBubble,
        ChatMessage,
        MunicipalAdvisorSteps;

class ChatBubble extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool currentStep;

  const ChatBubble({
    super.key,
    required this.chatMessage,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final showMap = chatMessage.step == MunicipalAdvisorSteps.location &&
        !chatMessage.isResponse &&
        chatMessage.data is LatLng;
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showMap) ...[
                    LocationChatBubble(latLng: chatMessage.data),
                    const SizedBox(height: 8),
                  ],
                  if (showMap)
                    Row(
                      children: [
                        const DrawIconBasedTypeWidget(
                          icon: IconPath.marker,
                        ),
                        const SizedBox(width: 4),
                        CustomTextWidget(
                          chatMessage.message,
                          textStyle: AppStyle.chatMessageTextStyle.copyWith(
                            color: chatMessage.isResponse
                                ? AppColor.blackModern700Light
                                : null,
                          ),
                        ),
                      ],
                    )
                  else
                    CustomTextWidget(
                      chatMessage.message,
                      textStyle: AppStyle.chatMessageTextStyle.copyWith(
                        color: chatMessage.isResponse
                            ? AppColor.blackModern700Light
                            : null,
                      ),
                      maxLines: 100,
                    ),
                  if (currentStep && chatMessage.isResponse)
                    ChatBubbleCurrentStep(step: chatMessage.step)
                ],
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
