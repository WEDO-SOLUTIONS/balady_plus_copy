// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
              margin: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /*  if (state.showChatHint == true)
                    Container(
                      height: 70,
                      width: 170,
                      decoration: BoxDecoration(
                        color: Color(0xffE8F2FD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "مرحبا!",
                                style: TextStyle(
                                    color: Color(0xff386E85),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<HomeBloc>().add(HideHintChat());
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 20,
                                  color: Color(0xff386E85),
                                ),
                              )
                            ],
                          ),
                          Text(
                            " انا مساعد كيف يمكني مساعدتك ",
                            style: TextStyle(
                                color: Color(0xff4C8EAA),
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),*/
                  Container(
                    height: 68,
                    width: 68,
                    decoration: BoxDecoration(
                      color: AppColor.statusAccentColor,
                      image: const DecorationImage(
                          alignment: Alignment.center,
                          scale: 2.5,
                          image: AssetImage(
                            "packages/smart_advisor/smart_advisor_assets/images/chatbot.png",
                          )),
                      borderRadius: BorderRadius.circular(34),
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
