import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../mvvm/chatboot_provider.dart';
import 'package:provider/provider.dart';
class ChatHistoryDetails extends StatefulWidget {
  const ChatHistoryDetails({Key? key}) : super(key: key);

  @override
  ChatDetailsBody createState() => ChatDetailsBody();
}



class ChatDetailsBody extends  State<ChatHistoryDetails>  {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext cont) {
    final chatBotProvider = ModalRoute.of(context)!.settings.arguments as ChatBotProvider;

    if(chatBotProvider.lstHistory.length ==0) {

    }

    return     Expanded(
      child: ListView.builder(
          padding: EdgeInsets.only(bottom: 50),
          itemCount: chatBotProvider.lstHistory.length,
          shrinkWrap: true,
          itemBuilder: (ctx, index) {

            return  ListTile(
                title: Text("test"),
                onTap: () => {


                  Navigator.of(context).pop()


                },
                trailing:  Wrap(
                  spacing:2, // space between two icons
                  children: <Widget>[
                    SvgPicture.asset(
                      IconPath.arrowLeft,
                      color: Colors.grey,
                    ),
                  ],
                )
            );
            // }
          }),
    );
  }
}
