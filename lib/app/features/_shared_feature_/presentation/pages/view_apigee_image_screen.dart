import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/constants.dart';

class ViewAPIGEEImageScreen extends StatefulWidget {
  String? imgUrl;
  String? xServiceId;
   ViewAPIGEEImageScreen({Key? key,this.imgUrl,this.xServiceId}) : super(key: key);

  @override
  State<ViewAPIGEEImageScreen> createState() => _ViewAPIGEEImageScreenState();
}

class _ViewAPIGEEImageScreenState extends State<ViewAPIGEEImageScreen> {
  @override
  Widget build(BuildContext context) {
    String url;
    if(widget.xServiceId == null) {
      url = ModalRoute
          .of(context)!
          .settings
          .arguments as String;
    }
    else
      {
        url = widget.imgUrl!;
      }



   var  headers= {
      "verifyingKEY": CommonFunctions.hashRequest(url, "GET",xserviceId: "0"),
    "Authorization": "Bearer ${CommonProperties.token}"};
    if(widget.xServiceId != null)
      {
        headers.addAll({"X-Service-Id":"0"});
      }

    return Stack(
      children: [
        PhotoView(
          imageProvider: NetworkImage(url,headers: headers ),
        ),
        Align(
          alignment: AlignmentDirectional.topStart,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).padding.top + 5, start: 12),
              child: Image.asset(
                Constants.imgPath + 'exit@3x.png',
                height: 38,
                width: 38,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
