import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/app_colors.dart';
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
    return CupertinoAlertDialog(
      // insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      // isDefaultAction: true,
      // onPressed: () {
      //   Navigator.of(context).pop();
      // },
      // child: const Text("shady"),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        decoration: BoxDecoration(color: AppColor.white, borderRadius: BorderRadius.circular(12)),
        child: NeedLoginWidget(
          img: img,
          title: title,
          desc: desc,
          onSuccessLogin: onSuccessLogin,
          mainPage: mainPage,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("notNow".tr()),
        ),
        // TextButton(
        //   onPressed: () => Navigator.of(context).pop(false),
        //   child: Text("notNow".tr()),
        // ),
      ],
    );
  }
}
