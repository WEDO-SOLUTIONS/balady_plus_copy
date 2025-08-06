import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';

class NeedLoginDialog extends StatelessWidget {
  final String? img;
  final String? title;
  final String? desc;
  final String? mainPage;
  final Function(bool isSuccess)? onSuccessLogin;

  const NeedLoginDialog({Key? key, this.desc, this.img, this.title, this.mainPage, this.onSuccessLogin})
      : super(key: key);

  List<Widget> textActions(BuildContext context) => [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("notNow".tr()),
        ),
        TextButton(
          onPressed: () => CommonFunctions.onLogin(isMunicipality: true, mainPage: mainPage),
          child: Text("signInButton".tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ];

  Widget content({bool withoutActions = false}) {
    return NeedLoginWidget(
      img: img,
      title: title,
      desc: desc,
      onSuccessLogin: onSuccessLogin,
      mainPage: mainPage,
      withoutActions: withoutActions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: content(),
    );
  }
}
