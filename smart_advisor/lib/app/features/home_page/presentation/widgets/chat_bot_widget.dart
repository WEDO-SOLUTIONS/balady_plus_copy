// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';

import '/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/features/home_page/presentation/bloc/home_bloc.dart';
import '/app/features/home_page/presentation/bloc/home_event.dart';
import '/app/features/home_page/presentation/bloc/home_state.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({super.key});

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              BaladyServices.openChatGPT();
            },
            child: Container(
              margin: EdgeInsets.all(30),
              height: 120,
              child: Stack(
                children: [
                  if (state.showChatHint == true)
                    Positioned(
                      left: 30,
                      child: Container(
                        height: 77,
                        width: 178,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF007AFF).withOpacity(
                                  0.05), // Blue color with 12% opacity
                              offset: Offset(
                                  0, 12), // X and Y offsets for the shadow
                              blurRadius: 20, // Blur radius
                              spreadRadius: 0, // Spread radius
                            ),
                          ],
                          image: DecorationImage(
                            image: AssetImage(
                                'packages/smart_advisor/smart_advisor_assets/images/messageframe.png'), // Replace with your image path
                            fit: BoxFit
                                .cover, // This ensures the image covers the entire container
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "مرحبا!",
                                  style: AppStyle.heading2BoldStyle.copyWith(
                                      fontSize: 16,
                                      color: AppColor.statusAccentColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<HomeBloc>()
                                        .add(HideHintChat());
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: AppColor.statusAccentColor,
                                  ),
                                )
                              ],
                            ),
                            Text(
                              "انا المساعد الذكي كيف يمكني مساعدتك",
                              style: AppStyle.textRegularStyle.copyWith(
                                  color: AppColor.textSecondaryColor,
                                  height: 1.3,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    left: 0,
                    bottom: 2,
                    child: Container(
                      height: 63,
                      width: 63,
                      decoration: BoxDecoration(
                        color: Color(0xFF8ABF97),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF007AFF).withOpacity(
                                0.12), // Blue color with 12% opacity
                            offset:
                                Offset(0, 12), // X and Y offsets for the shadow
                            blurRadius: 20, // Blur radius
                            spreadRadius: 0, // Spread radius
                          ),
                        ],
                        image: const DecorationImage(
                            alignment: Alignment.center,
                            scale: 2.5,
                            image: AssetImage(
                              "packages/smart_advisor/smart_advisor_assets/images/chatbot.png",
                            )),
                        borderRadius: BorderRadius.circular(34),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
