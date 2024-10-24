import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../mvvm/chatboot_provider.dart';
import 'package:provider/provider.dart';
class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  ChatHistoryBody createState() => ChatHistoryBody();
}



class ChatHistoryBody extends  State<ChatHistory>  {

  @override
  void initState() {
   Provider.of<ChatBotProvider>(context, listen: false).getSesionHistory( CommonProperties.userInfo?.idNo??"");
    super.initState();
  }

  @override
  Widget build(BuildContext cont) {

    ChatBotProvider provider =
    Provider.of<ChatBotProvider>(context, listen: true);

    return Drawer(
      child:  Column(

        children: [
          Container(
          width: double.infinity,
            height: 250,
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
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(

                    width:  85 ,
                    height: 85,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(
                          14 ,
                        ),
                        child: Image.asset(IconPath.chatBot),
                      ),
                    ),
                  ),

                  Text(
                    'chat_bot'.tr(),
                    style: AppStyle.countTextAthkarStyle.copyWith(),
                  )
                ],
              ),
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'history'.tr(),
                  style: AppStyle.countTextAthkarStyle.copyWith(color:  Colors.grey),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
                padding: EdgeInsets.only(bottom: 50),
                itemCount: provider.lstOldSession.length,
                shrinkWrap: true,
            
                separatorBuilder: (context, index)
                {
            
                  return Divider(
                    color: Colors.grey,
                  );
            
                },
                itemBuilder: (ctx, index) {
            
                    return  ListTile(
                      title: Text(provider.lstOldSession[index].summary??"",maxLines: 1,),
                      onTap: () => {

                        provider.getSesionDetails(provider.lstOldSession[index].sessionId!),
                      //  Navigator.of(context).pop(),


            
            
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
          ),
        ],
      ),







    );
  }
}
