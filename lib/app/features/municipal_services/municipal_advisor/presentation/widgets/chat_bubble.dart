import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';


import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, DateTimeExtension, IconPath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../municipal_advisor_exports.dart'
    show
        ChatBubbleCurrentStep,
        ChatBubbleStepData,
        ChatMessage,
        LocationChatBubble,
        MunicipalAdvisorSteps;

class ChatBubble extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool currentStep;
  final bool isLastResponse;

  const ChatBubble({
    super.key,
    required this.chatMessage,
    required this.currentStep,
    required this.isLastResponse,
  });

  @override
  Widget build(BuildContext context) {
    final showMap = chatMessage.step == MunicipalAdvisorSteps.location &&
        !chatMessage.isResponse &&
        chatMessage.data is LatLng;
    final bool currentActiveStep = currentStep &&
        chatMessage.isResponse &&
        isLastResponse &&
        !chatMessage.customWidget;
    return Padding(
      padding: EdgeInsets.all(currentActiveStep ? 16 : 8.0),
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
                maxWidth: MediaQuery.of(context).size.width *
                    (currentActiveStep ? 0.9 : 0.7),
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
                        SizedBox(
                          width: (MediaQuery.of(context).size.width * 0.7) - 40,
                          child: CustomTextWidget(
                            chatMessage.message,
                            textStyle: AppStyle.chatMessageTextStyle.copyWith(
                              color: chatMessage.isResponse
                                  ? AppColor.blackModern700Light
                                  : null,
                            ),
                            maxLines: 2,
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
                        fontSize: currentStep &&
                                chatMessage.isResponse &&
                                !chatMessage.customWidget &&
                                isLastResponse
                            ? 16
                            : null,
                      ),
                      maxLines: 100,
                    ),
                  if (chatMessage.customWidget)
                    ChatBubbleStepData(chatMessage: chatMessage)
                  else if (currentActiveStep)
                    ChatBubbleCurrentStep(
                      step: chatMessage.step,
                      data: chatMessage.data,
                    ),
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
