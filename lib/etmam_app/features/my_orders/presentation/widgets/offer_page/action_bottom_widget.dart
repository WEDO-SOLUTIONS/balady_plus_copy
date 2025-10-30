import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/icon_path.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class ActionBottomWidget extends StatelessWidget {
  final Function onDelete;
  final Function onEdit;
  final Function onSend;
  final bool? showDelete;
  final bool? showEdit;
  final bool? showSend;
  final String? deleteText;
  final String? editText;
  final String? sendText;

  const ActionBottomWidget(
      {super.key,
      required this.onDelete,
      required this.onEdit,
      required this.onSend,
      this.showDelete,
      this.showEdit,
      this.showSend,
      this.deleteText,
      this.editText,
      this.sendText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      margin: EdgeInsets.only(
        bottom: 30,
      ),
      // color: AppColors.white,
      // height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (showSend ?? false)
            ActionBottomItem(
              icon: IconPath.delegateBiddingIcon,
              name: sendText ?? "",
              onClick: onSend,
            ),
          if (showEdit ?? false)
            ActionBottomItem(
              icon: IconPath.editBiddingIcon,
              name: editText ?? "",
              onClick: onEdit,
            ),
          if (showDelete ?? false)
            ActionBottomItem(
              icon: IconPath.deleteBiddingIcon,
              name: deleteText ?? "",
              onClick: onDelete,
            ),
        ],
      ),
    );
  }
}

class ActionBottomItem extends StatelessWidget {
  final String icon;
  final String name;
  final Function onClick;
  const ActionBottomItem(
      {super.key,
      required this.icon,
      required this.name,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Column(
        children: [
          CustomSvgIconWidget(
            icon,
            iconSize: 48,
          ),
          CustomVerticalSpace(height: 8),
          CustomTextWidget(
            name,
            fontColor: Colors.black,
            fontSize: 13,
            fontWeight: AppFontWeight.medium,
          )
        ],
      ),
    );
  }
}
