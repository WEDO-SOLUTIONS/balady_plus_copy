import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomIconButtonWidget, CustomSvgIconWidget, CustomVerticalSpace;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, IconPath;

Future<bool> showPopUpWidget(BuildContext context,
    {required Widget popUpBody}) async {
  return (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => CustomPopUp(
                child: popUpBody,
              ))) ??
      false;
}

class CustomPopUp extends StatelessWidget {
  final Widget child;

  const CustomPopUp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomIconButtonWidget(
                        btnPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const CustomSvgIconWidget(
                          IconPath.close,
                          iconSize: 12.0,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const CustomVerticalSpace(height: 5),
                  child,
                ],
              )),
        ],
      ),
    );
  }
}
