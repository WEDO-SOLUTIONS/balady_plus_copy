import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, CommonFunctions;
import '../../shared_feature_exports.dart' show CustomIconButtonWidget;

abstract class _IconButton extends StatelessWidget {
  final Widget child;
  const _IconButton(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class IconButtonWidget extends _IconButton {
  ///
  IconButtonWidget.edit({required VoidCallback onPressed})
      : super(RotatedBox(
          quarterTurns: CommonFunctions.isAppAR ? 0 : 3,
          child: CustomIconButtonWidget(
            borderRadius: 8.0,
            backgroundColor: AppColor.gray,
            icon: Icons.edit_rounded,
            iconColor: AppColor.white,
            onPressed: onPressed,
          ),
        ));

  ///
  IconButtonWidget.close({required VoidCallback onPressed})
      : super(CustomIconButtonWidget(
          btnWidth: 40.0,
          btnHeight: 40.0,
          onPressed: onPressed,
          icon: Icons.close,
          iconSize: 24.0,
          iconColor: AppColor.white,
        ));
}
