import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../widgets/need_login_widget.dart';

class NeedLoginDialog extends StatelessWidget {
  final String? img;
  final String? title;
  final String? desc;
  final String? mainPage;
  final Function(bool isSuccess)? onSuccessLogin;

  const NeedLoginDialog({
    Key? key,
    this.desc,
    this.img,
    this.title,
    this.mainPage,
    this.onSuccessLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         Navigator.of(context).pop();
                  //       },
                  //       child: Image.asset(
                  //         IconPath.qrWhiteCloseIcon,
                  //         height: 16.0,
                  //         width: 16.0,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  NeedLoginWidget(
                    img: img,
                    title: title,
                    desc: desc,
                    onSuccessLogin: onSuccessLogin,
                    mainPage: mainPage,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
