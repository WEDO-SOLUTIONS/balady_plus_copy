import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/models/rating_request.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/models/services_types.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/widgets/submit_rating_widget.dart';
import 'package:balady_plus/app/features/chatbot/presentation/mvvm/chatboot_provider.dart';
import 'package:balady_plus/app/features/chatbot/presentation/widgets/close_chat_bot_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/local/navigation_services.dart';

class AppBarChatBot extends StatelessWidget {
  const AppBarChatBot({super.key});

  @override
  Widget build(BuildContext context) {
    ChatBotProvider provider = context.watch<ChatBotProvider>();
    return PopScope(
      // onPopInvoked: (bool didPop) async {
      //  // closeScreen(context, provider);
      // },
      // canPop: false,
      child: Container(
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
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top),
            Padding(
              padding: const EdgeInsets.only(bottom: 14, top: 8),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: ValueListenableBuilder<List>(
                  valueListenable: provider.chatBotMessage,
                  builder: (_, listMessages, child) {
                    List<Widget> list = [
                    SizedBox(
                        width: listMessages.isEmpty ? 85 : 45,
                        height: listMessages.isEmpty ? 85 : 45,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(
                              listMessages.isEmpty ? 14 : 7,
                            ),
                            child: Image.asset(IconPath.chatBot),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12, height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'chat_bot'.tr(),
                            style: AppStyle.countTextAthkarStyle.copyWith(),
                          )/*
                           const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "(${"beta".tr()})",
                            style: AppStyle.countTextAthkarStyle
                                .copyWith(color: AppColor.redBrown),
                          ),*/
                        ]
                      ),
                      listMessages.isEmpty
                          ? Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'chat_bot_message_welcome'.tr(),
                                  style: AppStyle
                                      .violationSelectOptionSubtitleStyle
                                      .copyWith(
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : const SizedBox()
                    ];
                    return Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: listMessages.isEmpty ? 14 : 6,
                            right: listMessages.isEmpty ? 0 : 40,
                          ),
                          child: listMessages.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: list,
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: list,
                                ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              IconButton(onPressed: () {
                               Scaffold.of(context).openDrawer();

                              },
                                icon: SvgPicture.asset(
                                  IconPath.chat_bot_side_menu_icon,
                                  ),
                                iconSize: 40 ,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),),



                              IconButton(
                                onPressed: () => closeScreen(context, provider),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                        ),

                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void closeScreen(BuildContext context, ChatBotProvider provider) {
    showDialog(
      context: context,
      builder: (_) => const CloseChatBotPopup(),
    ).then((value) {
      if (value == true) {
        // Navigator.of(context).popUntil((route) => route.isFirst);


        Navigator.of(context).pop();
        if (provider.chatBotMessage.value.isNotEmpty) {
          BottomSheetDialog.showSheet(
            context,
            child: SubmitRatingSheet(
              title: 'rating_chat_bot_title'.tr(),
              ratingRequest: RatingRequest(
                requestId: provider.sectionId,
                servicesTypeId: ServicesRatingType.chatBot,
              ),
            ),
            isFullHeight: false,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            height: MediaQuery.of(context).size.height * 0.65,
          );
        }
        // else
        //   {
        //     Navigator.of(context).pop();
        //   }
      }
    });
  }
}
