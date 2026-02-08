import 'package:flutter/cupertino.dart';

extension LayoutExt on double {
  SizedBox get widthBox => SizedBox(
        width: this,
      );

  SizedBox get heightBox => SizedBox(
        height: this,
      );
}
