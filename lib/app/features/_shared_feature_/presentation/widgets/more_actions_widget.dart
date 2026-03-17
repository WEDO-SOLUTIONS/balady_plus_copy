import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;
import '../../shared_feature_exports.dart'
    show BottomSheetDialog, CustomIconButtonWidget;

class MoreActionsWidget extends StatelessWidget {
  final Widget action;
  const MoreActionsWidget({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25.0,
      child: Align(
        // color: Colors.blue,
        alignment: AlignmentDirectional.centerEnd,
        child: CustomIconButtonWidget(
          onPressed: () async => await BottomSheetDialog.showSheet(
            context,
            backgroundColor: Colors.transparent,
            child: action,
          ),
          btnHeight: 20.0,
          btnWidth: 20.0,
          icon: Icons.more_horiz,
          iconColor: AppColor.white,
          iconSize: 14.0,
          backgroundColor: AppColor.gray,
          borderRadius: 6.0,
        ),
      ),
    );
  }
}
